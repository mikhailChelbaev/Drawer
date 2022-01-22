//
//  Object3DOptionsView.swift
//  Drawer
//
//  Created by Mikhail on 07.12.2021.
//

import UIKit

enum Object3DOptions {
    
    enum Projection: String, CaseIterable {
        case parallel
        case perspectiveClose = "perspective (close)"
        case perspectiveDistant = "perspective (distant)"
    }
    
    enum ScaleAxis: String, CaseIterable {
        case x = "x axis"
        case y = "y axis"
        case z = "z axis"
        case object
    }
    
    enum Deceleration: String, CaseIterable {
        case yes
        case no
    }
    
    enum ShowEdges: String, CaseIterable {
        case yes
        case no
    }
    
}

protocol Object3DOptionsProtocol: UIView {
    typealias Completion<T> = (T) -> Void
    typealias ProjectionCompletion = Completion<Object3DOptions.Projection>
    typealias ScaleAxisCompletion = Completion<Object3DOptions.ScaleAxis>
    typealias DecelerationCompletion = Completion<Object3DOptions.Deceleration>
    typealias ShowEdgesCompletion = Completion<Object3DOptions.ShowEdges>
    
    var presenter: UIViewController? { set get }
    
    var projection: Object3DOptions.Projection { get }
    var scaleAxis: Object3DOptions.ScaleAxis { get }
    var deceleration: Object3DOptions.Deceleration { get }
    var edgesState: Object3DOptions.ShowEdges { get }
    
    var projectionDidChange: ProjectionCompletion? { set get }
    var scaleAxisDidChange: ScaleAxisCompletion? { set get }
    var edgesStateDidChange: ShowEdgesCompletion? { set get }
}

final class Object3DOptionsView: UIView, Object3DOptionsProtocol {
    
    weak var presenter: UIViewController? 
    
    var projection: Object3DOptions.Projection = .parallel
    var scaleAxis: Object3DOptions.ScaleAxis = .object
    var deceleration: Object3DOptions.Deceleration = .no
    var edgesState: Object3DOptions.ShowEdges = .no
    
    var projectionDidChange: ProjectionCompletion?
    var scaleAxisDidChange: ScaleAxisCompletion?
    var edgesStateDidChange: ShowEdgesCompletion?
    
    private var projectionView: Object3DOptionItemView!
    private var scaleAxisView: Object3DOptionItemView!
    private var decelerationView: Object3DOptionItemView!
    private var edgesStateView: Object3DOptionItemView!
    
    init() {
        super.init(frame: .zero)
        setUpViews()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        projectionView = .init(title: "Projection: \(projection.rawValue)") { [weak self] in
            let actions: [UIAlertAction] = Object3DOptions.Projection.allCases.map({ projection in
                    .init(title: projection.rawValue, style: .default) { _ in
                        self?.projection = projection
                        self?.projectionDidChange?(projection)
                        self?.projectionView.setTitle("Projection: \(projection.rawValue)")
                    }
            })
            self?.showAlert(actions: actions)
        }
    
        scaleAxisView = .init(title: "Scale: \(scaleAxis.rawValue)") { [weak self] in
            let actions: [UIAlertAction] = Object3DOptions.ScaleAxis.allCases.map({ scaleAxis in
                    .init(title: scaleAxis.rawValue, style: .default) { [weak self] _ in
                        self?.scaleAxis = scaleAxis
                        self?.scaleAxisDidChange?(scaleAxis)
                        self?.scaleAxisView.setTitle("Scale: \(scaleAxis.rawValue)")
                    }
            })
            self?.showAlert(actions: actions)
        }
        
        decelerationView = .init(title: "Apply deceleration: \(deceleration.rawValue)") { [weak self] in
            let actions: [UIAlertAction] = Object3DOptions.Deceleration.allCases.map({ deceleration in
                    .init(title: deceleration.rawValue, style: .default) { [weak self] _ in
                        self?.deceleration = deceleration
                        self?.decelerationView.setTitle("Apply deceleration: \(deceleration.rawValue)")
                    }
            })
            self?.showAlert(actions: actions)
        }
        
        edgesStateView = .init(title: "Show edges: \(deceleration.rawValue)") { [weak self] in
            let actions: [UIAlertAction] = Object3DOptions.ShowEdges.allCases.map({ edgesState in
                    .init(title: edgesState.rawValue, style: .default) { [weak self] _ in
                        self?.edgesState = edgesState
                        self?.edgesStateDidChange?(edgesState)
                        self?.edgesStateView.setTitle("Apply deceleration: \(edgesState.rawValue)")
                    }
            })
            self?.showAlert(actions: actions)
        }
    }
    
    private func showAlert(actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach({ alertController.addAction($0) })
        alertController.popoverPresentationController?.sourceView = self
        presenter?.present(alertController, animated: true, completion: nil)
    }
    
    private func commonInit() {
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.16
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowRadius = 16
        
        backgroundColor = .systemBackground
        
        addSubview(projectionView)
        projectionView.stickToSuperviewEdges([.left, .right, .top])
        projectionView.layer.cornerRadius = 12
        projectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addSubview(scaleAxisView)
        scaleAxisView.stickToSuperviewEdges([.left, .right])
        scaleAxisView.top(to: projectionView)
        
        addSubview(decelerationView)
        decelerationView.stickToSuperviewEdges([.left, .right])
        decelerationView.top(to: scaleAxisView)
        
        addSubview(edgesStateView)
        edgesStateView.stickToSuperviewEdges([.left, .right, .bottom])
        edgesStateView.top(to: decelerationView)
        edgesStateView.layer.cornerRadius = 12
        edgesStateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
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
    
}

