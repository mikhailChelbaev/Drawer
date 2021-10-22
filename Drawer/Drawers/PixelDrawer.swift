//
//  PixelDrawer.swift
//  Drawer
//
//  Created by Mikhail on 11.10.2021.
//

import Foundation

protocol PixelDrawer { }

extension PixelDrawer {
    
    func drawPixel(
        _ x: Int,
        _ y: Int,
        _ contex: CGContext,
        board: inout Board,
        onlyOnBoard: Bool = false
    ) {
        drawPixel(point: .init(x: x, y: y), context: contex, board: &board, onlyOnBoard: onlyOnBoard)
    }
    
    func drawPixel(
        point: CGPoint,
        context: CGContext,
        board: inout Board,
        onlyOnBoard: Bool = false
    ) {
        if !onlyOnBoard {
            context.move(to: point)
            context.addLine(to: point)
        }
        board.setPixel(point: point)
    }
    
}
