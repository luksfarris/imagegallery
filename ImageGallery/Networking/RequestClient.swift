//
//  RequestClient.swift
//  ImageGallery
//
//  Created by Lucas Farris on 3/10/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import RxSwift
import UIKit

/// Networking dependency. Configures implementations that handle URLRequests.
public protocol RequestClient {
    /// Returns the observable of a data representation response from a given url request
    func data(request: URLRequest) -> Observable<Data>
    /// returns the observable of a image downloaded from a given url resource
    func image(url: URL) -> Observable<UIImage?>
}

/// Default (as in not mocked) implementation of the request client.
public class DefaultRequestClient: RequestClient {
    /// Amount of retries requests should have
    let retries = 3

    public func data(request: URLRequest) -> Observable<Data> {
        return URLSession.shared.rx.data(request: request)
            .retry(retries)
            .catchErrorJustReturn(Data())
    }

    public func image(url: URL) -> Observable<UIImage?> {
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .observeOn(MainScheduler.instance)
            .map({ data in UIImage(data: data) })
            .catchErrorJustReturn(UIImage(named: "placeholder"))
    }
}
