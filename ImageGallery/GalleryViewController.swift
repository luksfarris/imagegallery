//
//  ViewController.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/26/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import UIKit
import Foundation
import FeedKit

enum SortimgMode {
    case none
    case ascending
    case descending
}

class GalleryViewController: UIViewController {

    @IBOutlet weak var sortingButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private let flowLayout = GalleryFlowLayout()
    private let refreshControl = UIRefreshControl()
    
    private var sortingMode:SortimgMode = .none {
        didSet {
            switch sortingMode {
            case .none:
                sortingButton.title = "Sort"
                break
            case .ascending:
                sortingButton.title = "↓ Published"
                break
            default:
                sortingButton.title = "↑ Published"
            }
        }
    }
    
    fileprivate var tags = "" {
        didSet {
            self.downloadData()
        }
    }
    
    fileprivate var entries:[AtomFeedEntry] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        downloadData()
    }
    
    private func setupView() {
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = flowLayout
        flowLayout.delegate = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(GalleryViewController.downloadData), for: .valueChanged)
        
        self.navigationController?.navigationBar.tintColor = UIColor.niceGray()
    }
    
    public func downloadData() {
        sortingMode = .none
        let feed = PhotoFeed()
        feed.downloadFeed(with: tags) { (result) in
            if let items = result {
                self.entries = items
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoController = segue.destination as? PhotoViewController, let index  = sender as? NSInteger  {
            photoController.entry = entries[index]
        }
    }
    
    @IBAction func sortImages(_ sender: UIBarButtonItem) {
        
        if sortingMode == .none || sortingMode == .descending {
            sortingMode = .ascending
        } else {
            sortingMode = .descending
        }
        
        entries.sort { (entry1, entry2) -> Bool in
            let date1 = entry1.published ?? Date()
            let date2 = entry2.published ?? Date()
            if self.sortingMode == .ascending {
                return date1.compare(date2) == .orderedAscending
            } else {
                return date1.compare(date2) == .orderedDescending
            }
        }
        
    }
    
    @IBAction func openSearch(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search", message: "Type the tags, comma separated", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Cute, birds"
            textField.clearButtonMode = .whileEditing
            textField.text = self.tags
        }
        
        alertController.addAction(UIAlertAction(title: "Search", style: .default, handler: { (action) in
            self.tags = alertController.textFields![0].text ?? ""
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension GalleryViewController : GalleryProtocol {
    func openItem(at index:NSInteger) {
        performSegue(withIdentifier: "details", sender: index)
    }
}

extension GalleryViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.isHidden = entries.count == 0
        return entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        itemCell.configure(with: entries[indexPath.row].photoRequest())
        return itemCell
    }
}
