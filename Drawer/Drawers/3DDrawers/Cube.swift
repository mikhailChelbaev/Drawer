//
//  Cube.swift
//  Drawer
//
//  Created by Mikhail on 05.12.2021.
//

import UIKit
import simd

final class Cube: Object3D {
    
    init(side: Float) {
        super.init()
        
        let half = side / 2
        for i in 0 ..< 8 {
            vertices.append(.init(x: Float(i & 0x01) * side - half,
                                      y: Float((i & 0x02) >> 1) * side - half,
                                      z: Float((i & 0x04) >> 2) * side - half,
                                      w: 1))
        }
    }
    
    override func getDrawingEdges() -> [Object3D.Edge] {
        return [(0, 1), (1, 3), (2, 3), (0, 2), (0, 4), (1, 5), (2, 6), (3, 7), (4, 5), (4, 6), (5, 7), (6, 7)]
    }
    
}
