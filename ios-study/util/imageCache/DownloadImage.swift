//
//  DownloadImage.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/22.
//

import Foundation
import UIKit

class DownloadImage {
    
    static let shared = DownloadImage()
    private let isDebugMode = true
    private init() {}
    
    func getImage(url: URL, completion: @escaping (Result<UIImage, Error>?)->Void) {
        if let image = ImageCache.Memory.shared.get(url: url) {
            if isDebugMode { debugPrint("MEMORY CACHE HIT!! :: " + url.absoluteString) }
            completion(.success(image))
            
        } else if let image = ImageCache.Disk.shared.get(url: url) {
            if isDebugMode { debugPrint("Disk CACHE HIT!! :: " + url.absoluteString) }
            ImageCache.Memory.shared.set(url: url, image: image)
            completion(.success(image))
            
        } else {
            if isDebugMode { debugPrint(url.absoluteString) }
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
                            ImageCache.Memory.shared.set(url: url, image: image)
                            ImageCache.Disk.shared.set(url: url, image: image)
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
    
}
