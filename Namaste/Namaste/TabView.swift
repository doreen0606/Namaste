//
//  TabView.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/14.
//

import UIKit

final class TabView: UIView {

    /// default focus position for tab view
    override var preferredFocusEnvironments: [any UIFocusEnvironment] {
        if let firstItem = stackView.arrangedSubviews.first {
            return [firstItem]
        } else {
            return super.preferredFocusEnvironments
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebuildTabStack(with tabs: [TabModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tabs.forEach {
            let btn = TabItem($0.title)
            btn.widthAnchor.constraint(equalToConstant: 150).isActive = true
            stackView.addArrangedSubview(btn)
        }
    }
    
    private let stackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.spacing = 10
        stv.backgroundColor = .systemGray.withAlphaComponent(0.2)
        stv.layer.cornerRadius = 10
        stv.clipsToBounds = true
        return stv
    }()
    
    private func setupUI() {
        backgroundColor = .clear
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        let tabFocusGuide = UIFocusGuide()
        addLayoutGuide(tabFocusGuide)
        NSLayoutConstraint.activate([
            tabFocusGuide.topAnchor.constraint(equalTo: topAnchor),
            tabFocusGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabFocusGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabFocusGuide.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

final class TabItem: UIButton {
    
    init(_ title: String?) {
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        setTitle(title, for: .normal)
        setTitleColor(.secondaryLabel, for: .normal)
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .systemGray.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
            self.backgroundColor = .systemGray.withAlphaComponent(self.isFocused ? 1 : 0.5)
        }
    }
}
