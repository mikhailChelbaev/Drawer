//
//  Icosahedron.swift
//  Drawer
//
//  Created by Mikhail on 20.01.2022.
//

import UIKit
import simd

final class Icosahedron: Object3D {
    
    init(radius: Float = 100) {
        super.init()
        
        // create vertices
        var vertices: [Point3D] = []
        
        var angle: Float
        for i in 0 ..< 10 {
            angle = Float(i) * .pi / 5
            vertices.append(Point3D(x: radius * cos(angle),
                                    y: radius * sin(angle),
                                    z: (i % 2 == 0 ? 1 : -1) * radius / 2,
                                    w: 1))
        }
        
        vertices.append(Point3D(x: 0, y: 0, z: sqrt(5) / 2 * radius, w: 1))
        vertices.append(Point3D(x: 0, y: 0, z: -sqrt(5) / 2 * radius, w: 1))
        
        // create triangles
        var sideIndexes: [[Int]] = []
        
        
        for i in 0 ..< 10 {
            sideIndexes.append([i, (i + 1) % 10, (i + 2) % 10])
            if i % 2 == 0 {
                sideIndexes.append([i, i + 2, 10])
            } else {
                sideIndexes.append([i, i + 2, 11])
            }
        }
        
        sides = sideIndexes.map({ innerArray in innerArray.map({ vertices[$0] }) })
    }
    
}

