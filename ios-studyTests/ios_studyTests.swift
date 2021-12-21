//
//  ios_studyTests.swift
//  ios-studyTests
//
//  Created by 김용태 on 2021/12/21.
//

import XCTest
@testable import ios_study

class ios_studyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetSearchAPIAddress() throws {
        let query = "한글검색"
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
        let isbn13 = "abc"
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
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let promise = expectation(description: "Completion handler invoked")
        var bookListResponse : BookListResponse?
        
        ItbookAPIImpl.shared.search(query: "mongodb", page: 1) { result in
            switch result {
            case .success(let item):
                bookListResponse = item
                XCTAssertEqual(item.total, "71")
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
                break
            case .none:
                XCTFail("fail")
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(bookListResponse?.total, "71")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
