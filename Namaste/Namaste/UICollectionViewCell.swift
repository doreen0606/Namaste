//
//  UICollectionViewCell.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/7.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let reuseId: String = String(describing: CollectionViewCell.self)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations {
            self.applyFocusEffectIfNeeded()
        }
    }
        
    func configure(with item: ItemModel?, itemIndex: Int) {
        titleLabel.text = item?.title
        imageView.image = item?.image
        self.itemIndex = itemIndex
    }
    
    private var itemIndex: Int?

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .tertiaryLabel
        lbl.font = .systemFont(ofSize: 40, weight: .bold)
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        return imgv
    }()
    
    private func applyFocusEffectIfNeeded() {
        transform = isFocused ? CGAffineTransform(scaleX: 1.15, y: 1.15) : .identity
        layer.zPosition = isFocused ? 1 : 0
        contentView.backgroundColor = .systemGray.withAlphaComponent(isFocused ? 1 : 0.2)
        if itemIndex == 0, isFocused {
            // slightly shift to left
            anchorPoint = .init(x: 0.45, y: 0.5)
        } else {
            // center (default)
            anchorPoint = .init(x: 0.5, y: 0.5)
        }
    }
    
    private func setupUI() {
        isUserInteractionEnabled = true
        contentView.addSubviews(titleLabel, imageView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .systemGray.withAlphaComponent(0.2)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

final class CollectionReusableHeader: UICollectionReusableView {
    
    static let reuseId: String = String(describing: CollectionReusableHeader.self)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String?) {
        titleLabel.text = title
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .tertiaryLabel
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        return lbl
    }()
    
    private func setupUI() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        ])
    }
}
