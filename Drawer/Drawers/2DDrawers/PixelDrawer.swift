//
//  PixelDrawer.swift
//  Drawer
//
//  Created by Mikhail on 11.10.2021.
//

import UIKit

protocol PixelDrawer { }

extension PixelDrawer {
    
    func drawPixel(
        _ x: Int,
        _ y: Int,
        _ contex: CGContext,
        board: Board? = nil,
        onlyOnBoard: Bool = false,
        color: UIColor? = nil
    ) {
        drawPixel(point: .init(x: x, y: y), context: contex, board: board, onlyOnBoard: onlyOnBoard, color: color)
    }
    
    func drawPixel(
        point: CGPoint,
        context: CGContext,
        board: Board? = nil,
        onlyOnBoard: Bool = false,
        color: UIColor? = nil
    ) {
        if !onlyOnBoard {
            context.move(to: point)
            context.addLine(to: point)
        }
        board?.setPixel(point: point, color: color)
    }
    
}
