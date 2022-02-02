//
//  Cube.swift
//  Drawer
//
//  Created by Mikhail on 05.12.2021.
//

import UIKit
import simd

final class Cube: Object3D {
    
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
            [0, 1, 2],
            [1, 2, 3],
            [0, 2, 6],
            [0, 4, 6],
            [0, 1, 5],
            [0, 4, 5],
            [2, 3, 6],
            [3, 6, 7],
            [1, 3, 5],
            [3, 5, 7],
            [4, 5, 6],
            [5, 6, 7]
        ]
        sides = sideIndexes.map({ innerArray in innerArray.map({ vertices[$0] }) })
        verticesIndexes = sideIndexes
    }
    
}
