//
//  ItemCell.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/27/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import UIKit
import AFNetworking

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: GalleryImageView!
    
    public func cancelDownload() {
        imageView.cancelImageDownloadTask()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelImageDownloadTask()
        imageView.image = nil
    }
}
