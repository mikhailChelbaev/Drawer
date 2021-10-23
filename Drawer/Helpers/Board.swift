//
//  Board.swift
//  Drawer
//
//  Created by Mikhail on 23.10.2021.
//

import UIKit

struct Board {
    
    private var board: [[UIColor]] = []
    
    var drawingColor: UIColor
    
    private let width: Int
    
    private let height: Int
    
    init(width: Int, height: Int, color: UIColor) {
        self.width = width
        self.height = height
        drawingColor = color
        if board.isEmpty {
            for _ in 0..<height {
                board.append([UIColor](repeating: .white, count: width))
            }
        }
    }
    
    mutating func setPixel(_ x: Int, _ y: Int) {
        guard x > 0 && x < width && y > 0 && y < height else { return }
        board[y][x] = drawingColor
    }
    
    func getPixel(_ x: Int, _ y: Int) -> UIColor? {
        guard x > 0 && x < width && y > 0 && y < height else { return nil }
        return board[y][x]
    }
    
}

extension Board {
    
    init(size: CGSize, color: UIColor) {
        self.init(width: Int(size.width), height: Int(size.height), color: color)
    }
    
    mutating func setPixel(_ x: CGFloat, _ y: CGFloat) {
        setPixel(Int(x), Int(y))
    }
    
    mutating func setPixel(point: CGPoint) {
        setPixel(Int(point.x), Int(point.y))
    }
    
    func getPixel(_ x: CGFloat, _ y: CGFloat) -> UIColor? {
        return getPixel(Int(x), Int(y))
    }
    
    func getPixel(at point: CGPoint) -> UIColor? {
        return getPixel(Int(point.x), Int(point.y))
    }
    
}
