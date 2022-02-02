//
//  Ball.swift
//  Drawer
//
//  Created by Mikhail on 02.02.2022.
//

import UIKit
import simd

final class Ball: Object3D {
    
    private let radius: Float
    
    init(radius: Float = 200, depth: Int = 2) {
        self.radius = radius
        
        super.init()
        
        let icosahedronSides = Icosahedron(radius: radius * 0.9).sides
        
        sides = icosahedronSides
        var newSides: [[Point3D]]
        
        for _ in 0 ..< depth {
            newSides = []
            for side in sides {
                let p1 = side[0]
                let p2 = side[1]
                let p3 = side[2]
                
                let p4 = calculateCentralPoint(p1: p1, p2: p2)
                let p5 = calculateCentralPoint(p1: p2, p2: p3)
                let p6 = calculateCentralPoint(p1: p1, p2: p3)
                
                newSides.append(contentsOf: [
                    [p1, p4, p6],
                    [p2, p4, p5],
                    [p3, p5, p6],
                    [p4, p5, p6]
                ])
            }
            sides = newSides
            
            createVerticesAndIndexes()
        }
        
    }
    
    private func calculateCentralPoint(p1: Point3D, p2: Point3D) -> Point3D {
        let x = (p1.x + p2.x) / 2
        let y = (p1.y + p2.y) / 2
        let z = (p1.z + p2.z) / 2
        
        let coef = radius / sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
        
        return Point3D(x: x * coef, y: y * coef, z: z * coef, w: 1)
    }
    
    private func createVerticesAndIndexes() {
        var size: Int = 0
        verticesIndexes = []
        vertices = []
        
        for i in sides.indices {
            verticesIndexes.append([])
            for point in sides[i] {
                var vertexIndex: Int
                if let index = vertices.firstIndex(of: point) {
                    vertexIndex = index
                } else {
                    vertexIndex = size
                    size += 1
                    vertices.append(point)
                }
                verticesIndexes[i].append(vertexIndex)
            }
        }
    }
}

