//
//  CGPoint+Translated.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit

extension CGPoint {
    
    func translated(tx: CGFloat, ty: CGFloat) -> CGPoint {
        return .init(x: tx - x, y: ty - y)
    }
    
}
