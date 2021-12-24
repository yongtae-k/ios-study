//
//  ImageCache.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/22.
//

import UIKit

protocol ImageCacheable {
    func get(url: URL) -> UIImage?
    func set(url: URL, image: UIImage)
    func remove(url: URL)
    func removeAll()
}

enum ImageCache {
    
    class Memory {
        static let shared = Memory()
        private init() {
            setImageCacheCount(30)
        }
        private let imageCache = NSCache<NSString, UIImage>()
        
        func setImageCacheCount(_ count: Int) {
            imageCache.countLimit = count
        }
    }
    
    class Disk {
        static let shared = Disk()
        private let isDebugMode = true
        let fileManager = FileManager.default
        var cacheDirectory: URL?
        var countLimit = 100
        
        init() {
            do {
                var url = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                url.appendPathComponent("cache")
                cacheDirectory = url
            } catch let error {
                debugPrint(error.localizedDescription)
            }
            
            // 주기적으로 디스크 캐시 이미지 정리 (5초)
            DispatchQueue.global().async {
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {[weak self] _ in
                    if self?.isDebugMode ?? false { debugPrint("[DISK CACHE MANAGE TIMER START]") }
                    self?.checkLimit()
                }
                RunLoop.current.run()
            }
        }
        
        func setImageCacheCount(_ count: Int) {
            countLimit = count
        }
    }
    
}

/// 메모리 캐시 구현
extension ImageCache.Memory: ImageCacheable {
    
    func get(url: URL) -> UIImage? {
        return imageCache.object(forKey: url.lastPathComponent as NSString)
    }
    
    func set(url: URL, image: UIImage) {
        imageCache.setObject(image, forKey: url.lastPathComponent as NSString)
    }

    func remove(url: URL) {
        imageCache.removeObject(forKey: url.lastPathComponent as NSString)
    }
    
    func removeAll() {
        imageCache.removeAllObjects()
    }
    
}

/// 디스크 캐시 구현
extension ImageCache.Disk: ImageCacheable {
    
    func get(url: URL) -> UIImage? {
        guard let cacheDirectory = cacheDirectory else {
            return nil
        }
        var filePath = cacheDirectory
        filePath.appendPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else {
                return nil
            }
            guard let image = UIImage(data: imageData) else {
                return nil
            }
            return image
        }
        return nil
    }
    
    func set(url: URL, image: UIImage) {
        do {
            guard let cacheDirectory = cacheDirectory else {
                return
            }
            var filePath = cacheDirectory
            if !fileManager.fileExists(atPath: filePath.path) {
                try fileManager.createDirectory(at: filePath, withIntermediateDirectories: true, attributes: nil)
            }
            
            filePath.appendPathComponent(url.lastPathComponent)
            if !fileManager.fileExists(atPath: filePath.path) {
                fileManager.createFile(atPath: filePath.path,
                                       contents: image.pngData(),
                                       attributes: nil)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }

    func remove(url: URL) {
        do {
            guard let path = cacheDirectory else {
                return
            }
            var filePath = path
            filePath.appendPathComponent(url.lastPathComponent)
            if !fileManager.fileExists(atPath: filePath.path) {
                try fileManager.removeItem(at: filePath)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func removeAll() {
        do {
            guard let cacheDirectory = cacheDirectory else {
                return
            }
            let fileNames = try fileManager.contentsOfDirectory(atPath: cacheDirectory.absoluteString)
            for file in fileNames {
                let filePath = URL(fileURLWithPath: cacheDirectory.path).appendingPathComponent(file).absoluteURL
                try fileManager.removeItem(at: filePath)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func checkLimit() {
        do {
            guard let cacheDirectory = cacheDirectory else {
                return
            }
            var fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory,
                                                                includingPropertiesForKeys: [.contentModificationDateKey],
                                                                options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            if fileURLs.count > countLimit {
                try fileURLs.sort {
                    let date0 = try $0.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate ?? Date()
                    let date1 = try $1.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate ?? Date()
                    return date0.compare(date1) == .orderedAscending
                }
                let limoveSize = fileURLs.count - countLimit
                for fileUrl in fileURLs[0..<limoveSize] {
                    if isDebugMode { debugPrint("DISK CACHA REMOVE !! \(fileUrl.lastPathComponent)") }
                    try fileManager.removeItem(at: fileUrl)
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
}
