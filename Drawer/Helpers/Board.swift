//
//  Board.swift
//  Drawer
//
//  Created by Mikhail on 23.10.2021.
//

import UIKit

class Board {
    
    private var board: [[UIColor]] = []
    
    var drawingColor: UIColor
    
    let width: Int
    
    let height: Int
    
    init(width: Int, height: Int, color: UIColor) {
        self.width = width
        self.height = height
        drawingColor = color
        if board.isEmpty {
            for _ in 0..<height {
                board.append([UIColor](repeating: .systemBackground, count: width))
            }
        }
    }
    
    func setPixel(_ x: Int, _ y: Int, color: UIColor? = nil) {
        guard x >= 0 && x < width && y >= 0 && y < height else { return }
        board[y][x] = color ?? drawingColor
    }
    
    func getPixel(_ x: Int, _ y: Int) -> UIColor? {
        guard x >= 0 && x < width && y >= 0 && y < height else { return nil }
        return board[y][x]
    }
    
    func getImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: width, height: height))
        return renderer.image { context in
            context.cgContext.setLineCap(.round)
            context.cgContext.setBlendMode(.normal)
            context.cgContext.setLineWidth(2)
            
            for y in 0 ..< height {
                var previousColor: UIColor? = nil
                var currentColor: UIColor? = nil
                var index: Int = 0
                for x in 0 ... width {
                    currentColor = getPixel(x, y)
                    if currentColor != previousColor, let previousColor = previousColor {
                        context.cgContext.move(to: .init(x: index, y: y))
                        context.cgContext.addLine(to: .init(x: x - 1, y: y))
                        context.cgContext.setStrokeColor(previousColor.cgColor)
                        context.cgContext.setLineWidth(1)
                        context.cgContext.strokePath()
                        index = x
                    }
                    previousColor = currentColor
                }
            }
        }
    }
    
}

extension Board {
    
    convenience init(size: CGSize, color: UIColor) {
        self.init(width: Int(size.width), height: Int(size.height), color: color)
    }
    
    func setPixel(_ x: CGFloat, _ y: CGFloat, color: UIColor? = nil) {
        setPixel(Int(x), Int(y), color: color)
    }
    
    func setPixel(point: CGPoint, color: UIColor? = nil) {
        setPixel(Int(point.x), Int(point.y), color: color)
    }
    
    func getPixel(_ x: CGFloat, _ y: CGFloat) -> UIColor? {
        return getPixel(Int(x), Int(y))
    }
    
    func getPixel(at point: CGPoint) -> UIColor? {
        return getPixel(Int(point.x), Int(point.y))
    }
    
}
