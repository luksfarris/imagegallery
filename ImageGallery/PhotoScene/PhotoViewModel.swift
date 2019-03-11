//
//  PhotoViewModel.swift
//  ImageGallery
//
//  Created by Lucas Farris on 3/9/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// View-Model for the photo view controller.
class PhotoViewModel {
    var photo: Photo
    public static var requestClient: RequestClient = DefaultRequestClient()

    /// Knows the photo model to be displayed.
    init(photoToShow: Photo) {
        photo = photoToShow
    }

    /// Loads a picture in full resolution.
    public func loadPhoto() -> Observable<UIImage?> {
        if let url = FlickrCommunication.photoUrl(photo, isThumb: false) {
            return PhotoViewModel.requestClient.image(url: url)
        } else {
            return Observable.just(UIImage(named: "placeholder"))
        }
    }
}
