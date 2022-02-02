//
//  DrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 16.11.2021.
//

import UIKit

// MARK: - DrawerProvider

protocol DrawerProvider: AnyObject {
    var type: DrawingType { set get }
    var color: UIColor { set get }
    
    func clear()
}

// MARK: - DrawingViewController

class DrawingViewController: UIViewController {
    
    // MARK: - Touches
    
    enum Touches {
        case first
        case second(firstPoint: CGPoint)
    }
    
    // MARK: - UI
    
    var imageView = UIImageView()
    
    // MARK: - Properties
    
    var touch: Touches = .first
    
    var board: Board!
    
    var color: UIColor {
        set {
            board.drawingColor = newValue
        }
        get {
            board?.drawingColor ?? .systemBlue
        }
    }
    
    // MARK: - set up
    
    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
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
    
    // MARK: - helpers
    
    func drawImage(drawing: (CGContext) -> Void) {
        let renderer = UIGraphicsImageRenderer(size: view.frame.size)
        imageView.image = renderer.image { context in
            imageView.image?.draw(in: view.bounds)
            
            drawing(context.cgContext)
            
            context.cgContext.setLineCap(.round)
            context.cgContext.setBlendMode(.normal)
            context.cgContext.setLineWidth(1)
            context.cgContext.setStrokeColor(color.cgColor)

            context.cgContext.strokePath()
        }
    }
    
    func clear() {
        imageView.image = nil
        board = .init(size: imageView.frame.size, color: color)
    }
    
}
