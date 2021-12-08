//
//  CurveDrawer.swift
//  Drawer
//
//  Created by Mikhail on 24.11.2021.
//

import UIKit

protocol CurveDrawer: PixelDrawer {
    
    func draw(points: [CGPoint], context: CGContext)
    
}

