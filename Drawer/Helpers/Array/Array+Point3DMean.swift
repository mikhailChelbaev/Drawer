//
//  Array+Point3DMean.swift
//  Drawer
//
//  Created by Mikhail on 23.01.2022.
//

import Foundation
import simd

extension Array where Element == Point3D {
    func mean() -> Element {
        let size = Float(count)
        return Point3D(x: reduce(0) { $0 + $1.x } / size,
                       y: reduce(0) { $0 + $1.y } / size,
                       z: reduce(0) { $0 + $1.z } / size,
                       w: 1)
    }
}
