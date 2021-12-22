//
//  BookListItem.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import Foundation

struct BookListResponse: Codable {
    let total: Int?
    var page: Int?
    var books: [BookListItem]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = Int(try (container.decode(String?.self, forKey: .total) ?? "0"))
        page = Int(try container.decode(String?.self, forKey: .page) ?? "0")
        books = try container.decode([BookListItem]?.self, forKey: .books)
    }
}

struct BookListItem: Codable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
}
