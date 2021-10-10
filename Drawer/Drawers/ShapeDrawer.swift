//
//  ShapeDrawer.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import Foundation

protocol ShapeDrawer {
    
    func drawDefault(from p1: CGPoint, to p2: CGPoint, context: CGContext)
    
    func drawCustom(from p1: CGPoint, to p2: CGPoint, context: CGContext)
    
}

extension ShapeDrawer {
    
    func drawPixel(_ x: Int, _ y: Int, _ contex: CGContext) {
        drawPixel(point: .init(x: x, y: y), context: contex)
    }
    
    func drawPixel(point: CGPoint, context: CGContext) {
        context.move(to: point)
        context.addLine(to: point)
    }
    
    func processPixels(in image: UIImage, color: UIColor) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        let fromColor        = RGBA32(from: .white)

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }

        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

        for row in 0 ..< Int(height) {
                for column in 0 ..< Int(width) {
                    let offset = row * width + column
                    if pixelBuffer[offset] == fromColor {
                        pixelBuffer[offset] = .red
                    }
                }
            }

        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)

        return outputImage
    }
    
}

import UIKit
struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }
    
    init(from uiColor: UIColor) {
        var red   = CGFloat(0)
        var green = CGFloat(0)
        var blue  = CGFloat(0)
        var alpha = CGFloat(0)

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
    static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
    static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
    static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
    static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
    static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
    static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}
