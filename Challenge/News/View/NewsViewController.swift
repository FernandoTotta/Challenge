//
//  NewsViewController.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate {

    typealias DataSource = UICollectionViewDiffableDataSource<NewTitle, NewReponse>
    typealias SnapShot = NSDiffableDataSourceSnapshot<NewTitle, NewReponse>
    lazy var datasource = makeDataSource()
    
    private lazy var sharedView: NewsView = {
        let view = NewsView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sharedView)
        NSLayoutConstraint.activate([
            sharedView.topAnchor.constraint(equalTo: view.topAnchor),
            sharedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sharedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sharedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
        testUICollection()
    }
    
    func makeDataSource() -> DataSource {
        let datasource = DataSource(
            collectionView: sharedView.newsListCollectionView) {(collectionView: UICollectionView, index: IndexPath, itemIdentifier: NewReponse) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellCollectionViewCell.identifier, for: index) as? CellCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setupCell(information: itemIdentifier)
                return cell
            }
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let section = datasource.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView
            view?.setupHeader(title: section)
            return view
        }
        return datasource
    }

    

    
    func getAntherMethod() -> [Title: [Informations]] {
        var informationArr: [Informations] = []
        let arr = [AllInformation(imageName: "square.and.arrow.down", authors: "Mac", title: "Pq mac e melhor que windows?", description: "PQ sim", indexer: "All articles mentioning Apple"),
                    AllInformation(imageName: "bell", authors: "Fernando", title: "Elon Musk é ", description: "Genio?", indexer: "All articles about Tesla")]
        
        arr.forEach { information in
            let information = Informations(
                imageName: information.imageName,
                authors: information.authors,
                title: information.title,
                description: information.description,
                indexer: Title(title: information.indexer)
            )
            
            informationArr.append(information)
        }
        let dict = Dictionary(grouping: informationArr) {$0.indexer}
        return dict
    }
}
