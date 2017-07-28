//
//  SnapshotTests.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/28/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import Foundation
import FBSnapshotTestCase
import FeedKit

@testable import ImageGallery

class SnapshotTests : FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    private func loadItems() -> [AtomFeedEntry]? {
        do {
            let path = Bundle.main.path(forResource: "mock", ofType: "atom")
            let text = try String(contentsOfFile: path!)
            let mockData = text.data(using: .utf8)
            let result = FeedParser(data: mockData!)?.parse()
            return result?.atomFeed?.entries
        } catch {
            XCTFail()
        }
        return nil
    }
    
    func testPhotoPreview() {
        let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        
        _ = pvc.view
        pvc.imageView.image = #imageLiteral(resourceName: "cat")
        
        let expect = expectation(description: "wait for images to load")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.FBSnapshotVerifyLayer(pvc.view.layer)
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 5) { error in
            
        }
        
    }
    
    func testLoadedGallery() {
        let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let gvc = nvc.viewControllers[0] as! GalleryViewController
        _ = gvc.view
        gvc.entries = loadItems()!
        
        let expect = expectation(description: "wait for images to load")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.FBSnapshotVerifyLayer(gvc.view.layer)
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 2) { error in
            
        }
    }
    
}
