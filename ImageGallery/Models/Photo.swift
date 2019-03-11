//
//  AtomFeedEntry+Extensions.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/28/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import UIKit

/// Model of a single photo of the flickr API.
/// {"id":"27255684880","owner":"141556536@N08","secret":"585683f1d9","server":"7102","farm":8,"title":"1900"}
struct Photo: Codable {
    let identifier: String
    let user: String
    let title: String
    let server: String
    let farm: UInt64
    let secret: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case user = "owner"
        case title
        case server
        case farm
        case secret
    }
}
