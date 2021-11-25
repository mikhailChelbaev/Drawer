//
//  CurveDrawer.swift
//  Drawer
//
//  Created by Mikhail on 24.11.2021.
//

import Foundation

protocol CurveDrawer: PixelDrawer {
    
    func draw(points: [CGPoint], context: CGContext, board: inout Board)
    
}

