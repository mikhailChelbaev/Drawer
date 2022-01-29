//
//  ShapeDrawer.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import UIKit

protocol ShapeDrawer: PixelDrawer {
    func drawDefault(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board)
    func drawCustom(from p1: CGPoint, to p2: CGPoint, context: CGContext, board: Board)
    func systemDraw(from p1: CGPoint, to p2: CGPoint, context: CGContext)
}

extension ShapeDrawer {
    func systemDraw(from p1: CGPoint, to p2: CGPoint, context: CGContext) {
        fatalError("Not implemented")
    }
}
