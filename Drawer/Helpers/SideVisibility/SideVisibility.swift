//
//  SideVisibility.swift
//  Drawer
//
//  Created by Mikhail on 23.01.2022.
//

import Foundation
import simd

protocol SideVisibility {
    func isSideVisible(innerPoint: Point3D, observerPoint: Point3D, side: [Point3D]) -> Bool
}
