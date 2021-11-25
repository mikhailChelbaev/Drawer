//
//  CasteljauBezierCurve.swift
//  Drawer
//
//  Created by Mikhail on 25.11.2021.
//

import UIKit

final class CasteljauBezierCurve: CurveDrawer {
    
    func draw(points: [CGPoint], context: CGContext, board: inout Board) {
        let n = points.count - 1
        
        guard n > 0 else { return }
        
        let xs: [CGFloat] = points.map(\.x)
        let ys: [CGFloat] = points.map(\.y)
        
        for t in stride(from: 0, to: 1, by: 0.001) {
            let x: CGFloat = b(t: t, p: xs)
            let y: CGFloat = b(t: t, p: ys)
            drawPixel(Int(x), Int(y), context, board: &board)
        }
    }
    
    func b(t: CGFloat, p: [CGFloat]) -> CGFloat {
        var xs = p
        let n = xs.count
        for i in 1 ..< n {
            for j in 0 ..< n - i {
                xs[j] = xs[j] * (1 - t) + xs[j + 1] * t
            }
        }
        return xs[0]
    }
    
}
