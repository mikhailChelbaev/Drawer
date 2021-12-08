//
//  Object3DOptionItemView.swift
//  Drawer
//
//  Created by Mikhail on 07.12.2021.
//

import UIKit

final class Object3DOptionItemView: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private var action: () -> Void
    
    init(title titleText: String, action: @escaping () -> Void) {
        self.action = action
        
        super.init(frame: .zero)
        
        title.text = titleText
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        
        addSubview(title)
        title.leading(20)
        title.trailing(20)
        title.centerVertically()
        
        height(48)
    }
    
    func setTitle(_ text: String) {
        title.text = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action()
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .systemGray5
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .systemBackground
        }
    }
    
}

