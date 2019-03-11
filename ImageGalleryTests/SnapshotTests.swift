//
//  SnapshotTests.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/28/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import Foundation
import FBSnapshotTestCase

@testable import ImageGallery

class SnapshotTests : FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
        MockRequestClient.setupMock()
    }
    
    func testLoadedGallery() {
        let navigationViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateInitialViewController() as! UINavigationController

        let gallery = navigationViewController.viewControllers[0] as! GalleryViewController
        _ = gallery.view
        gallery.searchBar.text = "mocking"
        let expect = expectation(description: "wait for images to load")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.FBSnapshotVerifyLayer(gallery.navigationController!.view.layer)
            expect.fulfill()
        })
        waitForExpectations(timeout: 2) {_ in }
    }


    func testPhotoPreview() {
        let photoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoViewController.photoViewModel = PhotoViewModel(photoToShow: MockRequestClient.loadMockPhoto())
        _ = photoViewController.view
        
        let expect = expectation(description: "wait for images to load")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.FBSnapshotVerifyLayer(photoViewController.view.layer)
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 2) { error in
            
        }
        
    }
}
