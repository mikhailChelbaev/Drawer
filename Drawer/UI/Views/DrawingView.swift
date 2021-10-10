//
//  DrawingView.swift
//  Drawer
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit

final class DrawingView: UIViewController {
    
    // MARK: - DrawingState
    
    enum DrawingState {
        case `default`
        case drawing(firstPoint: CGPoint)
    }
    
    // MARK: - UI
    
    private let imageView = UIImageView()
    
    // MARK: - Settigs
    
    var lastPoint = CGPoint.zero
    
    var color = UIColor.black
    
    var brushWidth: CGFloat = 2.0
    
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
            
            drawLine(from: firstPoint, to: point, context: context)
            drawCircle(from: firstPoint, to: point, context: context)
            drawEllipse(from: firstPoint, to: point, context: context)
            
            context.setLineCap(.round)
            context.setBlendMode(.normal)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(color.cgColor)
            
            context.strokePath()
            
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    
    // MARK: - drawing
    
    func drawPixel(_ x: Int, _ y: Int, _ contex: CGContext) {
        drawPixel(point: .init(x: x, y: y), context: contex)
    }
    
    func drawPixel(point: CGPoint, context: CGContext) {
        context.move(to: point)
        context.addLine(to: point)
    }
    
    private func drawLine(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        let x1 = Int(p1.x)
        let y1 = Int(p1.y)
        let x2 = Int(p2.x)
        let y2 = Int(p2.y)
         
        var x: Int = 0, y: Int = 0 // offset from first point
        let a = Int(abs(x2 - x1)), b = Int(abs(y2 - y1)) // deltas

        var ey = 2 * b - a // y error
        let delta_eyS = 2 * b
        let delta_eyD = 2 * b - 2 * a

        var ex = 2 * a - b // x error
        let delta_exS = 2 * a
        let delta_exD = -delta_eyD

        let sx = x1 < x2 ? 1 : -1 // x sign
        let sy = y1 < y2 ? 1 : -1 // y sign
        
        while (abs(x) < a || abs(y) < b) {
            if ey > 0 {
                y += sy
                ey += delta_eyD
            } else {
                ey += delta_eyS
            }
            if ex > 0 {
                x += sx
                ex += delta_exD
            } else {
                ex += delta_exS
            }
            drawPixel(point: .init(x: x1 + x, y: y1 + y), context: context)
        }
    }
    
    private func drawCircle(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        let x1 = Int(p1.x)
        let y1 = Int(p1.y)
        let x2 = Int(p2.x)
        let y2 = Int(p2.y)
        let r = Int(sqrt(pow(Double(x2 - x1), 2) + pow(Double(y2 - y1), 2))) // radius

        var x: Int = 0
        var y = r
        var err = 2 - 2 * r
        var d: Int

        repeat {
            drawPixel(x1 + x, y1 - y, context) // first quarter
            drawPixel(x1 - x , y1 - y, context) // second quarter
            drawPixel(x1 - x, y1 + y, context) // third quarter
            drawPixel(x1 + x, y1 + y, context) // fourth quarter

            if err < 0 {
                d = 2 * err + 2 * y - 1
                if d <= 0 {
                    x += 1
                    err += 2 * x + 1
                    continue
                }
            } else if err > 0 {
                d = 2 * err - 2 * x - 1
                if d > 0 {
                    y -= 1
                    err += -2 * y + 1
                    continue
                }
            }

            x += 1
            y -= 1
            err += 2 * x - 2 * y + 2

        } while (y > 0)
        
    }
    
    private func drawEllipse(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        var x1 = Int(p1.x)
        var y1 = Int(p1.y)
        var x2 = Int(p2.x)
        var y2 = Int(p2.y)
        
        var a: Int = abs(x2 - x1)
        let b: Int = abs(y2 - y1)
        var b1 = b & 1
        var dx: Int = 4 * (1 - a) * b * b
        var dy: Int = 4 * (b1 + 1) * a * a
        var err: Int = dx + dy + b1 * a * a
        var e2: Int
        
        if x1 > x2 {
            x1 = x2
            x2 += a
        }
        
        if y1 > y2 {
            y1 = y2
        }
        
        y1 += (b + 1) / 2
        y2 = y1 - b1
        a *= 8 * a
        b1 = 8 * b * b
        
        repeat {
            drawPixel(x2, y1, context)
            drawPixel(x1, y1, context)
            drawPixel(x1, y2, context)
            drawPixel(x2, y2, context)
            e2 = 2 * err
            if (e2 <= dy) {
                y1 += 1
                y2 -= 1
                dy += a
                err += dy
            }
            if (e2 >= dx || 2 * err > dy) {
                x1 += 1
                x2 -= 1
                dx += b1
                err += dx
            }
        } while (x1 <= x2)
                 
        while (y1 - y2) < b {
            drawPixel(x1 - 1, y1, context)
            y1 += 1
            drawPixel(x2 + 1, y1, context)
            drawPixel(x1 - 1, y2, context)
            y2 -= 1
            drawPixel(x2 + 1, y2, context)
        }
    }
    
}
