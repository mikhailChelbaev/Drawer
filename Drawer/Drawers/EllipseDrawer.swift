//
//  EllipseDrawer.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import Foundation

final class EllipseDrawer: ShapeDrawer {
    
    func drawDefault(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        let x1 = p1.x
        let y1 = p1.y
        let x2 = p2.x
        let y2 = p2.y
        
        let a = abs(x2 - x1)
        let b = abs(y2 - y1)
        
        context.addEllipse(in: .init(x: min(x1, x2), y: min(y1, y2), width: a, height: b))
    }
    
    func drawCustom(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
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
