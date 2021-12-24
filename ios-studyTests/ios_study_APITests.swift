//
//  ios_studyTests.swift
//  ios-studyTests
//
//  Created by 김용태 on 2021/12/21.
//

import XCTest
@testable import ios_study

class ios_study_APITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetSearchAPIAddress() throws {
        let query = "mongodb"
        let page = 1
        if let url = ItbookAPIURL.search(query: query, page: page).getUrl() {
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                XCTFail()
                return
            }
            XCTAssertEqual(url.absoluteString, API_DOMAIN + "/1.0/search/\(encodedQuery)/\(page)")
        } else {
            XCTFail()
        }
    }
    
    func testGetBookDetailAPIAddress() throws {
        let isbn13 = "9781617294136"
        if let url = ItbookAPIURL.bookDetail(isbn13: isbn13).getUrl() {
            guard let encodedIsbn13 = isbn13.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                XCTFail()
                return
            }
            XCTAssertEqual(url.absoluteString, API_DOMAIN + "/1.0/books/\(encodedIsbn13)")
        } else {
            XCTFail()
        }
    }
    
    func testRequestSearchBookAPI() throws {
        let query = "mongodb"
        let page = 1
        
        let promise = expectation(description: "network request timeout")
        var bookListResponse : BookListResponse?
        
        ItbookAPIImpl.shared.search(query: query, page: page) { result in
            switch result {
            case .success(let item):
                bookListResponse = item
            case .failure(let error):
                XCTFail("result is failure : " + error.localizedDescription)
            case .none:
                XCTFail("result case is none ")
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(bookListResponse)
        XCTAssertGreaterThanOrEqual(bookListResponse?.total ?? -1, 0)
    }

    func testRequestBookDetailAPI() throws {
        let isbn13 = "9781617294136"
        
        let promise = expectation(description: "network request timeout")
        var response : BookDetailResponse?
        
        ItbookAPIImpl.shared.bookDetail(isbn13: isbn13) { result in
            switch result {
            case .success(let item):
                response = item
            case .failure(let error):
                XCTFail("result is failure : " + error.localizedDescription)
            case .none:
                XCTFail("result case is none ")
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(response)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
