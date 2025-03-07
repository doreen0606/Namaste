//
//  ViewController.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/2/23.
//

import UIKit
import Combine

/*
 TODO:
 data model
 image data
 focus effect
 */

final class ViewController: UIViewController {

    private let event = PassthroughSubject<ViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 80, weight: .bold)
        lbl.textColor = .secondaryLabel
        lbl.text = "Namaste!"
        return lbl
    }()
    
    
    private let welcomeView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let tabStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.spacing = 10
        stv.backgroundColor = .systemGray.withAlphaComponent(0.2)
        stv.layer.cornerRadius = 10
        stv.clipsToBounds = true
        return stv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / 4),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 8
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CollectionViewCell.self,
                    forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        cv.register(CollectionReusableHeader.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: CollectionReusableHeader.reuseId)
        return cv
    }()
    
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private func setupBinding() {
        let output = viewModel.binding(event.eraseToAnyPublisher())
        output
            .reloadPage
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.rebuildTabStack()
            }
            .store(in: &cancellables)
        event.send(.viewDidLoad)
    }
    
    private func rebuildTabStack() {
        tabStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.tabs.forEach {
            let btn = UIButton()
            btn.titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
            btn.setTitle($0.title, for: .normal)
            btn.setTitleColor(.secondaryLabel, for: .normal)
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 8
            btn.backgroundColor = .systemGray.withAlphaComponent(0.5)
            btn.widthAnchor.constraint(equalToConstant: 150).isActive = true
            tabStackView.addArrangedSubview(btn)
        }
    }
    
    private func setupUI() {
        view.addSubviews(welcomeView, welcomeLabel,
                         tabStackView, collectionView)
        NSLayoutConstraint.activate([
            welcomeLabel.bottomAnchor.constraint(equalTo: welcomeView.topAnchor, constant: -10),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeView.widthAnchor.constraint(equalToConstant: 500),
            welcomeView.heightAnchor.constraint(equalToConstant: 500),
            tabStackView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            tabStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            tabStackView.heightAnchor.constraint(equalToConstant: 60),
            collectionView.topAnchor.constraint(equalTo: tabStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: welcomeView.trailingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.currentTab?.curations.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.currentTab?.curations[section].items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.currentTab?.curations[indexPath.section].items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionReusableHeader.reuseId,
            for: indexPath)
        if let header = header as? CollectionReusableHeader {
            let title = viewModel.currentTab?.curations[indexPath.section].title
            header.configure(with: title)
        }
        return header
    }
}

extension ViewController: UICollectionViewDelegate {}
