//
//  SelectDrawingViewController.swift
//  Drawer
//
//  Created by Mikhail on 23.11.2021.
//

import UIKit
import SwiftUI

final class SelectDrawingViewController: UIViewController {
    
    enum ShapeTypes {
        case primitives
        case curves
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.text = "Selete shape type"
        return label
    }()
    
    private let aboutDeveloperButton: UIButton = {
        let button = UIButton()
        button.setTitle("About developer", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private var primitivesButton: UIButton!
    
    private var curvesButton: UIButton!
    
    override func loadView() {
        super.loadView()
        primitivesButton = createButton(for: .primitives)
        curvesButton = createButton(for: .curves)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        let stack = UIStackView(arrangedSubviews: [primitivesButton, curvesButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.placeInCenter()
        
        view.addSubview(label)
        label.bottom(50, to: stack)
        label.centerHorizontally()
        
        view.addSubview(aboutDeveloperButton)
        aboutDeveloperButton.stickToSuperviewEdges([.left, .right, .bottom], insets: .init(top: 0, left: 0, bottom: 20, right: 0))
        
        aboutDeveloperButton.addTarget(self, action: #selector(showAboutDeveloper), for: .touchUpInside)
        primitivesButton.addTarget(self, action: #selector(openPrimitives), for: .touchUpInside)
        curvesButton.addTarget(self, action: #selector(openCurves), for: .touchUpInside)
    }
    
    private func createButton(for type: ShapeTypes) -> UIButton {
        let config: UIButton.Configuration = .filled()
        let button = UIButton()
        button.configuration = config
        button.setTitle(buttonTitle(for: type), for: .normal)
        button.exactSize(.init(width: 150, height: 44))
        return button
    }
    
    func buttonTitle(for type: ShapeTypes) -> String {
        type == .curves ? "Curves" : "Primitives"
    }
    
    func dataSource(for type: ShapeTypes) -> [SectionDataSource] {
        switch type {
        case .primitives:
            return [
                .init(title: "Line", drawing: [.line(custom: true), .line(custom: false), .polygon]),
                .init(title: "Circle", drawing: [.circle(custom: true), .circle(custom: false)]),
                .init(title: "Ellipse", drawing: [.ellipse(custom: true), .ellipse(custom: false)]),
                .init(title: "Fill", drawing: [.fillShape]),
                .init(title: "Other", drawing: [.clipping, .colorPicker, .clear])
            ]
        case .curves:
            return [
                .init(title: "Curves", drawing: [.bezier, .casteljauBezier, .spline]),
                .init(title: "Other", drawing: [.colorPicker, .clear])
            ]
        }
    }
    
    @objc private func showAboutDeveloper() {
        let controller = UIHostingController(rootView: AboutDeveloperView())
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func openPrimitives() {
        let settings = DrawSettingsViewController(data: dataSource(for: .primitives))
        let drawer = PrimitivesDrawingViewController()
        settings.provider = drawer
        let controller = SplitViewController(settings: settings, drawing: drawer)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func openCurves() {
        let settings = DrawSettingsViewController(data: dataSource(for: .curves))
        let drawer = CurvesDrawingViewController()
        settings.provider = drawer
        let controller = SplitViewController(settings: settings, drawing: drawer)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
     
}
