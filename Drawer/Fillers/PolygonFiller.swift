//
//  PolygonFiller.swift
//  Drawer
//
//  Created by Mikhail on 25.10.2021.
//

import UIKit

protocol PolygonFiller: PixelDrawer {
    
    func fill(image: UIImage?, polygon: Polygon, context: CGContext, board: inout Board)
    
}

final class XORPolygonFiller: PolygonFiller {
    
    func fill(image: UIImage?, polygon: Polygon, context: CGContext, board: inout Board) {        
        let xCenter = Int(polygon.right.x - polygon.left.x) / 2 + Int(polygon.left.x)
        let currentColor: UIColor? = board.getPixel(
            xCenter,
            Int(polygon.bottom.y - polygon.top.y) / 2 + Int(polygon.top.y)
        )
        let drawingColor: UIColor = board.drawingColor
        
        var leftPoint: Int
        var rightPoint: Int
        var y: Int
        var pointColor: UIColor?
        
        for point in polygon.points + [polygon.top, polygon.bottom] {
            y = Int(point.y)
            
            if Int(point.x) >= xCenter {
                leftPoint = xCenter
                rightPoint = Int(point.x)
            } else {
                leftPoint = Int(point.x)
                rightPoint = xCenter - 1
            }
            
            for x in leftPoint...rightPoint {
                pointColor = board.getPixel(x, y)
                board.setPixel(x, y, color: xor(currentColor: currentColor, pointColor: pointColor, drawingColor: drawingColor))
            }
        }
        
    }
    
    private func xor(
        currentColor: UIColor?,
        pointColor: UIColor?,
        drawingColor: UIColor
    ) -> UIColor? {
        pointColor == drawingColor ? currentColor : drawingColor
    }
    
}
