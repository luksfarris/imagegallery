//
//  File.swift
//  ImageGallery
//
//  Created by Lucas Farris on 3/9/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import UIKit

/// Model of a page of photos from the flickr API.
/// {"page":1,"pages":2181,"perpage":100,"total":"218075","photo":[]}
struct PhotoPage: Codable {
    let currentPage: UInt64
    let totalPages: UInt64
    let resultsPerPage: UInt16
    let totalCount: String
    let photos: [Photo]

    private enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "pages"
        case resultsPerPage = "perpage"
        case totalCount = "total"
        case photos = "photo"
    }
}
