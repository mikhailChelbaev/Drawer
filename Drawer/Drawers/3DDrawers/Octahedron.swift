//
//  Octahedron.swift
//  Drawer
//
//  Created by Mikhail on 19.01.2022.
//

import UIKit
import simd

final class Octahedron: Object3D {
    
    init(side: Float = 300) {
        super.init()
        
        let a = side / 2
        
        vertices = [
            Point3D(x: 0, y: 0, z: a, w: 1),
            Point3D(x: a, y: 0, z: 0, w: 1),
            Point3D(x: 0, y: a, z: 0, w: 1),
            Point3D(x: -a, y: 0, z: 0, w: 1),
            Point3D(x: 0, y: -a, z: 0, w: 1),
            Point3D(x: 0, y: 0, z: -a, w: 1)
        ]
        
        let sideIndexes = [
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 4],
            [0, 1, 4],
            [5, 1, 2],
            [5, 2, 3],
            [5, 3, 4],
            [5, 1, 4]
        ]
        sides = sideIndexes.map({ innerArray in innerArray.map({ vertices[$0] }) })
        verticesIndexes = sideIndexes
    }
    
}
