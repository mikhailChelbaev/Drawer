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
    
    private let data: [SectionDataSource] = [
        .init(title: "Line", drawing: [.line(custom: true), .line(custom: false)]),
        .init(title: "Circle", drawing: [.circle(custom: true), .circle(custom: false)]),
        .init(title: "Ellipse", drawing: [.ellipse(custom: true), .ellipse(custom: false)]),
        .init(title: "Other", drawing: [.fill, .colorPicker, .clear])
    ]
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        return tv
    }()
    
    private let aboutDeveloperButton: UIButton = {
        let button = UIButton()
        button.setTitle("About developer", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = tableView.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(aboutDeveloperButton)
        aboutDeveloperButton.stickToSuperviewEdges([.left, .right, .bottom], insets: .init(top: 0, left: 0, bottom: 20, right: 0))
        
        view.addSubview(tableView)
        tableView.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 20, left: 0, bottom: 0, right: 0))
        tableView.bottom(20, to: aboutDeveloperButton)
        
        tableView.selectRow(at: .init(row: 0, section: 0), animated: false, scrollPosition: .top)
        aboutDeveloperButton.addTarget(self, action: #selector(showAboutDeveloper), for: .touchUpInside)
    }
    
    @objc private func showAboutDeveloper() {
        let controller = UIHostingController(rootView: AboutDeveloperView())
        present(controller, animated: true, completion: nil)
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
        case .circle, .line, .ellipse, .fill:
            provider?.type = drawingType
        case .colorPicker:
            let controller = UIColorPickerViewController()
            controller.delegate = self
            present(controller, animated: true, completion: nil)
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
