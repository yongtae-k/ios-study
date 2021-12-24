//
//  ios_stydy_imageCacheTests.swift
//  ios-studyTests
//
//  Created by 김용태 on 2021/12/23.
//

import XCTest
@testable import ios_study

class ios_stydy_imageCacheTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleMemoryCache() throws {
        let imageURLs = [URL(string: "https://itbook.store/img/books/9781484206485.png")!,
                         URL(string: "https://itbook.store/img/books/9781484211830.png")!]
        
        let promise = expectation(description: "network request timeout")
        
        ImageCache.Memory.shared.removeAll()
        ImageCache.Memory.shared.setImageCacheCount(1)

        imageURLs.forEach { imageURL in
            DownloadImage.shared.getImage(url: imageURL) { result in
                switch result {
                case .success(let item):
                    print(item)
                case .failure(let error):
                    XCTFail("result is failure : " + error.localizedDescription)
                case .none:
                    XCTFail("result case is none ")
                }
                if imageURL == imageURLs.last {
                    promise.fulfill()
                }
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertNil(ImageCache.Memory.shared.get(url: imageURLs[0]))
        XCTAssertNotNil(ImageCache.Memory.shared.get(url: imageURLs[1]))
        
    }

    func testSimpleDiskCache() throws {
        let imageURLs = [URL(string: "https://itbook.store/img/books/9781484206485.png")!,
                         URL(string: "https://itbook.store/img/books/9781484211830.png")!]
        
        let promise = expectation(description: "network request timeout")
        ImageCache.Disk.shared.setImageCacheCount(1)
        
        imageURLs.forEach { imageURL in
            DownloadImage.shared.getImage(url: imageURL) { result in
                switch result {
                case .success(let item):
                    ImageCache.Disk.shared.set(url: imageURL, image: item)
                    print(item)
                case .failure(let error):
                    XCTFail("result is failure : " + error.localizedDescription)
                case .none:
                    XCTFail("result case is none ")
                }
                if imageURL == imageURLs.last {
                    ImageCache.Disk.shared.checkLimit()
                    promise.fulfill()

                }
            }
        }
        
        wait(for: [promise], timeout: 5)
        XCTAssertNil(ImageCache.Disk.shared.get(url: imageURLs[0]))
        XCTAssertNotNil(ImageCache.Disk.shared.get(url: imageURLs[1]))
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
