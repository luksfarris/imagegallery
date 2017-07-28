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
    
    @IBOutlet weak var imageView: UIImageView!
    
    public func configure(with urlRequest:URLRequest?) {
        imageView.setImageWith(urlRequest!, placeholderImage: nil, success: success(_:_:_:), failure: failure(_:_:_:))
    }
    
    private func failure(_ request:URLRequest,_ response:HTTPURLResponse?,_ error:Error) -> Void {
        
    }
    
    private func success(_ request:URLRequest,_ response:HTTPURLResponse?,_ image:UIImage) -> Void {
        self.imageView.image = image
    }
    
    public func cancelDownload() {
        imageView.cancelImageDownloadTask()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelImageDownloadTask()
        imageView.image = nil
    }
}
