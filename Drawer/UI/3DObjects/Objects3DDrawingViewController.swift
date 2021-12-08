//
//  Objects3DDrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 03.12.2021.
//

import UIKit
import CoreGraphics

final class Objects3DDrawingViewController: DrawingViewController, DrawerProvider {
    
    // MARK: - Action
    
    enum ObjectAction {
        case translation
        case rotation
        case scale
    }
    
    // MARK: - drawers
    
    private var cube: Object3D = Cube(side: 200)
    
    private var pyramid: Object3D = Pyramid(side: 200)
    
    private var diamond: Object3D = Diamond(side: 200)
    
    // MARK: - DrawerProvider
    
    var type: DrawingType = .cube {
        didSet { updateCurrentObject() }
    }
    
    override var color: UIColor {
        set {
            board.drawingColor = newValue
            redraw { context in
                currentObject?.draw(context: context, board: board)
            }
        }
        get {
            return board?.drawingColor ?? .systemBlue
        }
    }
    
    // MARK: - other properties
    
    private lazy var currentObject: Object3D? = cube
    
    private let optionsView: Object3DOptionsProtocol = Object3DOptionsView()
    
    private var action: ObjectAction = .rotation
    
    private var isOptionButtonPressed: Bool = false
    
    private var previousPoint: CGPoint = .zero
    
    private var previousAngle: CGFloat = .zero
    
    private var previousScale: CGFloat = 1
    
    private var rotationAnimation: TimerAnimation?
    
    // MARK: - set up
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawShape()
    }
    
    override func commonInit() {
        super.commonInit()
        
        // ui
        
        view.addSubview(optionsView)
        optionsView.stickToSuperviewSafeEdges([.right, .top], insets: .init(top: 20, left: 0, bottom: 0, right: 20))
        
        // gesture recognizers
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        panGestureRecognizer.allowedScrollTypesMask = .continuous
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)

        let rotationGestureRecognizer = UIRotationGestureRecognizer()
        rotationGestureRecognizer.addTarget(self, action: #selector(handleRotationGesture))
        rotationGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(rotationGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer()
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture))
        pinchGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        // set up
        
        optionsView.presenter = self
        currentObject?.projection = optionsView.projection
        optionsView.projectionDidChange = { [weak self] newValue in
            guard let self = self else { return }
            self.currentObject?.projection = newValue
            self.redraw { context in
                self.currentObject?.draw(context: context, board: self.board)
            }
        }
    }
    
    // MARK: - Gesture recognizer handlers
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: view)
        
        switch gesture.state {
        case .began:
            previousPoint = point
        case .changed:
            if gesture.numberOfTouches == 1 {
                // rotate
                if optionsView.deceleration == .yes {
                    decelerateRotation(withVelocity: gesture.velocity(in: view))
                } else {
                    rotate(from: previousPoint, to: point)
                    previousPoint = point
                }
            } else {
                // translate
                translate(from: previousPoint, to: point)
                previousPoint = point
            }
        default:
            break
        }
    }
    
    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .changed:
            rotate(dz: (gesture.rotation - previousAngle) * 2)
        default:
            break
        }
        
        previousAngle = gesture.rotation
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed:
            scale(gesture.scale - previousScale)
        default:
            break
        }
        previousScale = gesture.scale
    }
    
    // MARK: - Helpers
    
    private func updateCurrentObject() {
        switch type {
        case .cube:
            currentObject = cube
        case .pyramid:
            currentObject = pyramid
        case .diamond:
            currentObject = diamond
        default:
            currentObject = nil
        }
        drawShape()
    }
    
    private func drawShape() {
        redraw { context in
            currentObject?.draw(context: context, board: board)
        }
    }
    
    private func redraw(drawing: (CGContext) -> Void) {
        board = .init(size: imageView.frame.size, color: color)
        imageView.image = nil
        drawImage(drawing: drawing)
    }
    
    override func clear() {
        cube = Cube(side: 200)
        pyramid = Pyramid(side: 200)
        diamond = Diamond(side: 200)
        
        updateCurrentObject()
        currentObject?.projection = optionsView.projection
        drawShape()
    }
    
    // MARK: - Object actions
    
    private func translate(from p1: CGPoint, to p2: CGPoint) {
        redraw { context in
            currentObject?.translate(tx: Float(p1.x - p2.x),
                                 ty: Float(p1.y - p2.y),
                                 context: context,
                                 board: board)
        }
    }
    
    private func rotate(from p1: CGPoint, to p2: CGPoint) {
        let dx: CGFloat = p2.y - p1.y
        let dy: CGFloat = p1.x - p2.x
        let dz: CGFloat = 0
        let degree = Float.pi / 180
        
        redraw { context in
            currentObject?.rotate(alpha: Float(dx) * degree,
                              theta: Float(dy) * degree,
                              phi: Float(dz),
                              context: context,
                              board: board)
        }
    }
    
    private func rotate(dz: CGFloat) {
        redraw { context in
            currentObject?.rotate(alpha: 0,
                              theta: 0,
                              phi: Float(dz),
                              context: context,
                              board: board)
        }
    }
    
    private func scale(_ scale: CGFloat) {
        var x: CGFloat = 1
        var y: CGFloat = 1
        var z: CGFloat = 1
        var h: CGFloat = 1
        
        switch optionsView.scaleAxis {
        case .x:
            x += scale
        case .y:
            y += scale
        case .z:
            z += scale
        case .object:
            h -= scale
        }
        
        redraw { context in
            currentObject?.scale(x: x, y: y, z: z, h: h, context: context, board: board)
        }
    }
    
    // MARK: - Rotation deceleration
    
    private func decelerateRotation(withVelocity velocity: CGPoint) {
        let d = UIScrollView.DecelerationRate.fast.rawValue
        let parameters = DecelerationTimingParameters(initialValue: previousPoint, initialVelocity: velocity,
                                                      decelerationRate: d, threshold: 0.5)
        
        
        rotationAnimation = TimerAnimation(
            duration: parameters.duration,
            animations: { [weak self] _, time in
                guard let self = self else { return }
                let point = parameters.value(at: time)
                self.rotate(from: self.previousPoint, to: point)
                self.previousPoint = point
            })
    }
    
}

// MARK: - Protocol UIGestureRecognizerDelegate

extension Objects3DDrawingViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}