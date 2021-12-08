//
//  SplitViewController.swift
//  Drawer
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    private let settings: DrawSettingsViewController
    
    private let drawing: DrawingViewController
    
    init(settings: DrawSettingsViewController, drawing: DrawingViewController) {
        self.settings = settings
        self.drawing = drawing
        
        super.init(nibName: nil, bundle: nil)
        
        let settingsWrapper = UINavigationController(rootViewController: settings)
        settings.title = "Board"
        settingsWrapper.navigationBar.prefersLargeTitles = true
        settingsWrapper.navigationBar.backgroundColor = .systemGroupedBackground
        settings.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeController))
        
        viewControllers = [settingsWrapper, drawing]
        
        minimumPrimaryColumnWidth = 400
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        func bitSet(_ bits: [Int]) -> UInt {
            return bits.reduce(0) { $0 | (1 << $1) }
        }

        func property(_ property: String, object: NSObject, set: [Int], clear: [Int]) {
            if let value = object.value(forKey: property) as? UInt {
                object.setValue((value & ~bitSet(clear)) | bitSet(set), forKey: property)
            }
        }

        // disable full-screen button
        if  let NSApplication = NSClassFromString("NSApplication") as? NSObject.Type,
            let sharedApplication = NSApplication.value(forKeyPath: "sharedApplication") as? NSObject,
            let windows = sharedApplication.value(forKeyPath: "windows") as? [NSObject]
        {
            for window in windows {
                let resizable = 3
                property("styleMask", object: window, set: [], clear: [resizable])
                let fullScreenPrimary = 7
                let fullScreenAuxiliary = 8
                let fullScreenNone = 9
                property("collectionBehavior", object: window, set: [fullScreenNone], clear: [fullScreenPrimary, fullScreenAuxiliary])
            }
        }
    }
    
    @objc private func closeController() {
        dismiss(animated: true, completion: nil)
    }
    
}
