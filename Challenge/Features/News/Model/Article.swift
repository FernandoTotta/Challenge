//
//  Article.swift
//  Challenge
//
//  Created by Fernando on 19/08/22.
//

import Foundation

struct Article: Decodable {
    var articles: [ResponseAPI]
    var howsCalls: String?
}

struct ResponseAPI: Decodable {
    var urlToImage: URL?
    var author: String?
    var title: String?
    var description: String?
    var publishedAt: String?
    var content: String?
}
