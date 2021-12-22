//
//  NetworkConfig.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import Foundation

let API_DOMAIN =  "https://api.itbook.store"

enum ItbookAPIURL {
    case search(query: String, page: Int)
    case bookDetail(isbn13: String)
    
    func getUrl() -> URL? {
        switch self {
        case .search(let query, let page):
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                return nil
            }
            return URL(string: API_DOMAIN + "/1.0/search/{query}/{page}"
                        .replacingOccurrences(of: "{query}", with: encodedQuery)
                        .replacingOccurrences(of: "{page}", with: String(page)))
        case .bookDetail(let isbn13):
            guard let encodedIsbn13 = isbn13.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                return nil
            }
            return URL(string: API_DOMAIN + "/1.0/books/{isbn13}"
                        .replacingOccurrences(of: "{isbn13}", with: encodedIsbn13))
        }
    }
}

enum APIError: Error {
    case responseAPIError
    case pageNotFound
}

enum DownloadImageError: Error {
    case responseImageDataError
}

protocol ItbookAPIDataSource {
    func search(query: String, page: Int, completion: @escaping (Result<BookListResponse, Error>?)->Void)
    func bookDetail(isbn13: String, completion: @escaping (Result<BookDetailResponse, Error>?)->Void)
}
