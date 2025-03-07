//
//  UICollectionViewCell.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/7.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let reuseId: String = String(describing: CollectionViewCell.self)
    
    func configure(with item: ItemModel?) {
        titleLabel.text = item?.title
        imageView.image = item?.image
    }
    
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
    
    private func setupUI() {
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
