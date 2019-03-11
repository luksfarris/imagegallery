//
//  ViewController.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/26/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// Shows a collection of photos to the user
class GalleryViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private let galleryViewModel = GalleryViewModel()
    private let flowLayout = GalleryFlowLayout()
    private let disposeBag = DisposeBag()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupRefreshControl()
        setupSearchBar()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [unowned self] _ in
            self.collectionView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoViewController = segue.destination as? PhotoViewController,
            let photoViewModel = sender as? PhotoViewModel {
            photoViewController.photoViewModel = photoViewModel
        }
    }

    // MARK: Configurations

    /// Configures the collection view's layout, data, and interactions
    public func setupCollectionView() {
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = flowLayout
        galleryViewModel.photoDriver
            .drive(collectionView.rx.items(cellIdentifier: "ItemCell")) { [unowned self] _, photo, cell in
                let itemCell = cell as? ItemCell
                itemCell?.load(self.galleryViewModel.loadThumbObservable(photo))
            }
            .disposed(by: disposeBag)

        galleryViewModel.photoDriver.drive(onNext: { [unowned self] photos in
            self.collectionView.isHidden = photos.count == 0
        }).disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: galleryViewModel.photoSelectionPublishSubject)
            .disposed(by: disposeBag)

        galleryViewModel.showPhotoObservable?
            .subscribe(onNext: { [unowned self] photoViewModel in
                self.performSegue(withIdentifier: "details", sender: photoViewModel)
            }).disposed(by: disposeBag)
    }

    /// Configures the refresh control, its events and refreshing status
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl

        galleryViewModel.photoDriver
            .asDriver()
            .filter({ [unowned self] _ in self.refreshControl.isRefreshing })
            .drive(onNext: { [unowned self] _ in
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .map({ [unowned self] _ in self.refreshControl })
            .filter({ refreshControl in refreshControl.isRefreshing == true })
            .map({ [unowned self] refreshControl in (self.searchBar.text ?? "", refreshControl) })
            .bind(to: galleryViewModel.searchQuery)
            .disposed(by: disposeBag)
    }

    /// Configures the observables of the searchbar, and its search button
    public func setupSearchBar() {
        searchBar.rx.text
            .orEmpty
            .map({ [unowned self] text in (text, self.searchBar) })
            .bind(to: galleryViewModel.searchQuery)
            .disposed(by: disposeBag)

        Observable.of(searchBar.rx.searchButtonClicked, collectionView.rx.didScroll)
            .merge()
            .subscribe(onNext: { [unowned self] _ in self.searchBar.resignFirstResponder() })
            .disposed(by: disposeBag)
    }

    /// Sets up the visual aspects of the view controller
    private func setupView() {
        navigationController?.navigationBar.tintColor = UIColor.niceGray()
        view.backgroundColor = UIColor.niceGray()
        navigationController?.navigationBar.barTintColor = UIColor.niceGreen()
        navigationItem.title = NSLocalizedString("Photo Gallery", comment: "Gallery Title")
        searchBar.placeholder = NSLocalizedString("football, street, italy", comment: "Search Placeholder")
    }
}
