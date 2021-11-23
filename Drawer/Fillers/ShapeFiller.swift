//
//  ShapeFiller.swift
//  Drawer
//
//  Created by Mikhail on 11.10.2021.
//

import UIKit

protocol ShapeFiller: PixelDrawer {
    
    func fill(image: UIImage?, point: CGPoint, context: CGContext, board: inout Board)
    
}

final class LineShapeFiller: ShapeFiller {
    
    typealias Point = (x: Int, y: Int)
    
    private var stack: Stack<Point> = .init()
    
    private var currentColor: UIColor!
    
    func fill(image: UIImage?, point: CGPoint, context: CGContext, board: inout Board) {
        guard let image = image,
              let width = image.cgImage?.width
        else {
            return
        }
        
        currentColor = board.getPixel(at: point)
        stack.clear()
        
        var x: Int = Int(point.x)
        var y: Int = Int(point.y)
        var xRight: Int
        var xLeft: Int
        
        stack.push((x, y)) // initialize stack with point
        while !stack.isEmpty {
            let pixel = stack.pop() // pop pixel
            let temp = pixel.x // save x coordinate
            
            x = pixel.x
            y = pixel.y
            
            // fill right interval
            while x < width, board.getPixel(x, y) == currentColor {
                board.setPixel(x, y)
                x += 1
            }
            
            xRight = x - 1  // save right x
            x = temp - 1 // recover x coordinate
            
            // fill left interval
            while x > 0, board.getPixel(x, y) == currentColor {
                board.setPixel(x, y)
                x -= 1
            }
            
            xLeft = x + 1 // save left x
            
            guard xLeft < xRight else { continue } // check that xRight > xLeft
            
            // find not filled pixels above and below
            for newY in [y - 1, y + 1] {
                var flag: Bool = false // flag to find intervals
                var previousColor: UIColor? // color of pixel with (newX - 1, newY) coordinates
                var newColor: UIColor? // color of pixel with (newX, newY) coordinates
                for newX in xLeft...xRight {
                    newColor = board.getPixel(newX, newY)
                    if newColor != previousColor {
                        if currentColor == previousColor { // if we found right border
                            flag = true // change flag
                            stack.push((newX - 1, newY)) // push position to stack
                        } else { // if we found left border
                            flag = false // change flag
                        }
                    }
                    previousColor = newColor
                }
                if !flag { // if we found left border and did not find right border
                    stack.push((xRight, newY)) // push position to stack
                }
            }
            
        }
    }
    
}
