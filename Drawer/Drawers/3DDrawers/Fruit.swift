//
//  Fruit.swift
//  Drawer
//
//  Created by Mikhail on 02.02.2022.
//

import UIKit
import simd

final class Fruit: Object3D {
    
    init(radius: Float = 200) {
        super.init()
        
        allowHideInvisibleSides = false
        
        // create vertices
        var vertices: [[Point3D]] = []
        verticesIndexes = []
        var x: Float, y: Float, z: Float
        let step: Int = 10
        let floatStep: Float = Float(step) // optimisation purpose
        var a: Float, b: Float
        
        for i in stride(from: 0, through: step + 1, by: 1) {
            vertices.append([])
            for j in stride(from: 0, through: step, by: 1) {
                a = Float.pi / floatStep * Float(i)
                b = 2 * Float.pi / floatStep * Float(j)
                
                x = radius * sin(a) * cos(b) * (1 + 0.5 * abs(sin(2 * a)))
                y = radius * cos(a) * cos(b) * (1 + 0.5 * abs(sin(2 * a)))
                z = radius * sin(b)
                vertices[i].append(Point3D(x: x, y: y, z: z, w: 1))
                
                if i > 0 && j > 0 {
                    sides.append([vertices[i][j],
                                  vertices[i][j - 1],
                                  vertices[i - 1][j - 1]])
                    verticesIndexes.append([i * step + j, i * step + j - 1, (i - 1) * step + (j - 1)])
                    sides.append([vertices[i][j],
                                  vertices[i - 1][j],
                                  vertices[i - 1][j - 1]])
                    verticesIndexes.append([i * step + j, (i - 1) * step + j, (i - 1) * step + (j - 1)])
                }
            }
        }
        
        self.vertices = vertices.reduce([], { $0 + $1 })
    }
    
}


