//
//  Pyramid.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

final class Pyramid: Object3D {
    
    init(side a: Float = 200) {
        super.init()
        
        let m = a / (sqrt(2) * 2)
        let s = a / 2
        
        vertices = [
            Point3D(x: 0, y: 0, z: m, w: 1),
            Point3D(x: s, y: s, z: -m, w: 1),
            Point3D(x: -s, y: s, z: -m, w: 1),
            Point3D(x: -s, y: -s, z: -m, w: 1),
            Point3D(x: s, y: -s, z: -m, w: 1)
        ]
        
        let sideIndexes = [
            [1, 2, 3],
            [1, 3, 4],
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 4],
            [0, 1, 4]
        ]
        sides = sideIndexes.map({ innerArray in innerArray.map({ vertices[$0] }) })
        verticesIndexes = sideIndexes
    }
    
}
