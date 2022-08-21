//
//  NewsViewController.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate {
    var listOfArtickes: [NewTitle: [NewReponse]]?
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
        let url = NewService.shared.baseUrl
        NewService.shared.getAllArticles { result in
            switch result {
            case .success(let test):
                self.listOfArtickes = self.formattedArticles(articles: test)
            case .failure(let err):
                print(err)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [self] in
            testUI()
        }
       
    }
    
    func formattedArticles(articles: [Article]) -> [NewTitle: [NewReponse]] {
        var list: [NewReponse] = []
        articles.forEach { article in
            article.articles.forEach{ item in
                list.append(NewReponse(imageName: item.urlToImage!,
                                       authors: item.author ?? "",
                                       title: item.title!,
                                       description: item.description!,
                                       indexer: NewTitle(title: article.howsCalls!))
                )
            }
        }
        
        let dict = Dictionary(grouping: list) {$0.indexer}
        return dict
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
    
    func testUI() {
        var snapshot = SnapShot()
        self.listOfArtickes!.forEach { section in
            snapshot.appendSections([section.key])
            section.value.forEach {rows in
                snapshot.appendItems(section.value, toSection: rows.indexer)
            }
        }
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

struct NewReponse: Hashable{
    var imageName: URL
    var authors: String
    var title: String
    var description: String
    var indexer: NewTitle
}

struct NewTitle: Hashable {
    var title: String
}
