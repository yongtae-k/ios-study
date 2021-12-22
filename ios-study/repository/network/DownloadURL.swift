//
//  DownloadImage.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/22.
//

import Foundation
import UIKit

class DownloadURL {
    
    static let shared = DownloadURL()
    
    private init() {}
    
    func getImage(url: URL, completion: @escaping (Result<UIImage, Error>?)->Void) {
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
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    } else {
                        completion(.failure(DownloadImageError.responseImageDataError))
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
