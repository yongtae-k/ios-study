//
//  BookListItem.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import Foundation

struct BookListResponse: Codable {
    let total: String?
    let page: String?
    let books: [BookListItem]?
}

struct BookListItem: Codable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
}
