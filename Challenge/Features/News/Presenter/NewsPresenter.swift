//
//  NewsPresenter.swift
//  Challenge
//
//  Created by Fernando on 21/08/22.
//

import Foundation

protocol NewsProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func showInformation(model: [NewTitle: [FormattedResponse]])
    func showModalError(message: String)
    func goToDetails(information: FormattedResponse)
}

final class NewsPresenter {
    let service: NewService
    var newsOriginal: [Article] = []
    var formattedNews: [NewTitle: [FormattedResponse]]?
    var itemList: [[FormattedResponse]]?
    
    weak var view: NewsProtocol?
    
    init(service: NewService = NewService()) {
        self.service = service
    }
    
    func getNews() {
        view?.startLoading()
        service.getAllArticles { [weak self] news in
            guard let _self = self else {
                self?.view?.showModalError(message: "Desculpe, ocorreu um erro! Tente mais tarde")
                return
            }
            
            _self.view?.stopLoading()
            
            do {
                _self.newsOriginal = try news.get()
                _self.formattedNews = _self.formattedArticles(articles: _self.newsOriginal)
                _self.view?.showInformation(model: _self.formattedNews!)
                _self.makeList()
            } catch {
                _self.view?.showModalError(message: "Não foi possível exibir")
            }
        }
    }
    
    private func formattedArticles(articles: [Article]) -> [NewTitle: [FormattedResponse]] {
        var list: [FormattedResponse] = []
        articles.forEach { article in
            article.articles.forEach{ item in
                list.append(FormattedResponse(imageName: item.urlToImage ?? URL(string: "https://http.cat/404")!,
                                              authors: item.author ?? "Não Possui",
                                              title: item.title ?? "Não Possui",
                                              description: item.description ?? "Não Possui",
                                              publishedAt: item.publishedAt ?? "Não Possui",
                                              content: item.content ?? "",
                                              indexer: NewTitle(title: article.howsCalls!))
                )
            }
        }
        
        let dict = Dictionary(grouping: list) {$0.indexer}
        return dict
    }
    
    func selectItemAt(indexPath: IndexPath) {
        let selecteItem = itemList![indexPath.section][indexPath.item]
        view?.goToDetails(information: selecteItem)
    }
    
    private func makeList() {
        var resultList: [[FormattedResponse]] = []
        formattedNews?.keys.forEach { key in
            var arr: [FormattedResponse] = []
            formattedNews![key]?.forEach { item in
                arr.append(item)
            }
            resultList.append(arr)
        }
        itemList = resultList
    }
}
