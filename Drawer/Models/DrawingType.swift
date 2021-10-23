//
//  DrawingType.swift
//  Drawer
//
//  Created by Mikhail on 04.10.2021.
//

import UIKit

enum DrawingType {
    case line(custom: Bool)
    case circle(custom: Bool)
    case ellipse(custom: Bool)
    case colorPicker
    case clear
    case fill
    case polygon
    
    var pretty: String {
        switch self {
        case .line(let custom):
            return custom ? "Custom line" : "Default line"
        case .circle(let custom):
            return custom ? "Custom circle" : "Default circle"
        case .ellipse(let custom):
            return custom ? "Custom ellipse" : "Default ellipse"
        case .polygon:
            return "Polygon"
        case .colorPicker:
            return "Select color"
        case .clear:
            return "Clear"
        case .fill:
            return "Fill"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .line:
            return UIImage(systemName: "line.diagonal")
        case .circle:
            return UIImage(systemName: "circle")
        case .ellipse:
            return UIImage(systemName: "oval")
        case .colorPicker:
            return UIImage(systemName: "square.fill")
        case .clear:
            return UIImage(systemName: "trash.fill")
        case .fill:
            return UIImage(systemName: "paintbrush.fill")
        case .polygon:
            return UIImage(systemName: "triangle")
        }
    }
}
