//
//  ItemCell.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/27/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import RxSwift
import UIKit

/// Cell of the gallery's collection view
class ItemCell: UICollectionViewCell {
    @IBOutlet var imageView: GalleryImageView!
    private let disposeBag = DisposeBag()
    private var disposable: Disposable?

    override func awakeFromNib() {
        super.awakeFromNib()
        startLoading()
    }

    override func prepareForReuse() {
        startLoading()
    }

    public func load(_ observable: Observable<UIImage?>) {
        disposable = observable.bind(onNext: { [unowned self] image in
            self.configure(image: image)
        })
        disposable?.disposed(by: disposeBag)
    }

    /// Stops the loading animation.
    public func stopLoading() {
        imageView.stopLoading()
        disposable?.dispose()
    }

    /// Sets the placeholder and starts the loading animation.
    public func startLoading() {
        imageView.startLoading()
    }

    /// Loads the cell's thumbnail with the given url.
    public func configure(image: UIImage?) {
        imageView.configure(with: image)
    }
}
