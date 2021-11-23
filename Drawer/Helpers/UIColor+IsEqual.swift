//
//  UIColor+IsEqual.swift
//  Drawer
//
//  Created by Mikhail on 10.11.2021.
//

import UIKit

extension UIColor {
    
    static func == (lhs: UIColor, rhs: UIColor) -> Bool {
        var la: CGFloat = 0.0; var ra: CGFloat = 0.0
        var lr: CGFloat = 0.0; var rr: CGFloat = 0.0
        var lg: CGFloat = 0.0; var rg: CGFloat = 0.0
        var lb: CGFloat = 0.0; var rb: CGFloat = 0.0
        lhs.getRed(&lr, green: &lg, blue: &lb, alpha: &la)
        lhs.getRed(&rr, green: &rg, blue: &rb, alpha: &ra)
        return la == ra && lr == rr && lg == rg && lb == rb
    }
    
}
