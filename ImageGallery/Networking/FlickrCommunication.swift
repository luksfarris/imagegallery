//
//  PhotoFeed.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/27/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// Knows the specifics about the communication with the Flickr API
class FlickrCommunication {
    /// Base URL for all requests
    fileprivate static let baseUrl = "https://api.flickr.com/services/rest/"
    /// API key parameter needed in all requests
    fileprivate static let apiParameter = URLQueryItem(name: "api_key", value: "KEY")

    /// Generates a URLComponents with the base url and the api key
    internal static func requestComponents() -> URLComponents? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [apiParameter]
        return urlComponents
    }

    /// Reads a Data response, removes the flickr wrapper
    /// returns the json data or empty data if UTF-8 encoding/decoding fails
    public static func parseApiResponse(_ data: Data) -> Data {
        guard var text = String(data: data, encoding: .utf8) else {
            print("Data decoding failed")
            return Data()
        }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefix = "jsonFlickrApi("
        let suffix = ")"
        if text.hasPrefix(prefix), text.hasSuffix(suffix) {
            text = String(text.dropFirst(prefix.count).dropLast(suffix.count))
        }
        guard let jsonData = text.data(using: .utf8) else {
            print("Data encoding failed")
            return Data()
        }
        return jsonData
    }

    /// Returns the Flickr web page of a Photo model
    public static func webpageUrl(_ photo: Photo) -> URL? {
        // https://www.flickr.com/photos/{owner}/{id}
        let request = String(format: "https://www.flickr.com/photos/%@/%@",
                             photo.user,
                             photo.identifier)
        return URL(string: request)
    }

    /// Returns the Flickr image resource of a Photo model
    /// Optionally returns a scaled down version if isThumb is true
    public static func photoUrl(_ photo: Photo, isThumb: Bool) -> URL? {
        // http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        let request = String(format: "http://farm%d.staticflickr.com/%@/%@_%@%@.jpg",
                             photo.farm,
                             photo.server,
                             photo.identifier,
                             photo.secret,
                             isThumb ? "_m" : "")
        return URL(string: request)
    }
}
