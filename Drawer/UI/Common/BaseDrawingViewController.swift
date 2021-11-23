//
//  BaseDrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 16.11.2021.
//

import UIKit

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
