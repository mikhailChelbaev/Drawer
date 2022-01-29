//
//  RobertsAlgorithm.swift
//  Drawer
//
//  Created by Mikhail on 23.01.2022.
//

import Foundation
import simd

struct RobertsAlgorithm: SideVisibility {
    typealias Plane = (Float, Float, Float, Float)
    
    func isSideVisible(innerPoint: Point3D, observerPoint: Point3D, side: [Point3D]) -> Bool {
        guard var planeEquation = planeEquation(side: side) else {
            return true
        }
        
        let innerPointValue = innerPoint.x * planeEquation.0 + innerPoint.y * planeEquation.1 + innerPoint.z * planeEquation.2 + planeEquation.3
        
        if innerPointValue < 0 {
            planeEquation.0 *= -1
            planeEquation.1 *= -1
            planeEquation.2 *= -1
            planeEquation.3 *= -1
        }
        
        let observerPointValue = observerPoint.x * planeEquation.0 + observerPoint.y * planeEquation.1 + observerPoint.z * planeEquation.2 + planeEquation.3
        
        return observerPointValue >= 0
    }
    
    func planeEquation(side: [Point3D]) -> Plane? {
        guard side.count >= 3 else {
            return nil
        }
        
        let a: matrix_float3x3 = .init(rows: [
            SIMD3(side[0].x, side[0].y, side[0].z),
            SIMD3(side[1].x, side[1].y, side[1].z),
            SIMD3(side[2].x, side[2].y, side[2].z)
        ])
        let b: simd_float3 = .init(-1, -1, -1)
        let result: simd_float3 = simd_mul(a.inverse, b)
        
        return (result.x, result.y, result.z, 1)
    }
}
