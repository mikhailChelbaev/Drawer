//
//  Diamond.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

final class Diamond: Object3D {
    
    init(side: Float) {
        super.init()
        
        let a = side / sqrt(2)
        
        vertices = [
            Point3D(x: a / 2, y: a / 2, z: 0, w: 1),
            Point3D(x: -a / 2, y: a / 2, z: 0, w: 1),
            Point3D(x: -a / 2, y: -a / 2, z: 0, w: 1),
            Point3D(x: a / 2, y: -a / 2, z: 0, w: 1),
            Point3D(x: 0, y: 0, z: a, w: 1),
            Point3D(x: 0, y: 0, z: -a, w: 1),
        ]
    }
    
    override func getDrawingEdges() -> [Object3D.Edge] {
        return [
            (0, 1), (1, 2), (2, 3), (3, 0),
            (0, 4), (1, 4), (2, 4), (3, 4),
            (0, 5), (1, 5), (2, 5), (3, 5)
        ]
    }
    
}
