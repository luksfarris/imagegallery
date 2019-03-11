//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Lucas Farris on 7/26/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import XCTest
@testable import ImageGallery

class ParserTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        MockRequestClient.setupMock()
    }
    
    func testBaseRequest() {
        let components = FlickrCommunication.requestComponents()
        XCTAssert((components?.queryItems?.contains(where: { item -> Bool in
            item.name == "api_key"
        })) ?? false)
    }
    
    func testCommunication() {
        let mockData = MockRequestClient.loadMockData()
        let result = FlickrCommunication.parseApiResponse(mockData)
        XCTAssertNotNil(result)
        let json = String(data: result, encoding: .utf8)
        XCTAssertNotNil(json)
        XCTAssert(json!.count > 0)
    }
    
    func testParsing() {
        let mockData = MockRequestClient.loadMockData()
        let result = FlickrCommunication.parseApiResponse(mockData)
        let photos = GalleryViewModel.parseJson(data: result)
        XCTAssert(photos.count == 2)
        XCTAssert(photos[0].identifier == "123")
    }
    
    func testSearch() {
        let observable = GalleryViewModel.photoSearchObservable("")
        observable.subscribe(onNext: { photos in
            XCTAssert(photos.count == 2)
            XCTAssert(photos[0].identifier == "123")
        }, onError: { _ in
            XCTFail()
        }).dispose()
    }
    
    func testSearchRequest() {
        let request = PhotoSeachRequest.buildSearchRequest("tag")
        XCTAssert(request!.url!.absoluteString.contains("text=tag"))
    }
    
}
