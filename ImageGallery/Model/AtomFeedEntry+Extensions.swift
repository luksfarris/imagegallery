//
//  AtomFeedEntry+Extensions.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/28/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import Foundation
import FeedKit

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
    
    private func findAttachmentWith(type mime:String) -> URL? {
        if let links = self.links {
            for link in links {
                if let type = link.attributes?.type, let href = link.attributes?.href {
                    if type == mime, let url = URL(string: href) {
                        return url
                    }
                }
            }
        }
        return nil
    }
    
    func webpageUrl() -> URL? {
        return findAttachmentWith(type: "text/html")
    }
    
    func photoRequest() -> URLRequest? {
        if let url = findAttachmentWith(type: "image/jpeg") {
            return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        } else {
            return nil
        }
    }
}
