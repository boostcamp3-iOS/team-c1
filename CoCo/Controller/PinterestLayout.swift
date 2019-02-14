//
//  PinterestLayout.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate!

    fileprivate var numberOfColums =  2
    fileprivate var cellPadding: CGFloat = 3
    fileprivate var cellCache = [UICollectionViewLayoutAttributes]()
    fileprivate var headerCache = [UICollectionViewLayoutAttributes]()
    private var itemFixedDimension: CGFloat = 0
    private var itemFlexibleDimension: CGFloat = 0
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let inset = collectionView.contentInset
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // called whenever the collection view's layout is invalidated
    override func prepare() {
        guard cellCache.isEmpty == true, headerCache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let headerFlexibleDimension = delegate.headerFlexibleHeight(inCollectionView: collectionView, withLayout: self, fixedDimension: itemFixedDimension)
        let columWith = contentWidth / CGFloat(numberOfColums)
        var xOffset = [CGFloat]()
        for colum in 0 ..< numberOfColums {
            xOffset.append(CGFloat(colum) * columWith)
        }
        var colum = 0
        var yOffset = [CGFloat](repeating: 230, count: numberOfColums)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            if headerFlexibleDimension > 0.0 && item == 0 {
                let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: item))
                headerLayoutAttributes.frame = CGRect(x: 0, y: 0, width: contentWidth, height: headerFlexibleDimension)
                headerCache.append(headerLayoutAttributes)
            }
            let flexibleHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + flexibleHeight
            let frame = CGRect(x: xOffset[colum], y: yOffset[colum], width: columWith, height: height)
            let insertFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insertFrame
            cellCache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[colum] = yOffset[colum] + height

            colum = colum < (numberOfColums - 1) ? (colum + 1) : 0
        }
    }

    // collection view calls after prepare()
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let header = headerCache.filter {
            $0.frame.intersects(rect)
        }
        let visibleLayoutAttributes = cellCache.filter {
            $0.frame.intersects(rect)
        }
        return header + visibleLayoutAttributes
    }

    // Returns the layout attributes for the item at the specified index path
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellCache[indexPath.item]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == UICollectionView.elementKindSectionHeader else { return nil }

        return headerCache.first {
            $0.indexPath == indexPath
        }
    }
}
