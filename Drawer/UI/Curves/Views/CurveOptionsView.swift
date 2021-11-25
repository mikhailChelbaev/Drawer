//
//  CurveOptionsView.swift
//  Drawer
//
//  Created by Mikhail on 24.11.2021.
//

import UIKit

protocol CurveOptionsHandler: AnyObject {
    var referenceLine: Bool { set get }
    var compoundCurve: Bool { set get }
    var closeCurve: Bool { set get }
}

final class CurveOptionsView: UIView {
    
    enum CurveOptions {
        case referenceLine
        case compoundCurve
        case closeCurve
    }
    
    private var referenceLine: CurveOptionItemView!
    
    private var compoundCurve: CurveOptionItemView!
    
    private var closeCurve: CurveOptionItemView!
    
    weak var handler: CurveOptionsHandler? {
        didSet { updateOptions() }
    }
    
    init() {
        super.init(frame: .zero)
        setUpViews()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        referenceLine = .init(title: "Reference line", valueDidChange: { [weak self] isOn in
            self?.handler?.referenceLine = isOn
        })
        compoundCurve = .init(title: "Compound curve", valueDidChange: { [weak self] isOn in
            self?.handler?.compoundCurve = isOn
        })
        closeCurve = .init(title: "Close curve", valueDidChange: {  [weak self] isOn in
            self?.handler?.closeCurve = isOn
        })
    }
    
    private func commonInit() {        
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.16
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowRadius = 16
        
        backgroundColor = .systemBackground
        
        addSubview(referenceLine)
        referenceLine.stickToSuperviewEdges([.left, .right, .top])
        
        addSubview(compoundCurve)
        compoundCurve.stickToSuperviewEdges([.left, .right])
        compoundCurve.top(to: referenceLine)
        
        addSubview(closeCurve)
        closeCurve.stickToSuperviewEdges([.left, .right, .bottom])
        closeCurve.top(to: compoundCurve)
        
        width(250)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = UIColor.label.cgColor
    }
    
    private func updateOptions() {
        guard let handler = handler else { return }

        referenceLine.switchView.isOn = handler.referenceLine
        compoundCurve.switchView.isOn = handler.compoundCurve
        closeCurve.switchView.isOn = handler.closeCurve
    }
    
    func setState(_ state: OptionState, for option: CurveOptions) {
        switch option {
        case .referenceLine:
            referenceLine.setState(state)
        case .compoundCurve:
            compoundCurve.setState(state)
        case .closeCurve:
            closeCurve.setState(state)
        }
    }
    
    func setValue(_ value: Bool, for option: CurveOptions) {
        switch option {
        case .referenceLine:
            referenceLine.switchView.isOn = value
            handler?.referenceLine = value
        case .compoundCurve:
            compoundCurve.switchView.isOn = value
            handler?.compoundCurve = value
        case .closeCurve:
            closeCurve.switchView.isOn = value
            handler?.closeCurve = value
        }
    }
    
}
