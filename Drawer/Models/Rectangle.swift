//
//  Rectangle.swift
//  Drawer
//
//  Created by Mikhail on 16.11.2021.
//

import Foundation

struct Rectangle {
    
    let minX: CGFloat
    
    let minY: CGFloat
    
    let maxX: CGFloat
    
    let maxY: CGFloat
    
    var topLeft: CGPoint {
        .init(x: minX, y: minY)
    }
    
    var topRight: CGPoint {
        .init(x: maxX, y: minY)
    }
    
    var bottomLeft: CGPoint {
        .init(x: minX, y: maxY)
    }
    
    var bottomRight: CGPoint {
        .init(x: maxX, y: maxY)
    }
    
    var left: Line {
        .init(p1: topLeft, p2: bottomLeft)
    }
    
    var top: Line {
        .init(p1: topLeft, p2: topRight)
    }
    
    var right: Line {
        .init(p1: topRight, p2: bottomRight)
    }
    
    var bottom: Line {
        .init(p1: bottomLeft, p2: bottomRight)
    }
    
}
