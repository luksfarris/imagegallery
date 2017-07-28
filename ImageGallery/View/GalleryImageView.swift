//
//  GalleryImageView.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/28/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class GalleryImageView : UIImageView {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(activityIndicator)
        activityIndicator.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = self.center
    }
    
    public func configure(with urlRequest:URLRequest?) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        self.setImageWith(urlRequest!, placeholderImage: nil, success: success(_:_:_:), failure: failure(_:_:_:))
    }
    
    private func failure(_ request:URLRequest,_ response:HTTPURLResponse?,_ error:Error) -> Void {
        activityIndicator.stopAnimating()
    }
    
    private func success(_ request:URLRequest,_ response:HTTPURLResponse?,_ image:UIImage) -> Void {
        self.image = image
        activityIndicator.stopAnimating()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
}
