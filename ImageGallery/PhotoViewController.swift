//
//  PhotoViewController.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/27/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import UIKit
import FeedKit
import SafariServices

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: MenuImageView!
    
    public var entry:AtomFeedEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlRequest = entry?.photoRequest() {
            imageView.setImageWith(urlRequest, placeholderImage: nil, success: success(_:_:_:), failure: failure(_:_:_:))
        }
        
    }
    @IBAction func imageLongPressed(_ gesture: UILongPressGestureRecognizer) {
        
        guard let gestureView = gesture.view, gesture.state == .began else {
            return
        }
        
        let menuController = UIMenuController.shared
        
        guard !menuController.isMenuVisible else {
            return
        }
        
        gestureView.becomeFirstResponder()
        
        menuController.menuItems = [
            UIMenuItem(
                title: "Save",
                action: #selector(PhotoViewController.saveImage)
            ),
            UIMenuItem(
                title: "Open in Browser",
                action: #selector(PhotoViewController.openImage)
            ),
            UIMenuItem(
                title: "Share",
                action: #selector(PhotoViewController.shareImage)
            )
        ]
        
        menuController.setTargetRect(gestureView.frame, in: self.view)
        menuController.setMenuVisible(true, animated: true)
        
    }
    
    public func openImage() {
        if let url = entry?.webpageUrl() {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    public func shareImage() {
        if let url = entry?.webpageUrl() {
            let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(avc, animated: true, completion: nil)
        }
    }
    
    public func saveImage() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Metadata", message: entry?.metadata(), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func failure(_ request:URLRequest,_ response:HTTPURLResponse?,_ error:Error) -> Void {
        
    }
    
    private func success(_ request:URLRequest,_ response:HTTPURLResponse?,_ image:UIImage) -> Void {
        self.imageView.image = image
    }
}

class MenuImageView : UIImageView {
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
}

extension PhotoViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
