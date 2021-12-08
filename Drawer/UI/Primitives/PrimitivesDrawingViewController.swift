//
//  DrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit

final class PrimitivesDrawingViewController: DrawingViewController, DrawerProvider {
    
    // MARK: - drawers
    
    private let lineDrawer: ShapeDrawer = LineDrawer()
    
    private let circleDrawer: ShapeDrawer = CircleDrawer()
    
    private let ellipseDrawer: ShapeDrawer = EllipseDrawer()
    
    private let polygonDrawer: PolygonDrawer = .init()
    
    private let shapeFiller: ShapeFiller = LineShapeFiller()
    
    private let polygonFiller: PolygonFiller = XORPolygonFiller()
    
    // MARK: - DrawerProvider
    
    var type: DrawingType = .line(custom: true)
    
    // MARK: - properties
    
    private var polygons: [Polygon] = []
    
    // MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        
        switch touch {
        case .first:
            switch type {
            case .fillShape:
                drawImage { context in
                    shapeFiller.fill(image: imageView.image, point: point, context: context, board: &board)
                }
                imageView.image = board.getImage()
            case .polygon:
                drawImage { context in
                    polygonDrawer.addPoint(point, context: context, board: board) { [weak self] polygon in
                        self?.polygons.append(polygon)
                    }
                }
            case .fillPolygon:
                let polygonsToFill = polygons.filter({ $0.contains(point) })
                polygonsToFill.forEach({ polygon in
                    drawImage { context in
                        polygonFiller.fill(image: imageView.image, polygon: polygon, context: context, board: &board)
                    }
                })
                imageView.image = board.getImage()
            default:
                touch = .second(firstPoint: point)
            }
        case .second(let firstPoint):
            touch = .first
            
            drawImage { context in
                switch type {
                case .line(let custom):
                    if custom {
                        lineDrawer.drawCustom(from: firstPoint, to: point, context: context, board: board)
                    } else {
                        lineDrawer.drawDefault(from: firstPoint, to: point, context: context, board: board)
                    }
                case .circle(let custom):
                    if custom {
                        circleDrawer.drawCustom(from: firstPoint, to: point, context: context, board: board)
                    } else {
                        circleDrawer.drawDefault(from: firstPoint, to: point, context: context, board: board)
                    }
                case .ellipse(let custom):
                    if custom {
                        ellipseDrawer.drawCustom(from: firstPoint, to: point, context: context, board: board)
                    } else {
                        ellipseDrawer.drawDefault(from: firstPoint, to: point, context: context, board: board)
                    }
                default:
                    break
                }
            }
            
        }
    }
    
    override func clear() {
        super.clear()
        polygons = []
    }
    
}

