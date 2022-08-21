//
//  FormattedResponse.swift
//  Challenge
//
//  Created by Fernando on 21/08/22.
//

import Foundation

struct FormattedResponse: Hashable{
    var imageName: URL
    var authors: String
    var title: String
    var description: String
    var publishedAt: String
    var content: String
    var indexer: NewTitle
}

struct NewTitle: Hashable {
    var title: String
}
