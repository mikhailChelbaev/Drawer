//
//  Sphere.swift
//  Drawer
//
//  Created by Mikhail on 22.01.2022.
//

import UIKit
import simd

final class Sphere: Object3D {
    
    init(radius: Float = 100) {
        super.init()
        
        // create vertices
        var vertices: [Point3D] = []
        var x: Float, y: Float, z: Float
        let step: Int = 10
        let floatStep: Float = Float(step) // optimisation purpose
        var a: Float, b: Float
        var verticesInSphere: Int
        
        for i in stride(from: 0, through: step, by: 1) {
            for j in stride(from: 0, through: step, by: 1) {
                a = Float.pi / floatStep * Float(i)
                b = 2 * Float.pi / floatStep * Float(j)
                
                x = radius * sin(a) * cos(b)
                y = radius * sin(a) * sin(b)
                z = radius * cos(a)
                vertices.append(Point3D(x: x, y: y, z: z, w: 1))
                if i > 0 && j > 0 {
                    verticesInSphere = i * step + j
                    sides.append([vertices[verticesInSphere - 1], vertices[verticesInSphere], vertices[verticesInSphere - step - 1]])
                    sides.append([vertices[verticesInSphere], vertices[verticesInSphere - step], vertices[verticesInSphere - step - 1]])
                }
            }
        }
    }
    
}
