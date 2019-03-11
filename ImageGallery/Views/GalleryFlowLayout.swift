//
//  GalleryFlowLayout.swift
//  ImageGallery
//
//  Created by Lucas Farris on 7/26/17.
//  Copyright © 2017 Lucas Farris. All rights reserved.
//

import UIKit

/// Collection view flow layout for the gallery.
class GalleryFlowLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow) - 3
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        if let itemCell = cell as? ItemCell {
            itemCell.stopLoading()
        }
    }
}
