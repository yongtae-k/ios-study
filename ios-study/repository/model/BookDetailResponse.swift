//
//  BookDetaiilResponse.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import Foundation

struct BookDetailResponse: Codable {
    var error: String?
    var title: String?
    var subtitle: String?
    var authors: String?
    var publisher: String?
    
    var isbn10: String?
    var isbn13: String?
    var pages: String?
    var year: String?
    var rating: String?
    
    var desc: String?
    var price: String?
    var image: String?
    var url: String?
    var pdf: [String:String]?
}
