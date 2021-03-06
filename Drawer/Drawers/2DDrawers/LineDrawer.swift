//
//  LineDrawer.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import UIKit
import CoreGraphics

final class LineDrawer: ShapeDrawer {
    
    func drawDefault(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board) {
        context.move(to: p1)
        context.addLine(to: p2)
        drawLine(from: p1, to: p2, context: context, board: board, onlyOnBoard: true)
    }
    
    func drawCustom(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board) {
        drawLine(from: p1, to: p2, context: context, board: board, onlyOnBoard: false)
    }
    
    func systemDraw(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        context.move(to: p1)
        context.addLine(to: p2)        
    }
    
    @discardableResult
    func drawLine(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board, onlyOnBoard: Bool) -> [CGPoint] {
        var points: [CGPoint] = []
        
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
        
        // draw first point
        drawPixel(point: .init(x: x1, y: y1), context: context, board: board, onlyOnBoard: onlyOnBoard)
        points.append(.init(x: x1, y: y1))
        
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
            drawPixel(point: .init(x: x1 + x, y: y1 + y), context: context, board: board, onlyOnBoard: onlyOnBoard)
            points.append(.init(x: x1 + x, y: y1 + y))
        }
        
        return points
    }
    
}
