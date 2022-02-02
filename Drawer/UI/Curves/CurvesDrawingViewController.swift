//
//  CurvesDrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 23.11.2021.
//

import UIKit

final class CurvesDrawingViewController: DrawingViewController, DrawerProvider {
    
    // MARK: - State
    
    enum State {
        case move(Int)
        case `default`
    }
    
    // MARK: - drawers
    
    private let lineDrawer: ShapeDrawer = LineDrawer()
    
    private let bezierCurve: CurveDrawer = BezierCurve()
    
    private let spline: CurveDrawer = BSplineCurve()
    
    private let casteljauBezier: CurveDrawer = CasteljauBezierCurve()
    
    // MARK: - DrawerProvider
    
    var type: DrawingType = .bezier {
        didSet { update() }
    }
    
    override var color: UIColor {
        set {
            board.drawingColor = newValue
            redraw()
        }
        get {
            return board?.drawingColor ?? .systemBlue
        }
    }
    
    // MARK: - properties
    
    private var points: [CGPoint] = [] {
        didSet { update() }
    }
    
    private let dotRadius: CGFloat = 6
    
    private let areaRadius: CGFloat = 8
    
    private var state: State = .default
    
    // MARK: - options
    
    private let optionsView: CurveOptionsView = .init()
    
    var referenceLine: Bool = true {
        didSet { update() }
    }
    
    var compoundCurve: Bool = false {
        didSet { update() }
    }
    
    var closeCurve: Bool = false {
        didSet { update() }
    }
    
    override func configure() {
        super.configure()
        
        optionsView.handler = self
        optionsView.setState(.disabled, for: .closeCurve)
        
        view.addSubview(optionsView)
        optionsView.stickToSuperviewSafeEdges([.right, .top], insets: .init(top: 20, left: 0, bottom: 0, right: 20))
    }
    
    // MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        
        // do not handle touches on options item
        if view.hitTest(point, with: event) is CurveOptionItemView { return }
        
        for i in 0 ..< points.count {
            if isAreaContainsPoint(center: points[i], point: point) {
                state = .move(i)
                return
            }
        }
        
        points.append(point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        
        if case .move(let i) = state {
            points[i] = point
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .default
    }
    
    private func isAreaContainsPoint(center: CGPoint, point: CGPoint) -> Bool {
        let minX = center.x - areaRadius
        let maxX = center.x + areaRadius
        let minY = center.y - areaRadius
        let maxY = center.y + areaRadius
        
        return point.x >= minX &&
        point.x <= maxX &&
        point.y >= minY &&
        point.y <= maxY
    }
    
    // MARK: - Other
    
    private func redraw() {
        board = .init(size: imageView.frame.size, color: color)
        imageView.image = nil
        
        var color = self.color
        if case .casteljauBezier = type {
            color = UIColor.systemGreen
        }
        
        drawImage { context in
            var drawingPoints = points
            if closeCurve, points.count > 3 {
                if case .spline = type {
                    drawingPoints.append(points[0])
                    drawingPoints.append(points[1])
                    drawingPoints.append(points[2])
                } else {
                    let size = points.count
                    if size % 2 != 0 {
                        drawingPoints.append(simetricPoint(p1: points[size - 1], p2: points[size - 2]))
                    }
                    drawingPoints.append(simetricPoint(p1: points[0], p2: points[1]))
                    drawingPoints.append(points[0])
                }
            }
            
            for (i, point) in drawingPoints.enumerated() {
                let dotColor: UIColor = i % 4 == 0 || i % 4 == 3 ? .red : .magenta
                context.setFillColor(dotColor.cgColor)
                context.addEllipse(in: .init(
                    x: point.x - dotRadius,
                    y: point.y - dotRadius,
                    width: 2 * dotRadius, height: 2 * dotRadius
                ))
                context.drawPath(using: .fill)
                
                guard i > 0 else { continue }
                
                context.setLineCap(.round)
                context.setBlendMode(.normal)
                
                if referenceLine {
                    lineDrawer.drawCustom(from: drawingPoints[i - 1], to: point, context: context, board: board)
                    context.setLineWidth(2)
                    context.setStrokeColor(color.cgColor)
                    context.strokePath()
                }
            }
            switch type {
            case .bezier, .casteljauBezier:
                var drawer: CurveDrawer = casteljauBezier
                if case .bezier = type { drawer = bezierCurve }
                
                if compoundCurve {
                    for batch in batchesForCompoundBezierCurve(points: drawingPoints) {
                        drawer.draw(points: batch, context: context)
                    }
                } else {
                    drawer.draw( points: points, context: context)
                }
            case .spline:
                for batch in splitBatchesForSpline(points: drawingPoints) {
                    spline.draw(points: batch, context: context)
                }
            default:
                break
            }
            context.setLineWidth(1)
            context.setStrokeColor(color.cgColor)
            context.strokePath()
        }
    }
    
    private func batchesForCompoundBezierCurve(points: [CGPoint]) -> [[CGPoint]] {
        guard points.count >= 4 else { return [] }
        
        var referencePoints: [CGPoint] = [points[0], points[1]] // save first 2 points
        var batches: [[CGPoint]] = []
        let size = points.count
        
        for i in stride(from: 4, to: size + 1, by: 2) { // for (i = 4; i < size + 1; i += 2)
            referencePoints.append(points[i - 2])
            if size - i >= 2 { // if there are 2 or more points after, we add additional point
                referencePoints.append(findCenter(p1: points[i - 2], p2: points[i - 1]))
            }
            referencePoints.append(points[i - 1])
        }
        
        // split points to groups with size 4
        for i in stride(from: 4, to: referencePoints.count + 1, by: 3) {
            batches.append(referencePoints[i-4 ..< i].map({ $0 }))
        }
        
        return batches
    }
    
    private func findCenter(p1: CGPoint, p2: CGPoint) -> CGPoint {
        let minX = min(p1.x, p2.x)
        let maxX = max(p1.x, p2.x)
        let minY = min(p1.y, p2.y)
        let maxY = max(p1.y, p2.y)
        return .init(x: (maxX - minX) / 2 + minX, y: (maxY - minY) / 2 + minY)
    }
    
    private func splitBatchesForSpline(points: [CGPoint]) -> [[CGPoint]] {
        guard points.count >= 4 else { return [] }
        var result: [[CGPoint]] = []
        for i in 4 ... points.count {
            result.append(points[i-4 ..< i].map({ $0 }))
        }
        return result
    }
    
    private func simetricPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        let x: CGFloat = abs(p1.x - p2.x)
        let y: CGFloat = abs(p1.y - p2.y)
        
        let sx: CGFloat = p1.x > p2.x ? 1 : -1
        let sy: CGFloat = p1.y > p2.y ? 1 : -1
        
        return .init(x: p1.x + sx * x, y: p1.y + sy * y)
    }
    
    private func update() {
        switch type {
        case .bezier, .casteljauBezier:
            optionsView.setState(.enabled, for: .compoundCurve)
            optionsView.setState(compoundCurve && points.count > 3 ? .enabled : .disabled, for: .closeCurve)
        case .spline:
            optionsView.setState(.disabled, for: .compoundCurve)
            optionsView.setState(.enabled, for: .closeCurve)
        default:
            break
        }
        redraw()
    }
    
    override func clear() {
        super.clear()
        points = []
        optionsView.setValue(false, for: .closeCurve)
    }
    
}

extension CurvesDrawingViewController: CurveOptionsHandler {
    
    func handleReferenceLine(isOn: Bool) {
        referenceLine = isOn
        redraw()
    }
    
    func handleCompoundCurve(isOn: Bool) {
        compoundCurve = isOn
        redraw()
    }
    
    func handleCloseCurve(isOn: Bool) {
        closeCurve = isOn
        redraw()
    }
    
}


