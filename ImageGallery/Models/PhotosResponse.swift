//
//  File.swift
//  ImageGallery
//
//  Created by Lucas Farris on 3/9/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import UIKit

/// Model of the response of a photo search request.
/// {"photos":{ }, "stat":"ok" }
struct PhotosResponse: Codable {
    let photos: PhotoPage
    let status: String

    private enum CodingKeys: String, CodingKey {
        case photos
        case status = "stat"
    }
}
