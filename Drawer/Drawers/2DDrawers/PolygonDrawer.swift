//
//  PolygonDrawer.swift
//  Drawer
//
//  Created by Mikhail on 23.10.2021.
//

import UIKit

final class PolygonDrawer {
    
    private(set) var isDrawing: Bool = false {
        didSet {
            if !isDrawing {
                polygon = .init()
            }
        }
    }
    
    private let lineDrawer: LineDrawer = .init()
    
    private let intersectionChecker: IntersectionChecker = .init()
    
    private var polygon: Polygon = .init()
    
    func addPoint(
        _ point: CGPoint,
        context: CGContext,
        board: Board,
        completion: (Polygon) -> Void
    ) {
        isDrawing = true
        polygon.addVertex(point)
        if polygon.numberOfVertices > 1 {
            let p1 = polygon[polygon.numberOfVertices - 2]
            if polygon.numberOfVertices >= 4 {
                if intersectionChecker.intersect(a: polygon[0], b: polygon[1], c: p1, d: point) {
                    polygon.addPoints(
                        lineDrawer.drawLine(
                            from: polygon[0],
                            to: p1,
                            context: context,
                            board: board,
                            onlyOnBoard: false
                        )
                    )
                    completion(polygon)
                    isDrawing = false
                    return
                }
            }
            polygon.addPoints(
                lineDrawer.drawLine(
                    from: p1,
                    to: point,
                    context: context,
                    board: board,
                    onlyOnBoard: false
                )
            )
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
