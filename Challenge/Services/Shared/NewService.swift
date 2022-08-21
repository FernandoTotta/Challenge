//
//  NewService.swift
//  Challenge
//
//  Created by Fernando on 19/08/22.
//

import Foundation

class NewService {
    static let shared = NewService()
    
    private let urlSession = URLSession.shared
    let baseUrl = URL(string: "https://newsapi.org/v2")!
    private let apiKey = "d30e5673a7cf488d8afcd30a9f1aa684"
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
     }()
    
    enum EndPoint: String {
        case everythings = "everything"
    }
    
    enum Topics: String {
        case apple = "apple"
        case tesla = "tesla"
        case microsoft = "Microsoft"
        case google = "Google"
        case meta = "Meta"
    }
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndPoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    func fetchResources<T: Decodable>(
        url: URL,
        query: Topics,
        completion: @escaping (_ topics: Topics, (Result<T ,APIServiceError>)) -> Void
    ) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(query,.failure(.invalidEndPoint))
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "q", value: query.rawValue),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        urlComponents.queryItems = queryItems
        guard urlComponents.url != nil else {
            completion(query,.failure(.invalidEndPoint))
            return
        }
        
        urlSession.dataTask(with: urlComponents.url!) { [weak self] data, response, error in
            
            guard let _self = self else {
                completion(query,.failure(.apiError))
                return
            }
            
            if error != nil {
                completion(query,.failure(APIServiceError.apiError))
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(query,.failure(.invalidResponse))
                return
            }
            
            if let data = data {
                do {
                    let values = try _self.jsonDecoder.decode(T.self, from: data)
                    completion(query,.success(values))
                } catch {
                    completion(query,.failure(.decodeError))
                }
            }
           
        }.resume()
    }
    
    private func fetchNewsOfApple(from endpoint: EndPoint = .everythings, result: @escaping (_ topics: Topics, (Result<Article, APIServiceError>)) -> Void) {
        let movieURL = baseUrl.appendingPathComponent(endpoint.rawValue)
        fetchResources(url: movieURL, query: .apple, completion: result)
    }
    
    private func fetchNewsOfTesla(from endpoint: EndPoint = .everythings, result: @escaping (_ topics: Topics, (Result<Article, APIServiceError>)) -> Void) {
        let movieURL = baseUrl.appendingPathComponent(endpoint.rawValue)
        fetchResources(url: movieURL, query: .tesla, completion: result)
    }
    
    private func fetchNewsOfMicrosoft(from endpoint: EndPoint = .everythings, result: @escaping (_ topics: Topics, (Result<Article, APIServiceError>)) -> Void) {
        let movieURL = baseUrl.appendingPathComponent(endpoint.rawValue)
        fetchResources(url: movieURL, query: .microsoft, completion: result)
    }
    
    private func fetchNewsOfGoogle(from endpoint: EndPoint = .everythings, result: @escaping (_ topics: Topics, (Result<Article, APIServiceError>)) -> Void) {
        let movieURL = baseUrl.appendingPathComponent(endpoint.rawValue)
        fetchResources(url: movieURL, query: .google, completion: result)
    }
    
    public func getAllArticles(completion: @escaping (Result<[Article], APIServiceError>) -> Void) {
        var resultArticle = [Article]()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchNewsOfApple { query, result  in
            dispatchGroup.leave()
            switch result {
            case .success(let article):
                resultArticle.append(.init(articles: article.articles, howsCalls: query.rawValue))
            case .failure(let err) :
                completion(.failure(err))
            }
        }
        
        dispatchGroup.enter()
        fetchNewsOfTesla {query, result in
            dispatchGroup.leave()
            switch result {
            case .success(let article):
                resultArticle.append(.init(articles: article.articles, howsCalls: query.rawValue))
            case .failure(let err) :
                completion(.failure(err))
            }
        }
        
        dispatchGroup.enter()
        fetchNewsOfGoogle { query, result in
            dispatchGroup.leave()
            switch result {
            case .success(let article):
                resultArticle.append(.init(articles: article.articles, howsCalls: query.rawValue))
            case .failure(let err) :
                completion(.failure(err))
            }
        }
        
        dispatchGroup.enter()
        fetchNewsOfMicrosoft {query, result in
            dispatchGroup.leave()
            switch result {
            case .success(let article):
                resultArticle.append(.init(articles: article.articles, howsCalls: query.rawValue))
            case .failure(let err) :
                completion(.failure(err))
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !resultArticle.isEmpty {
                completion(.success(resultArticle))
            }
        }
    }
}
