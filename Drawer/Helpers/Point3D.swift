//
//  Point3D.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

typealias Point3D = simd_float4

extension Point3D {
    
    func project(point: Point3D) -> Point3D {
        let projectionMatrix: float4x4 = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
        return point * projectionMatrix
    }
    
    func toPoint2D() -> CGPoint {
        let point = project(point: self)
        return .init(x: CGFloat(point.x), y: CGFloat(point.y))
    }
    
}
