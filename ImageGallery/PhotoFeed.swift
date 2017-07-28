//
//  PhotoFeed.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/27/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import Foundation
import FeedKit

public class PhotoFeed:NSObject {
    
    private let baseUrl = "https://api.flickr.com/services/feeds/photos_public.gne"
    private let tagsParamName = "tags"
    
    private func buildUrl(with tags:String) -> URL? {
        var urlComponents = URLComponents(string: baseUrl)
        
        if !tags.isEmpty {
            urlComponents?.queryItems = [URLQueryItem(name: tagsParamName, value: tags)]
        }
        return urlComponents?.url
    }
    
    public func downloadFeed(with tags:String, result:@escaping ([AtomFeedEntry]?)->Void) {
        
        if let url = buildUrl(with: tags) {
            DispatchQueue.global(qos: .background).async {
                let parser = FeedParser(URL: url)
                let feed = parser?.parse()
                DispatchQueue.main.async {
                    result(feed?.atomFeed?.entries)
                }
            }
        } else {
            result (nil)
            return
        }
    }
}
