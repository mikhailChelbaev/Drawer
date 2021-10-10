//
//  SplitViewController.swift
//  Drawer
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    private let settings: DrawSettingsViewController = .init()
    
    private let drawing: DrawingViewController = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let settingsWrapper = UINavigationController(rootViewController: settings)
        settings.title = "Board"
        settingsWrapper.navigationBar.prefersLargeTitles = true
        settingsWrapper.navigationBar.backgroundColor = .systemGroupedBackground
        
        viewControllers = [settingsWrapper, drawing]
        
        settings.provider = drawing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
