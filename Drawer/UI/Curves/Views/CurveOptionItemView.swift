//
//  CurveOptionsView.swift
//  Drawer
//
//  Created by Mikhail on 24.11.2021.
//

import UIKit

enum OptionState {
    case enabled
    case disabled
}

final class CurveOptionItemView: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let switchView = UISwitch()
    
    var valueDidChange: ((Bool) -> Void)?
    
    init(title titleText: String, valueDidChange: ((Bool) -> Void)?) {
        super.init(frame: .zero)
        
        self.title.text = titleText
        self.valueDidChange = valueDidChange
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        switchView.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        
        addSubview(switchView)
        switchView.trailing(20)
        switchView.centerVertically()
        
        addSubview(title)
        title.leading(20)
        title.trailing(12, to: switchView)
        title.centerVertically()
        
        height(48)
    }
    
    @objc private func handleSwitch() {
        valueDidChange?(switchView.isOn)
    }
    
    func setState(_ state: OptionState) {
        switch state {
        case .enabled:
            title.textColor = .label
            switchView.isEnabled = true
        case .disabled:
            title.textColor = .label.withAlphaComponent(0.2)
            switchView.isEnabled = false
        }
    }
    
}
