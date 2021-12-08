//
//  Pyramid.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

final class Pyramid: Object3D {
    
    init(side a: Float) {
        super.init()
        
        let m = a * sqrt(3) / 3
        let s = a * sqrt(3) / 6
        let l = a / 2
        
        vertices = [
            Point3D(x: m, y: 0, z: -s, w: 1),
            Point3D(x: -s, y: l, z: -s, w: 1),
            Point3D(x: -s, y: -l, z: -s, w: 1),
            Point3D(x: 0, y: 0, z: m, w: 1)
        ]
    }
    
    override func getDrawingEdges() -> [Object3D.Edge] {
        var result: [Object3D.Edge] = []
        for i in 0 ..< vertices.count - 1 {
            for j in i + 1 ..< vertices.count {
                result.append((i, j))
            }
        }
        return result
    }
    
}
