//
//  DrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit

protocol DrawerProvider: AnyObject {
    var type: DrawingType { set get }
    var color: UIColor { set get }
    
    func clear()
}

final class DrawingViewController: UIViewController, DrawerProvider {
    
    // MARK: - DrawingState
    
    enum Touches {
        case first
        case second(firstPoint: CGPoint)
    }
    
    // MARK: - UI
    
    private let imageView = UIImageView()
    
    // MARK: - Settings
    
    var lastPoint = CGPoint.zero
    
    var brushWidth: CGFloat = 2.0
    
    // MARK: - drawers
    
    private let lineDrawer: ShapeDrawer = LineDrawer()
    
    private let circleDrawer: ShapeDrawer = CircleDrawer()
    
    private let ellipseDrawer: ShapeDrawer = EllipseDrawer()
    
    private let shapeFiller: ShapeFiller = LineShapeFiller()
    
    // MARK: - DrawerProvider
    
    var type: DrawingType = .line(custom: true)
    
    var color: UIColor = .blue
    
    // MARK: - properties
    
    private var touch: Touches = .first
    
    private var board: Board!
    
    // MARK: - set up
    
    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        imageView.stickToSuperviewEdges(.all)
        
        imageView.isUserInteractionEnabled = true
        
        // draw empty image
        drawImage(drawing: { _ in })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if board == nil { board = .init(size: imageView.frame.size, color: color) }
    }
    
    // MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        
        switch touch {
        case .first:
            if case .fill = type {
                drawImage { context in
                    shapeFiller.fill(image: imageView.image, point: point, context: context, board: &board)
                }
            } else {
                touch = .second(firstPoint: point)
            }
        case .second(let firstPoint):
            touch = .first
            
            drawImage { context in
                switch type {
                case .line(let custom):
                    if custom {
                        lineDrawer.drawCustom(from: firstPoint, to: point, context: context, board: &board)
                    } else {
                        lineDrawer.drawDefault(from: firstPoint, to: point, context: context, board: &board)
                    }
                case .circle(let custom):
                    if custom {
                        circleDrawer.drawCustom(from: firstPoint, to: point, context: context, board: &board)
                    } else {
                        circleDrawer.drawDefault(from: firstPoint, to: point, context: context, board: &board)
                    }
                case .ellipse(let custom):
                    if custom {
                        ellipseDrawer.drawCustom(from: firstPoint, to: point, context: context, board: &board)
                    } else {
                        ellipseDrawer.drawDefault(from: firstPoint, to: point, context: context, board: &board)
                    }
                default:
                    break
                }
            }
            
        }
    }
    
    // MARK: - helpers
    
    func drawImage(drawing: (CGContext) -> Void) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        imageView.image?.draw(in: view.bounds)
        
        drawing(context)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clear() {
        imageView.image = nil
        board = .init(size: imageView.frame.size, color: color)
    }
    
}

