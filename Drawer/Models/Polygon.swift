//
//  Polygon.swift
//  Drawer
//
//  Created by Mikhail on 24.10.2021.
//

import Foundation

struct Polygon {
    
    private(set) var points: Set<CGPoint> = .init()
    
    private(set) var vertices: [CGPoint] = []
    
    private(set) var left: CGPoint = .init(x: CGFloat.greatestFiniteMagnitude, y: 0.0)
    
    private(set) var right: CGPoint = .init(x: -CGFloat.greatestFiniteMagnitude, y: 0.0)
    
    private(set) var bottom: CGPoint = .init(x: 0.0, y: -CGFloat.greatestFiniteMagnitude)
    
    private(set) var top: CGPoint = .init(x: 0.0, y: CGFloat.greatestFiniteMagnitude)
    
    var numberOfVertices: Int {
        vertices.count
    }
    
    subscript(_ index: Int) -> CGPoint {
        return vertices[index]
    }
    
    mutating func addVertex(_ point: CGPoint) {
        vertices.append(point)
    }
    
    mutating func addPoint(_ point: CGPoint) {
        points.insert(point)
        if point.x < left.x {
            left = point
        } else if point.x > right.x {
            right = point
        }
        if point.y > bottom.y {
            bottom = point
        } else if point.y < top.y {
            top = point
        }
    }
    
    mutating func addPoints(_ points: [CGPoint]) {
        guard !points.isEmpty else { return }
        
        let sortedPoints = points.sorted(by: { $0.y < $1.y })
        
        for (i, point) in sortedPoints.enumerated() {
            if i > 0 {
                if abs(points[i - 1].y - point.y) > 0 {
                    addPoint(point)
                }
            } else {
                addPoint(point)
            }
            
        }
    }
    
    func contains(_ point: CGPoint) -> Bool {
        var hasLeft: Bool = false
        var hasRight: Bool = false
        
        points.forEach({
            if Int($0.y) == Int(point.y) {
                if $0.x < point.x {
                    hasLeft = true
                } else if $0.x > point.x {
                    hasRight = true
                }
            }
        })
        
        return hasLeft && hasRight
    }
 
}

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
}
