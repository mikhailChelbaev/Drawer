//
//  Object3D.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

protocol Exportable {
    func export() -> Data?
}

class Object3D {
    
    private let closePerspectiveProjectionMatrix: float4x4
    private let distantPerspectiveProjectionMatrix: float4x4
    
    private let lineDrawer: LineDrawer = .init()
    
    var sides: [[Point3D]] = []
    var vertices: [Point3D] = []
    var verticesIndexes: [[Int]] = []
    var center: Point3D
    
    var projection: Object3DOptions.Projection = .parallel
    
    var sideVisibility: SideVisibility = RobertsAlgorithm2()
    var showInvisibleSides: Bool = false
    var allowHideInvisibleSides: Bool = true
    
    init() {
        center = .init(0, 0, 0, 0)
        
        closePerspectiveProjectionMatrix = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 1, w: -1 / 200),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
        distantPerspectiveProjectionMatrix = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 1, w: -1 / 600),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
    }
    
    func draw(context: CGContext, board: Board) {
        var shape: [[Point3D]]
        let observerPoint: Point3D = .init(0, 0, Float.greatestFiniteMagnitude, 1)
        
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
        
        updateCenter(sides: shape)
        
        for side in shape {
            if !showInvisibleSides &&
                allowHideInvisibleSides &&
                !sideVisibility.isSideVisible(innerPoint: center, observerPoint: observerPoint, side: side) {
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
    
    private func connectPoints(p1: Point3D,
                               p2: Point3D,
                               context: CGContext,
                               board: Board) {
        lineDrawer.systemDraw(
            from: p1.toPoint2D()
                .translated(tx: CGFloat(board.width / 2), ty: CGFloat(board.height / 2)),
            to: p2.toPoint2D()
                .translated(tx: CGFloat(board.width / 2), ty: CGFloat(board.height / 2)),
            context: context
        )
    }
    
    private func updateCenter(sides: [[Point3D]]) {
        var vertices: Set<Point3D> = .init()
        sides.forEach({ row in row.forEach({ vertices.insert($0) }) })
        center = Array(vertices).mean()
    }
    
    // MARK: - Object manipulations
    
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
        vertices = vertices.transform({ $0 * translationMatrix })
        
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
        vertices = vertices.transform({ $0 * xRotationMatrix * yRotationMatrix * zRotationMatrix })
        
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
        
        vertices = vertices.transform({ $0 * scaleMatrix })
        vertices = normalized(matrix: vertices)
        
        draw(context: context, board: board)
    }
    
    // MARK: - normalize
    
    private func normalized(matrix: [[Point3D]]) -> [[Point3D]] {
        matrix.map { matrix in
            normalized(matrix: matrix)
        }
    }
    
    private func normalized(matrix: [Point3D]) -> [Point3D] {
        var result = matrix
        for index in matrix.indices {
            result[index] = normalized(point: matrix[index])
        }
        return result
    }
    
    private func normalized(point: Point3D) -> Point3D {
        var result = point
        result.x /= point.w
        result.y /= point.w
        result.z /= point.w
        result.w = 1
        return result
    }
    
}

// MARK: - protocol Exportable

extension Object3D: Exportable {
    func export() -> Data? {
        var data: String = ""
        
        data += "\(vertices.count)\n"
        for vertex in vertices {
            data += "\(vertex[0]), \(vertex[1]), \(vertex[2])\n"
        }
        
        data += "\(verticesIndexes.count)\n"
        for index in verticesIndexes {
            data += "\(index[0]), \(index[1]), \(index[2])\n"
        }
        
        return data.data(using: .utf8)
    }
}
