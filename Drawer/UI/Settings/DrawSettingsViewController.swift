//
//  DrawSettingsViewController.swift
//  Drawer
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit
import SwiftUI

class DrawSettingsViewController: UIViewController {
    
    weak var provider: DrawerProvider?
    
    private let data: [SectionDataSource]
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        return tv
    }()
    
    init(data: [SectionDataSource]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = tableView.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.stickToSuperviewEdges(.all, insets: .init(top: 20, left: 0, bottom: 20, right: 0))
        
        tableView.selectRow(at: .init(row: 0, section: 0), animated: false, scrollPosition: .top)
    }

}

extension DrawSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].drawing.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drawing = data[indexPath.section].drawing[indexPath.item]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        if case .colorPicker = drawing {
            cell.imageView?.image = drawing.image?.withTintColor(provider?.color ?? .black, renderingMode: .alwaysOriginal)
        } else {
            cell.imageView?.image = drawing.image
        }
        cell.textLabel?.text = drawing.pretty
        return cell
    }
    
}

extension DrawSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drawingType = data[indexPath.section].drawing[indexPath.item]
        switch drawingType {
        case .circle, .line, .ellipse, .fillShape, .fillPolygon, .polygon: // primitives
            provider?.type = drawingType
        case .bezier, .spline, .casteljauBezier: // curves
            provider?.type = drawingType
        case .cube, .pyramid, .tetrahedron, .octahedron, .icosahedron, .dodecahedron, .sphere, .torus, .spring, .spiral, .fruit: // 3D
            provider?.type = drawingType
        case .clipping:
            let controller = ClippingViewController()
            let wrapper = UINavigationController(rootViewController: controller)
            wrapper.modalPresentationStyle = .fullScreen
            present(wrapper, animated: true, completion: {
                tableView.deselectRow(at: indexPath, animated: false)
            })
        case .colorPicker:
            let controller = UIColorPickerViewController()
            controller.delegate = self
            present(controller, animated: true)
        case .clear:
            provider?.clear()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
}

extension DrawSettingsViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        provider?.color = viewController.selectedColor
        viewController.dismiss(animated: true)
        tableView.reloadData()
    }
    
}
