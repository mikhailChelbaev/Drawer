//
//  Dodecahedron.swift
//  Drawer
//
//  Created by Mikhail on 20.01.2022.
//

import UIKit
import simd

final class Dodecahedron: Object3D {
    
    init(radius: Float = 100) {
        super.init()
        
        let radius = radius * 1.3
        // create vertices
        var icosahedronVertices: [Point3D] = []
        
        var angle: Float
        for i in 0 ..< 10 {
            angle = Float(i) * .pi / 5
            icosahedronVertices.append(Point3D(x: radius * cos(angle),
                                    y: radius * sin(angle),
                                    z: (i % 2 == 0 ? 1 : -1) * radius / 2,
                                    w: 1))
        }
        
        icosahedronVertices.append(Point3D(x: 0, y: 0, z: sqrt(5) / 2 * radius, w: 1))
        icosahedronVertices.append(Point3D(x: 0, y: 0, z: -sqrt(5) / 2 * radius, w: 1))
        
        
        var dodecahedronSide: [Point3D] = []
        var dodecahedronTop: [Point3D] = []
        var dodecahedronBottom: [Point3D] = []
        
        for i in 0 ..< 10 {
            dodecahedronSide.append(mean([icosahedronVertices[i],
                                          icosahedronVertices[(i + 1) % 10],
                                          icosahedronVertices[(i + 2) % 10]]))
            if i % 2 == 0 {
                dodecahedronTop.append(mean([icosahedronVertices[i],
                                             icosahedronVertices[(i + 2) % 10],
                                             icosahedronVertices[10]]))
            } else {
                dodecahedronBottom.append(mean([icosahedronVertices[i],
                                                icosahedronVertices[(i + 2) % 10],
                                                icosahedronVertices[11]]))
            }
        }
        
        // create sides
        func createAndAddTriangles(_ points: [Point3D]) {
            let center: Point3D = mean(points)
            for j in points.indices {
                sides.append([points[j], points[(j + 1) % 5], center])
            }
        }
        
        sides = []
        var currentPoints: [Point3D]
        for i in 0 ..< 10 {
            if i % 2 == 0 {
                currentPoints = [dodecahedronSide[i],
                                 dodecahedronSide[(i + 1) % 10],
                                 dodecahedronSide[(i + 2) % 10],
                                 dodecahedronTop[(i / 2 + 1) % 5],
                                 dodecahedronTop[(i / 2) % 5]]
            } else {
                currentPoints = [dodecahedronSide[i],
                                 dodecahedronSide[(i + 1) % 10],
                                 dodecahedronSide[(i + 2) % 10],
                                 dodecahedronBottom[(i / 2 + 1) % 5],
                                 dodecahedronBottom[(i / 2) % 5]]
            }
            
            createAndAddTriangles(currentPoints)
        }
        
        createAndAddTriangles(dodecahedronTop)
        createAndAddTriangles(dodecahedronBottom)
    }
    
    private func mean(_ points: [Point3D]) -> Point3D {
        let size = Float(points.count)
        return Point3D(x: points.reduce(0) { $0 + $1.x } / size,
                       y: points.reduce(0) { $0 + $1.y } / size,
                       z: points.reduce(0) { $0 + $1.z } / size,
                       w: 1)
    }
    
}
