//
//  MockRequestClient.swift
//  ImageGalleryTests
//
//  Created by Lucas Farris on 3/10/19.
//  Copyright © 2019 Lucas Farris. All rights reserved.
//

import RxSwift
import UIKit

@testable import ImageGallery

class MockRequestClient: RequestClient {
    func image(url _: URL) -> Observable<UIImage?> {
        return Observable.just(UIImage(named: "mock"))
    }

    func data(request _: URLRequest) -> Observable<Data> {
        var mockData = Data()
        do {
            let path = Bundle.main.path(forResource: "mock", ofType: "json")
            let text = try String(contentsOfFile: path!)
            mockData = text.data(using: .utf8) ?? Data()
        } catch {}
        return Observable.create { observer in
            observer.on(.next(mockData))
            observer.on(.completed)
            return Disposables.create()
        }
    }

    public static func setupMock() {
        GalleryViewModel.requestClient = MockRequestClient()
        PhotoViewModel.requestClient = MockRequestClient()
    }

    public static func loadMockPhoto() -> Photo {
        return Photo(identifier: "1", user: "1", title: "Mockz", server: "1", farm: 1, secret: "1")
    }

    public static func loadMockData() -> Data {
        do {
            let path = Bundle.main.path(forResource: "mock", ofType: "json")
            let text = try String(contentsOfFile: path!)
            guard let data = text.data(using: .utf8) else {
                return Data()
            }
            return data
        } catch {
            return Data()
        }
    }
}
