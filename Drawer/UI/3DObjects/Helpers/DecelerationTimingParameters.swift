//
//  DecelerationTimingParameters.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit

public struct DecelerationTimingParameters {
    public var initialValue: CGPoint
    public var initialVelocity: CGPoint
    public var decelerationRate: CGFloat
    public var threshold: CGFloat
    
    public init(initialValue: CGPoint, initialVelocity: CGPoint, decelerationRate: CGFloat, threshold: CGFloat) {
        assert(decelerationRate > 0 && decelerationRate < 1)
        
        self.initialValue = initialValue
        self.initialVelocity = initialVelocity
        self.decelerationRate = decelerationRate
        self.threshold = threshold
    }
}

public extension DecelerationTimingParameters {
    
    var destination: CGPoint {
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue - initialVelocity / dCoeff
    }
    
    var duration: TimeInterval {
        guard initialVelocity.length > 0 else { return 0 }
        
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(-dCoeff * threshold / initialVelocity.length) / dCoeff)
    }
    
    func value(at time: TimeInterval) -> CGPoint {
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue + (pow(decelerationRate, CGFloat(1000 * time)) - 1) / dCoeff * initialVelocity
    }
    
    func velocity(at time: TimeInterval) -> CGPoint {
        return initialVelocity * pow(decelerationRate, CGFloat(1000 * time))
    }
    
}

public extension CGPoint {
    
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        return (self - other).length
    }
    
}

public extension CGPoint {
    
    static prefix func -(lhs: CGPoint) -> CGPoint {
        return CGPoint(x: -lhs.x, y: -lhs.y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return rhs * lhs
    }
    
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
}
