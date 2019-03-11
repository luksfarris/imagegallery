//
//  PhotoViewController.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/27/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import RxCocoa
import RxSwift
import SafariServices
import UIKit

/// Shows one specific photo to users.
/// Allow users to save, share, or open the webpage of the picture displayed.
class PhotoViewController: UIViewController {
    @IBOutlet public var imageView: GalleryImageView!
    @IBOutlet private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet private var tapGestureRecognizer: UITapGestureRecognizer!
    public var photoViewModel: PhotoViewModel?
    private let disposeBag = DisposeBag()
    private let menuItems = [UIMenuItem(title: NSLocalizedString("Save", comment: "Save Button"),
                                        action: #selector(PhotoViewController.saveImage)),
                             UIMenuItem(title: NSLocalizedString("Open in Browser", comment: "Browser Button"),
                                        action: #selector(PhotoViewController.openImage)),
                             UIMenuItem(title: NSLocalizedString("Share", comment: "Share Button"),
                                        action: #selector(PhotoViewController.shareImage))]

    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
    }

    // MARK: configurations

    /// Sets up the view controller visually, and loads the picture.
    private func setupView() {
        navigationItem.title = photoViewModel?.photo.title
        view.backgroundColor = UIColor.niceGray()
        imageView.backgroundColor = UIColor.blackPhotoBackground()
        photoViewModel?.loadPhoto().bind(onNext: { [unowned self] image in
            self.imageView.configure(with: image)
        }).disposed(by: disposeBag)
    }

    /// Opens the menu when a user long taps and it's not opened,
    /// and closes it when a user taps the picture.
    private func setupGestureRecognizers() {
        tapGestureRecognizer.rx.event.bind(onNext: { [unowned self] _ in
            self.imageView.resignFirstResponder()
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }).disposed(by: disposeBag)

        longPressGestureRecognizer.rx.event
            .filter({ gesture in gesture.state == .began })
            .map({ gesture in (gesture: gesture, menu: UIMenuController.shared) })
            .filter({ input in !input.menu.isMenuVisible })
            .bind(onNext: { [unowned self] input in
                input.gesture.view?.becomeFirstResponder()
                input.menu.menuItems = self.menuItems
                let targetRect = CGRect(origin: input.gesture.location(in: self.view),
                                        size: CGSize(width: 1, height: 1))
                input.menu.setTargetRect(targetRect, in: self.view)
                input.menu.setMenuVisible(true, animated: true)
            }).disposed(by: disposeBag)
    }

    // MARK: Menu Controller Actions

    /// Opens a picture's webpage in a safari controller.
    @objc private func openImage() {
        if let photo = photoViewModel?.photo, let url = FlickrCommunication.webpageUrl(photo) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }

    /// Opens the activity view controller to share a picture.
    @objc private func shareImage() {
        if let photo = photoViewModel?.photo, let url = FlickrCommunication.webpageUrl(photo) {
            let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(avc, animated: true, completion: nil)
        }
    }

    /// Saves a picture to the photo album.
    @objc private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
}
