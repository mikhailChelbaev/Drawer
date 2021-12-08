//
//  CircleDrawer.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import UIKit

final class CircleDrawer: ShapeDrawer {
    
    func drawDefault(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board) {
        let x1 = p1.x
        let y1 = p1.y
        let x2 = p2.x
        let y2 = p2.y
        let r = sqrt(pow(Double(x2 - x1), 2) + pow(Double(y2 - y1), 2)) // radius
        
        context.addEllipse(in: .init(x: x1 - r, y: y1 - r, width: 2 * r, height: 2 * r))
        drawCircle(from: p1, to: p2, context: context, board: board, onlyOnBoard: true)
    }
    
    func drawCustom(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board) {
        drawCircle(from: p1, to: p2, context: context, board: board, onlyOnBoard: false)
    }
    
    private func drawCircle(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board, onlyOnBoard: Bool) {
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
            drawPixel(x1 + x, y1 - y, context, board: board, onlyOnBoard: onlyOnBoard) // first quarter
            drawPixel(x1 - x , y1 - y, context, board: board, onlyOnBoard: onlyOnBoard) // second quarter
            drawPixel(x1 - x, y1 + y, context, board: board, onlyOnBoard: onlyOnBoard) // third quarter
            drawPixel(x1 + x, y1 + y, context, board: board, onlyOnBoard: onlyOnBoard) // fourth quarter

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

        } while (y >= 0)
    }
    
}
