//
//  Array+Point3DTransform.swift
//  Drawer
//
//  Created by Mikhail on 23.01.2022.
//

import Foundation
import simd

extension Array where Element == [Point3D] {
    func transform(_ closure: (Point3D) -> Point3D) -> [[Point3D]] {
        return self.map({ $0.map({ closure($0) }) })
    }
}

extension Array where Element == Point3D {
    func transform(_ closure: (Point3D) -> Point3D) -> [Point3D] {
        return self.map({ closure($0) })
    }
}
