//
//  Object3D.swift
//  Drawer
//
//  Created by Mikhail on 08.12.2021.
//

import UIKit
import simd

class Object3D {
    
    typealias Edge = (Int, Int)
    
    private let perspectiveProjectionMatrix: float4x4
    
    private let lineDrawer: LineDrawer = .init()
    
    var vertices: [Point3D] = []
    
    var projection: Object3DOptions.Projection = .parallel
    
    init() {
        perspectiveProjectionMatrix = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 0, w: -1 / 400),
            Point3D(x: 0, y: 0, z: 0, w: 1)
        ])
    }
    
    func draw(context: CGContext, board: Board) {
        var shape: [Point3D]
        switch projection {
        case .parallel:
            shape = vertices
        case .perspective:
            shape = vertices.map({ $0 * perspectiveProjectionMatrix })
            normalize(matrix: &shape)
        }
        let pairs: [Edge] = getDrawingEdges()
        for (i, j) in pairs {
            lineDrawer.drawCustom(
                from: shape[i].toPoint2D()
                    .translated(tx: CGFloat(board.width / 2), ty: CGFloat(board.height / 2)),
                to: shape[j].toPoint2D()
                    .translated(tx: CGFloat(board.width / 2), ty: CGFloat(board.height / 2)),
                context: context,
                board: board
            )
        }
    }
    
    func getDrawingEdges() -> [Edge] {
        fatalError("Override `getDrawingEdges` method to draw an object")
    }
    
    func translate(tx: Float, ty: Float, context: CGContext, board: Board) {
        let translationMatrix: float4x4 = .init(rows: [
            Point3D(x: 1, y: 0, z: 0, w: 0),
            Point3D(x: 0, y: 1, z: 0, w: 0),
            Point3D(x: 0, y: 0, z: 1, w: 0),
            Point3D(x: Float(tx), y: Float(ty), z: Float(1), w: 1)
        ])
        vertices = vertices.map({ $0 * translationMatrix })
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
        vertices = vertices.map({ $0 * xRotationMatrix * yRotationMatrix * zRotationMatrix })
        draw(context: context, board: board)
    }
    
    func scale(x: CGFloat, y: CGFloat, z: CGFloat, h: CGFloat, context: CGContext, board: Board) {
        let scaleMatrix: float4x4 = .init(rows: [
            Point3D(x: Float(x), y: 0, z: 0, w: 0),
            Point3D(x: 0, y: Float(y), z: 0, w: 0),
            Point3D(x: 0, y: 0, z: Float(z), w: 0),
            Point3D(x: 0, y: 0, z: 0, w: Float(h))
        ])
        vertices = vertices.map({ $0 * scaleMatrix })
        
        normalize(matrix: &vertices)
        
        draw(context: context, board: board)
    }
    
    private func normalize(matrix: inout [Point3D]) {
        for index in matrix.indices {
            matrix[index].x /= matrix[index].w
            matrix[index].y /= matrix[index].w
            matrix[index].z /= matrix[index].w
            matrix[index].w = 1
        }
    }
    
}

