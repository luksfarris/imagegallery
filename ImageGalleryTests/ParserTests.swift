//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Lucas Farris on 7/26/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import XCTest
import FeedKit
@testable import ImageGallery

class ParserTests: XCTestCase {
    
    func testParsing() {
        do {
            let path = Bundle.main.path(forResource: "mock", ofType: "atom")
            let text = try String(contentsOfFile: path!)
            let mockData = text.data(using: .utf8)
            let result = FeedParser(data: mockData!)?.parse()
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.atomFeed?.entries?.count, 20)
            XCTAssertEqual(result?.atomFeed?.entries?[0].title, "...mud and tears...")
            XCTAssertEqual(result?.atomFeed?.entries?[0].links?[1].attributes?.href, "https://farm5.staticflickr.com/4297/35380437484_7f052d0175_b.jpg")
        } catch {
            XCTFail()
        }
    }
    
}
