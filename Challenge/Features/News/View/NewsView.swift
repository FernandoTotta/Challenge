//
//  NewsView.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import UIKit

class NewsView: UIView {
    // MARK: - Collection view property
    
    lazy var newsListCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collection.register(CellCollectionViewCell.self, forCellWithReuseIdentifier: CellCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(186),
            heightDimension: .absolute(250)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(58)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: UICollectionViewDelegate) {
        self.init(frame: .zero)
        self.newsListCollectionView.delegate = delegate
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsView: CodeView {
    //MARK: - Constraints setup
    
    func setupComponents() {
        addSubview(newsListCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            newsListCollectionView.topAnchor.constraint(equalTo: topAnchor),
            newsListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsListCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
