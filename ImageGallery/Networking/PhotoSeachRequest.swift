//
//  PhotoSeachRequest.swift
//  ImageGallery
//
//  Created by Lucas Farris on 3/10/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import UIKit

/// Creates requests that search for photos in Flickr
class PhotoSeachRequest: FlickrCommunication {
    fileprivate static let safeParameter = URLQueryItem(name: "safe", value: "1")
    fileprivate static let sortParameter = URLQueryItem(name: "sort", value: "relevance")
    fileprivate static let formatParameter = URLQueryItem(name: "format", value: "json")
    fileprivate static let searchMethodParameter = URLQueryItem(name: "method", value: "flickr.photos.search")
    fileprivate static let contentParameter = URLQueryItem(name: "content_type", value: "1")
    fileprivate static let licenseParameter = URLQueryItem(name: "license", value: "4")
    fileprivate static let textParamName = "text"

    /// Builds the photo search URL request, using a given text query.
    /// If the query is empty, searches photos since Jan 1 2019
    public static func buildSearchRequest(_ textQuery: String) -> URLRequest? {
        var components = requestComponents()
        components?.queryItems?.append(contentsOf: [safeParameter, sortParameter, formatParameter,
                                                    searchMethodParameter, contentParameter, licenseParameter])
        if textQuery.count > 0 {
            let textParameter = URLQueryItem(name: textParamName, value: textQuery)
            components?.queryItems?.append(textParameter)
        } else {
            let recentParameter = URLQueryItem(name: "min_upload_date", value: "1546300800")
            components?.queryItems?.append(recentParameter)
        }
        guard let url = components?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
