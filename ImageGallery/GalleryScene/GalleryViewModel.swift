//
//  PhotoViewModel.swift
//  ImageGallery
//
//  Created by Lucas Farris on 3/8/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// Gallery's view controller View-Model
class GalleryViewModel {
    public static var requestClient: RequestClient = DefaultRequestClient()
    public let searchQuery = BehaviorRelay(value: (search: "", sender: nil) as (search: String, sender: Any?))
    public let photoSelectionPublishSubject: PublishSubject<Int> = PublishSubject<Int>()
    public var showPhotoObservable: Observable<PhotoViewModel>?

    public lazy var photoDriver: Driver<[Photo]> = {
        self.searchQuery.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .filter(GalleryViewModel.shouldSearch)
            .map({ input -> String in input.search })
            .flatMapLatest(GalleryViewModel.photoSearchObservable)
            .asDriver(onErrorJustReturn: [])
    }()

    init() {
        showPhotoObservable = photoSelectionPublishSubject
            .withLatestFrom(photoDriver) { row, photos in photos[row] }
            .map { photo in PhotoViewModel(photoToShow: photo) }
    }

    /// Determines if a query/sender input should trigger a search
    /// We want to search if more than 3 characters are typed,
    /// If the refresh control triggered it
    /// Or if this is the first time the app runs
    private static func shouldSearch(text: String, sender: Any?) -> Bool {
        return text.count > 3
            || sender is UIRefreshControl
            || sender == nil
    }

    /// Searches for photos using the given search query.
    /// If anything goes wrong, should observe an empty array.
    public static func photoSearchObservable(_ search: String) -> Observable<[Photo]> {
        guard let request = PhotoSeachRequest.buildSearchRequest(search) else {
            return Observable.just([])
        }
        return requestClient.data(request: request)
            .map(FlickrCommunication.parseApiResponse)
            .map(GalleryViewModel.parseJson)
    }

    /// Tries to parse a json Data representation into an array of Photo models
    /// Empty array returned if decoding fails.
    public static func parseJson(data: Data) -> [Photo] {
        do {
            let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: data)
            return photosResponse.photos.photos
        } catch {
            print("Json parsing failed")
            return []
        }
    }

    /// Loads a thumbnail
    public func loadThumbObservable(_ photo: Photo) -> Observable<UIImage?> {
        if let url = FlickrCommunication.photoUrl(photo, isThumb: true) {
            return PhotoViewModel.requestClient.image(url: url)
        } else {
            return Observable.just(UIImage(named: "placeholder"))
        }
    }
}
