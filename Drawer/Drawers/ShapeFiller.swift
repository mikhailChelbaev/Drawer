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
                drawPixel(x, y, context, board: &board)
                x += 1
            }
            
            xRight = x - 1  // save right x
            x = temp - 1 // recover x coordinate
            
            // fill left interval
            while x > 0, board.getPixel(x, y) == currentColor {
                drawPixel(x, y, context, board: &board)
                x -= 1
            }
            
            xLeft = x + 1 // save left x
            
            
            guard xLeft < xRight else { continue } // check that xRight > xLeft
            
            // find not filled pixels above and below
            for newY in [y - 1, y + 1] {
                var numberOfColorChanges: Int = 0
                var previousColor: UIColor = board.getPixel(xLeft, newY)
                var newColor: UIColor = .white
                for newX in xLeft...(xRight + 2) { // xRight + 1
                    newColor = board.getPixel(newX, newY)
                    if newColor != previousColor && currentColor == previousColor {
                        numberOfColorChanges += 1
                        if numberOfColorChanges % 2 == 1 {
                            stack.push((newX - 1, newY))
                        }
                    }
                    previousColor = newColor
                }
            }
            
        }
    }
    
}
