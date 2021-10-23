//
//  PolygonDrawer.swift
//  Drawer
//
//  Created by Mikhail on 23.10.2021.
//

import Foundation

final class PolygonDrawer {
    
    var isDrawing: Bool = false {
        didSet {
            if !isDrawing {
                points = []
            }
        }
    }
    
    private let lineDrawer: LineDrawer = .init()
    
    private let intersectionChecker: IntersectionChecker = .init()
    
    private var points: [CGPoint] = []
    
    func addPoint(_ point: CGPoint, context: CGContext, board: inout Board) {
        isDrawing = true
        points.append(point)
        if points.count > 1 {
            let p1 = points[points.count - 2]
            if points.count >= 4 {
                if intersectionChecker.intersect(a: points[0], b: points[1], c: p1, d: point) {
                    lineDrawer.drawDefault(from: points[0], to: p1, context: context, board: &board)
                    isDrawing = false
                    return
                }
            }
            lineDrawer.drawDefault(from: p1, to: point, context: context, board: &board)
        }
    }
    
}

struct IntersectionChecker {
    
    private func area(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
        return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
    }
    
    private func intersect_1(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat) -> Bool {
        let a1 = min(a, b)
        let b1 = max(a, b)
        let c1 = min(c, d)
        let d1 = max(c, d)
        return max(a1, c1) <= min(b1, d1);
    }
    
    func intersect(a: CGPoint, b: CGPoint, c: CGPoint, d: CGPoint) -> Bool {
        return intersect_1(a: a.x, b: b.x, c: c.x, d: d.x)
        && intersect_1 (a: a.y, b: b.y, c: c.y, d: d.y)
        && area(a: a, b: b, c: c) * area(a: a, b: b, c: d) <= 0
        && area(a: c, b: d, c: a) * area(a: c, b: d, c: b) <= 0
    }
    
}
