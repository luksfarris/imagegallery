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

extension AtomFeedEntry {
    
    func metadata() -> String {
        var metadata = ""
        
        if let title = self.title {
            metadata += "Title: " + title + "\n"
        }
        
        if let id = self.id {
            metadata += "Id: " + id + "\n"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm"
        
        if let published = self.published {
            metadata += "Published: " + dateFormatter.string(from: published) + "\n"
        }
        
        if let updated = self.updated {
            metadata += "Updated: " + dateFormatter.string(from: updated) + "\n"
        }
        
        if let authors = self.authors {
            metadata += "Author: "
            for author in authors {
                if let authorName = author.name {
                    metadata += authorName
                }
            }
            metadata += "\n"
        }
        
        return metadata
    }
    
    func webpageUrl() -> URL? {
        if let links = self.links {
            for link in links {
                if let type = link.attributes?.type, let href = link.attributes?.href {
                    if type == "text/html", let url = URL(string: href) {
                        return url
                    }
                }
            }
        }
        return nil
    }
    
    func photoRequest() -> URLRequest? {
        if let links = self.links {
            for link in links {
                if let type = link.attributes?.type, let href = link.attributes?.href {
                    if type == "image/jpeg", let url = URL(string: href) {
                        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
                    }
                }
            }
        }
        return nil
    }
}
