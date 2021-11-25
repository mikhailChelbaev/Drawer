//
//  BezierCurve.swift
//  Drawer
//
//  Created by Mikhail on 24.11.2021.
//

import UIKit

final class BezierCurve: CurveDrawer {
    
    func draw(points: [CGPoint], context: CGContext, board: inout Board) {
        let n = points.count - 1
        
        guard n > 0 else { return }
        
        for t in stride(from: 0, to: 1, by: 0.001) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            for (i, point) in points.enumerated() {
                x += b_i(t: t, n: n, i: i, p: point.x)
                y += b_i(t: t, n: n, i: i, p: point.y)
            }
            drawPixel(Int(x), Int(y), context, board: &board)
        }
    }
    
    private func b_i(t: CGFloat, n: Int, i: Int, p: CGFloat) -> CGFloat {
        return p * (factorial(n) / (factorial(i) * factorial(n - i))) * pow(t, CGFloat(i)) * pow(1 - t, CGFloat(n - i))
    }
    
    func factorial(_ n: Int) -> Double {
        guard n > 1 else { return 1 }
        return (1...n).map(Double.init).reduce(1.0, *)
    }
    
}
