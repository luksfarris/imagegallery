//
//  GalleryImageView.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/28/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import UIKit

/// Image view subclass that loads images from a given url,
/// Show loading indicators, and may show menu controllers.
class GalleryImageView: UIImageView {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(activityIndicator)
        activityIndicator.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = center
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: Image Loading

    /// Stop the loading animation
    public func stopLoading() {
        activityIndicator.stopAnimating()
    }

    /// Sets the placeholder and starts the loading animation.
    public func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        image = UIImage(named: "placeholder")
    }

    /// Stops the loading animation and displays the image.
    public func configure(with image: UIImage?) {
        activityIndicator.stopAnimating()
        self.image = image
    }
}
