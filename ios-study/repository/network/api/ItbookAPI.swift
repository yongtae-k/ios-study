//
//  ItbookAPI.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import Foundation

/// URLSession 사용
class ItbookAPIImpl : ItbookAPIDataSource {
    static let shared = ItbookAPIImpl()
    
    /// 책 검색 API
    /// https://api.itbook.store/1.0/search/{query}/{page}
    /// ex) https://api.itbook.store/1.0/search/mongodb/1
    func search(query: String, page: Int, completion: @escaping (Result<BookListResponse, Error>?)->Void) {
        if let url = ItbookAPIURL.search(query: query, page: page).getUrl() {
            debugPrint(url.absoluteString)
            DispatchQueue.global().async {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil,
                          let response = response as? HTTPURLResponse else {
                              completion(.failure(error ?? APIError.responseAPIError))
                              return
                          }
                    switch response.statusCode {
                    case (200..<400):
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(BookListResponse.self, from: data)
                            completion(.success(result))
                        } catch let error {
                            completion(.failure(error))
                        }
                    case 404:
                        completion(.failure(APIError.pageNotFound))
                    default:
                        completion(.failure(APIError.responseAPIError))
                    }
                }
                task.resume()
            }
        }
    }
    
    /// 책 상세 API
    /// https://api.itbook.store/1.0/books/{isbn13}
    /// https://api.itbook.store/1.0/books/9781617294136
    func bookDetail(isbn13: String, completion: @escaping (Result<BookDetailResponse, Error>?)->Void) {
        if let url = ItbookAPIURL.bookDetail(isbn13: isbn13).getUrl() {
            debugPrint(url.absoluteString)
            DispatchQueue.global().async {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil,
                          let response = response as? HTTPURLResponse else {
                              completion(.failure(error ?? APIError.responseAPIError))
                              return
                          }
                    
                    switch response.statusCode {
                    case (200..<400):
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(BookDetailResponse.self, from: data)
                            completion(.success(result))
                        } catch let error {
                            completion(.failure(error))
                        }
                    case 404:
                        completion(.failure(APIError.pageNotFound))
                    default:
                        completion(.failure(APIError.responseAPIError))
                    }
                }
                task.resume()
            }
        }
    }
    
}
