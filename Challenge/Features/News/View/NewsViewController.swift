//
//  NewsViewController.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import UIKit

class NewsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<NewTitle, FormattedResponse>
    typealias SnapShot = NSDiffableDataSourceSnapshot<NewTitle, FormattedResponse>
    lazy var datasource = makeDataSource()
    
    private lazy var sharedView: NewsView = {
        let view = NewsView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    var presenter: NewsPresenter
    
    init(presenter: NewsPresenter = NewsPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.addSubview(sharedView)
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            sharedView.topAnchor.constraint(equalTo: view.topAnchor),
            sharedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sharedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sharedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        presenter.getNews()
    }
    
    func makeDataSource() -> DataSource {
        let datasource = DataSource(
            collectionView: sharedView.newsListCollectionView) {(collectionView: UICollectionView, index: IndexPath, itemIdentifier: FormattedResponse) in
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
}

extension NewsViewController: NewsProtocol {
    func goToDetails(information: FormattedResponse) {
        let vc = NewsDetailsViewController(information: information)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func showInformation(model: [NewTitle : [FormattedResponse]]) {
        var snapshot = SnapShot()
        model.forEach { section in
            snapshot.appendSections([section.key])
            section.value.forEach {rows in
                snapshot.appendItems(section.value, toSection: rows.indexer)
            }
        }
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func showModalError(message: String) {
        
    }
}

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectItemAt(indexPath: indexPath)
    }
}
