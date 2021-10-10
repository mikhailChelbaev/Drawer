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
    
    var pretty: String {
        switch self {
        case .line(let custom):
            return custom ? "Custom line" : "Default line"
        case .circle(let custom):
            return custom ? "Custom circle" : "Default circle"
        case .ellipse(let custom):
            return custom ? "Custom ellipse" : "Default ellipse"
        case .colorPicker:
            return "Select color"
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
        }
    }
}
