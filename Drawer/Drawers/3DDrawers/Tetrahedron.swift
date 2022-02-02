//
//  Tetrahedron.swift
//  Drawer
//
//  Created by Mikhail on 18.01.2022.
//

import UIKit
import simd

final class Tetrahedron: Object3D {
    
    init(side: Float = 200) {
        super.init()
        
        vertices = []
        let half = side / 2
        for i in 0 ..< 8 {
            vertices.append(.init(x: Float(i & 0x01) * side - half,
                                  y: Float((i & 0x02) >> 1) * side - half,
                                  z: Float((i & 0x04) >> 2) * side - half,
                                  w: 1))
        }
        
        let sideIndexes = [
            [0, 3, 6],
            [0, 3, 5],
            [0, 5, 6],
            [3, 5, 6]
        ]
        sides = sideIndexes.map({ innerArray in innerArray.map({ vertices[$0] }) })
        verticesIndexes = sideIndexes
    }
    
}
