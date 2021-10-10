//
//  LineDrawer.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import Foundation

final class LineDrawer: ShapeDrawer {
    
    func drawDefault(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        context.move(to: p1)
        context.addLine(to: p2)
    }
    
    func drawCustom(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
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
    
}
