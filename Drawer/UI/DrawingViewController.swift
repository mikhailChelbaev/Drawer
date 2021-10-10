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
}

final class DrawingViewController: UIViewController, DrawerProvider {
    
    // MARK: - DrawingState
    
    enum DrawingState {
        case `default`
        case drawing(firstPoint: CGPoint)
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
    
    // MARK: - DrawerProvider
    
    var type: DrawingType = .line(custom: true)
    
    var color: UIColor = .blue
    
    // MARK: - properties
    
    private var state: DrawingState = .default
    
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
    }
    
    // MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: view)
        
        switch state {
        case .`default`:
            state = .drawing(firstPoint: point)
        case .drawing(let firstPoint):
            state = .`default`
            
            UIGraphicsBeginImageContext(view.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            imageView.image?.draw(in: view.bounds)
            
            switch type {
            case .line(let custom):
                if custom {
                    lineDrawer.drawCustom(from: firstPoint, to: point, context: context)
                } else {
                    lineDrawer.drawDefault(from: firstPoint, to: point, context: context)
                }
            case .circle(let custom):
                if custom {
                    circleDrawer.drawCustom(from: firstPoint, to: point, context: context)
                } else {
                    circleDrawer.drawDefault(from: firstPoint, to: point, context: context)
                }
            case .ellipse(let custom):
                if custom {
                    ellipseDrawer.drawCustom(from: firstPoint, to: point, context: context)
                } else {
                    ellipseDrawer.drawDefault(from: firstPoint, to: point, context: context)
                }
            default:
                break
            }
            
            context.setLineCap(.round)
            context.setBlendMode(.normal)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(color.cgColor)
            
            context.strokePath()
            
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    
}

