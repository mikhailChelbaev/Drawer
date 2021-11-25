//
//  BSplineCurve.swift
//  Drawer
//
//  Created by Mikhail on 24.11.2021.
//

import UIKit

final class BSplineCurve: CurveDrawer {
    
    func draw(points: [CGPoint], context: CGContext, board: inout Board) {
        let n = points.count - 1
        
        guard n == 3 else { return }
        
        let xs: [CGFloat] = points.map(\.x)
        let ys: [CGFloat] = points.map(\.y)
        
        for t in stride(from: 0, to: 1, by: 0.001) {
            let x: CGFloat = b(t: t, p: xs)
            let y: CGFloat = b(t: t, p: ys)
            drawPixel(Int(x), Int(y), context, board: &board)
        }
    }
    
    func b(t: CGFloat, p: [CGFloat]) -> CGFloat {
        return 1 / 6 * (pow(1 - t, 3) * p[0] +
                        (3 * pow(t, 3) - 6 * pow(t, 2) + 4) * p[1] +
                        (-3 * pow(t, 3) + 3 * pow(t, 2) + 3 * t + 1) * p[2] +
                        pow(t, 3) * p[3])
    }
    
}

