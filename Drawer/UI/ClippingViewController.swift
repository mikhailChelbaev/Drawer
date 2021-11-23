//
//  ClippingViewController.swift
//  Drawer
//
//  Created by Mikhail on 16.11.2021.
//

import UIKit

final class ClippingViewController: DrawingViewController {
    
    typealias EncodedLine = (Int, Int)
    
    enum LineState {
        case visible, partlyVisible, invisible
    }
    
    enum Step {
        case drawLines
        case drawRectangle
        case viewClipArea
        case clip
        
        func text() -> String {
            switch self {
            case .drawLines:
                return "Hint: draw lines"
            case .drawRectangle:
                return "Hint: select clipping area"
            case .viewClipArea:
                return "Go to next step to clip"
            case .clip:
                return "Reset to start again"
            }
        }
        
        func next() -> Self {
            switch self {
            case .drawLines:
                return .drawRectangle
            case .drawRectangle:
                return .viewClipArea
            case .viewClipArea:
                return .clip
            case .clip:
                return .clip
            }
        }
    }
    
    private let actionTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .medium)
        return label
    }()
    
    private var changeStepButton: UIButton!
    
    private var cleanButton: UIButton!
    
    private let lineDrawer: ShapeDrawer = LineDrawer()
    
    private var lines: [Line] = []
    
    private var lineStates: [LineState: [Line]] = [:]
    
    private var clippingArea: Rectangle!
    
    private var step: Step = .drawLines {
        didSet { update() }
    }
    
    override func loadView() {
        view = UIView()
        changeStepButton = createButton(title: "Next step")
        cleanButton = createButton(title: "Reset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        commonInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        board = Board(size: imageView.frame.size, color: .systemBlue)
    }
    
    private func setUpNavBar() {
        title = "Clipping"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeController))
    }
    
    private func commonInit() {
        view.backgroundColor = .white
        
        actionTitle.text = step.text()
        
        changeStepButton.addTarget(self, action: #selector(changeStep), for: .touchUpInside)
        cleanButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        view.addSubview(imageView)
        imageView.stickToSuperviewEdges(.all)
        
        view.addSubview(actionTitle)
        actionTitle.bottom(40)
        actionTitle.centerHorizontally()
        
        view.addSubview(changeStepButton)
        changeStepButton.trailing(40)
        changeStepButton.centerVertically(to: actionTitle)
        
        view.addSubview(cleanButton)
        cleanButton.leading(40)
        cleanButton.centerVertically(to: actionTitle)
    }
    
    private func createButton(title: String) -> UIButton {
        let config: UIButton.Configuration = .filled()
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.configuration = config
        button.height(40)
        button.width(130)
        return button
    }
    
    @objc private func closeController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeStep() {
        step = step.next()
        switch step {
        case .drawLines:
            board.drawingColor = .systemBlue
        case .drawRectangle:
            board.drawingColor = .systemGreen
        case .viewClipArea:
            handleLines()
        case .clip:
            clip()
            changeStepButton.isHidden = true
        }
    }
    
    @objc private func reset() {
        clear()
        lines = []
        lineStates = [:]
        clippingArea = nil
        step = .drawLines
        board.drawingColor = .systemBlue
        changeStepButton.isHidden = false
    }
    
    private func update() {
        actionTitle.text = step.text()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        
        switch touch {
        case .first:
            touch = .second(firstPoint: point)
        case .second(let firstPoint):
            touch = .first
            
            switch step {
            case .drawLines:
                let line: Line = .init(p1: firstPoint, p2: point)
                drawLine(line)
                lines.append(line)
            case .drawRectangle:
                let minX = min(firstPoint.x, point.x)
                let minY = min(firstPoint.y, point.y)
                let maxX = max(firstPoint.x, point.x)
                let maxY = max(firstPoint.y, point.y)
                
                clippingArea = .init(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
                drawRectangle(clippingArea)
                
                changeStep()
            default:
                break
            }
        }
    }
    
    // MARK: - Draw
    
    func drawLine(_ line: Line) {
        drawImage { context in
            lineDrawer.drawCustom(from: line.p1, to: line.p2, context: context, board: &board)
        }
    }
    
    func drawRectangle(_ rectangle: Rectangle) {
        drawImage { context in
            lineDrawer.drawCustom(
                from: rectangle.topLeft,
                to: rectangle.topRight,
                context: context,
                board: &board
            )
            lineDrawer.drawCustom(
                from: rectangle.topLeft,
                to: rectangle.bottomLeft,
                context: context,
                board: &board
            )
            lineDrawer.drawCustom(
                from: rectangle.bottomLeft,
                to: rectangle.bottomRight,
                context: context,
                board: &board
            )
            lineDrawer.drawCustom(
                from: rectangle.bottomRight,
                to: rectangle.topRight,
                context: context,
                board: &board
            )
        }
    }
    
    // MARK: - Show clipping area
    
    func handleLines() {
        var visible: [Line] = []
        var invisible: [Line] = []
        var partlyVisible: [Line] = []
        
        clear()
        board.drawingColor = .systemGreen
        drawRectangle(clippingArea)
        
        for line in lines {
            switch lineState(for: line) {
            case .visible:
                board.drawingColor = .magenta
                visible.append(line)
            case .partlyVisible:
                board.drawingColor = .systemTeal
                partlyVisible.append(line)
            case .invisible:
                board.drawingColor = .red
                invisible.append(line)
            }
            drawLine(line)
        }
        
        lineStates[.visible] = visible
        lineStates[.partlyVisible] = partlyVisible
    }
    
    func code(for point: CGPoint) -> Int {
        var code: Int = 0
        
        if point.x < clippingArea.minX { code |= 0x01 }
        if point.x > clippingArea.maxX { code |= 0x02 }
        if point.y > clippingArea.maxY { code |= 0x04 }
        if point.y < clippingArea.minY { code |= 0x08 }

        return code
    }
    
    func lineState(for line: Line) -> LineState {
        let c1 = code(for: line.p1)
        let c2 = code(for: line.p2)
        let result = c1 & c2
        
        if result != 0 {
            return .invisible
        } else if c1 == 0 && c2 == 0 {
            return .visible
        } else {
            return .partlyVisible
        }
        
    }
    
    // MARK: - Clip
    
    func clip() {
        clear()
        board.drawingColor = .systemGreen
        drawRectangle(clippingArea)
        
        board.drawingColor = .systemRed
        
        var linesToShow = lineStates[.visible] ?? []
        
        func intersectionPoint(line: Line, code: Int) -> CGPoint? {
            var newPoint: CGPoint?
            
            if code & 0x01 != 0, let point = cross(l1: line, l2: clippingArea.left) {
                newPoint = point
            } else if code & 0x02 != 0, let point = cross(l1: line, l2: clippingArea.right) {
                newPoint = point
            } else if code & 0x04 != 0, let point = cross(l1: line, l2: clippingArea.bottom) {
                newPoint = point
            } else if code & 0x08 != 0, let point = cross(l1: line, l2: clippingArea.top) {
                newPoint = point
            }
            
            return newPoint
        }
        
        for line in lineStates[.partlyVisible] ?? [] {
            var c1 = code(for: line.p1)
            var c2 = code(for: line.p2)
            
            var p1 = line.p1
            var p2 = line.p2
            
            if c1 == 0 {
                swap(&c1, &c2)
                swap(&p1, &p2)
            }
            if let point = intersectionPoint(line: line, code: c1) {
                p1 = point
            } else {
                continue
            }
            
            if c2 == 0 {
                linesToShow.append(.init(p1: p1, p2: p2))
                continue
            }
            
            if let point = intersectionPoint(line: line, code: c2) {
                p2 = point
            }
            
            linesToShow.append(.init(p1: p1, p2: p2))
        }
        
        for line in linesToShow {
            drawLine(line)
        }
    }
    
    func cross(l1: Line, l2: Line) -> CGPoint? {
        let x1 = l1.p1.x
        let y1 = l1.p1.y
        let x2 = l1.p2.x
        let y2 = l1.p2.y
        let x3 = l2.p1.x
        let y3 = l2.p1.y
        let x4 = l2.p2.x
        let y4 = l2.p2.y
        
        var n: CGFloat = 0
        if y2 - y1 != 0 {  // a(y)
            let q: CGFloat = (x2 - x1) / (y1 - y2)
            let sn: CGFloat = (x3 - x4) + (y3 - y4) * q // c(x) + c(y)*q
            if sn == 0 {
                return nil
            }
            let fn: CGFloat = (x3 - x1) + (y3 - y1) * q; // b(x) + b(y)*q
            n = fn / sn;
        }
        else {
            if y3 - y2 == 0 { // b(y)
                return nil
            }
            n = (y3 - y1) / (y3 - y4);   // c(y)/b(y)
        }
        
        let x: CGFloat = x3 + (x4 - x3) * n;  // x3 + (-b(x))*n
        let y: CGFloat = y3 + (y4 - y3) * n;  // y3 +(-b(y))*n
        
        if Int(x) == Int(x3) {
            if y < min(y3, y4) || y > max(y3, y4) {
                return nil
            }
        }        
        if Int(y) == Int(y3) {
            if x < min(x3, x4) || x > max(x3, x4) {
                return nil
            }
        }
        
        return .init(x: x, y: y)
    }
    
}
