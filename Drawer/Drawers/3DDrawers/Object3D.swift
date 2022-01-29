//
//  Object3D.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

class Object3D {
    
    private let closePerspectiveProjectionMatrix: float4x4
    private let distantPerspectiveProjectionMatrix: float4x4
    
    private let lineDrawer: LineDrawer = .init()
    
    var sides: [[Point3D]] = []
    var center: Point3D
    
    var projection: Object3DOptions.Projection = .parallel
    
    var sideVisibility: SideVisibility = RobertsAlgorithm()
    var showInvisibleSides: Bool = false
    
    init() {
        center = .init(0, 0, 0, 0)
        
        closePerspectiveProjectionMatrix = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 0, w: -1 / 200),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
        distantPerspectiveProjectionMatrix = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 0, w: -1 / 600),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
    }
    
    func draw(context: CGContext, board: Board) {
        var shape: [[Point3D]]
        switch projection {
        case .parallel:
            shape = sides
        case .perspectiveClose:
            shape = sides.transform({ $0 * closePerspectiveProjectionMatrix })
            shape = normalized(matrix: shape)
        case .perspectiveDistant:
            shape = sides.transform({ $0 * distantPerspectiveProjectionMatrix })
            shape = normalized(matrix: shape)
        }
        
        updateCenter()
        
        for side in shape {
            if !showInvisibleSides && !sideVisibility.isSideVisible(innerPoint: center, observerPoint: .init(0, 0, Float.greatestFiniteMagnitude, 0), side: side) {
                continue
            }
            
            for i in 0 ..< side.count - 1 {
                connectPoints(p1: side[i], p2: side[i + 1], context: context, board: board)
            }
            if let first = side.first, let last = side.last {
                connectPoints(p1: first, p2: last, context: context, board: board)
            }
        }
    }
    
    private func connectPoints(p1: Point3D, p2: Point3D, context: CGContext, board: Board) {
        lineDrawer.systemDraw(
            from: p1.toPoint2D()
                .translated(tx: CGFloat(board.width / 2), ty: CGFloat(board.height / 2)),
            to: p2.toPoint2D()
                .translated(tx: CGFloat(board.width / 2), ty: CGFloat(board.height / 2)),
            context: context
        )
    }
    
    private func updateCenter() {
        var vertices: Set<Point3D> = .init()
        sides.forEach({ row in row.forEach({ vertices.insert($0) }) })
        center = Array(vertices).mean()
    }
    
    func translate(tx: Float, ty: Float, context: CGContext, board: Board) {
        let translationMatrix: float4x4 = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 1, w: 0),
            Point3D(x: Float(tx), y: Float(ty), z: Float(1), w: 1)
        ])
        
        center.x += tx
        center.y += ty
        
        sides = sides.transform({ $0 * translationMatrix })
        draw(context: context, board: board)
    }
    
    func rotate(alpha: Float, theta: Float, phi: Float, context: CGContext, board: Board) {
        let xRotationMatrix: float4x4 = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: cos(alpha), z: sin(alpha), w: 0),
            Point3D(x: 0, y: -sin(alpha), z: cos(alpha), w: 0),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
        let yRotationMatrix: float4x4 = .init(rows: [
            Point3D(x: cos(theta), y: 0, z: -sin(theta), w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: sin(theta), y: 0, z: cos(theta), w: 0),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
        let zRotationMatrix: float4x4 = .init(rows: [
            Point3D(x: cos(phi), y: sin(phi), z: 0, w: 0),
            Point3D(x: -sin(phi), y: cos(phi), z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 1, w: 0),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
        sides = sides.transform({ $0 * xRotationMatrix * yRotationMatrix * zRotationMatrix })
        draw(context: context, board: board)
    }
    
    func scale(x: CGFloat, y: CGFloat, z: CGFloat, h: CGFloat, context: CGContext, board: Board) {
        let scaleMatrix: float4x4 = .init(rows: [
            Point3D(x: Float(x), y: 0, z: 0, w: 0),
            Point3D(x: 0, y: Float(y), z: 0, w: 0),
            Point3D(x: 0, y: 0, z: Float(z), w: 0),
            Point3D(x: 0, y: 0, z: 0, w: Float(h))
        ])
        sides = sides.transform({ $0 * scaleMatrix })
        
        sides = normalized(matrix: sides)
        
        draw(context: context, board: board)
    }
    
    private func normalized(matrix: [[Point3D]]) -> [[Point3D]] {
        matrix.map { matrix in
            var result = matrix
            for index in matrix.indices {
                result[index].x /= matrix[index].w
                result[index].y /= matrix[index].w
                result[index].z /= matrix[index].w
                result[index].w = 1
            }
            return result
        }
    }
    
}
