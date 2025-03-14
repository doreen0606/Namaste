//
//  ViewController.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/2/23.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    private let event = PassthroughSubject<ViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 80, weight: .bold)
        lbl.textColor = .secondaryLabel
        lbl.text = "Namaste"
        return lbl
    }()
    
    
    private let welcomeView: UIImageView = {
        let imgv = UIImageView()
        imgv.clipsToBounds = true
        imgv.layer.cornerRadius = 20
        imgv.image = UIImage(systemName: "moon.stars.fill")?.withRenderingMode(.alwaysTemplate)
        imgv.tintColor = .systemGray
        return imgv
    }()
    
    private let tabView = TabView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / 4),
                heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.edgeSpacing = .init(leading: nil, top: nil, trailing: .fixed(8), bottom: nil)

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 10
            section.contentInsets.leading = 20
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .continuous
            
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
    
    /// default focus position for page
    override var preferredFocusEnvironments: [any UIFocusEnvironment] {
        if let firstItem = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) {
            return [firstItem]
        } else {
            return super.preferredFocusEnvironments
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private let viewModel: ViewModel
    
    private func setupBinding() {
        let output = viewModel.binding(event.eraseToAnyPublisher())
        output
            .reloadPage
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                collectionView.reloadData()
                tabView.rebuildTabStack(with: viewModel.tabs)
            }
            .store(in: &cancellables)
        event.send(.viewDidLoad)
    }
    
    private func setupUI() {
        view.addSubviews(welcomeView, welcomeLabel,
                         tabView, collectionView)
        NSLayoutConstraint.activate([
            welcomeLabel.bottomAnchor.constraint(equalTo: welcomeView.topAnchor, constant: -10),
            welcomeLabel.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            welcomeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            welcomeView.widthAnchor.constraint(equalToConstant: 500),
            welcomeView.heightAnchor.constraint(equalToConstant: 500),
            tabView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tabView.heightAnchor.constraint(equalToConstant: 60),
            collectionView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: welcomeView.trailingAnchor),
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
        cell.configure(with: item, itemIndex: indexPath.item)
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

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = -1
    }
}
