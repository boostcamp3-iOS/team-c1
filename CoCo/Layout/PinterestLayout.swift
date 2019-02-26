//
//  PinterestLayout.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForTitleIndexPath indexPath: IndexPath) -> CGFloat
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewFlowLayout {
    // MARK: - Propertise
    private var itemFixedDimension: CGFloat = 0
    private var itemFlexibleDimension: CGFloat = 0
    fileprivate var numberOfColums =  2
    fileprivate var cellPadding: CGFloat = 4
    fileprivate var cellCache = [UICollectionViewLayoutAttributes]()
    fileprivate var headerCache = [UICollectionViewLayoutAttributes]()
    fileprivate var currentyOffset: CGFloat = 0
    fileprivate var yOffset = [CGFloat]()
    fileprivate var ycolum = 0
    fileprivate var extraCount = 0
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let inset = collectionView.contentInset
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    weak var delegate: PinterestLayoutDelegate?

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // MARK: - Methodes
    override func prepare() {
        guard cellCache.isEmpty == true, headerCache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        guard let delegate = delegate else {
            return
        }

        self.contentHeight = 0

        let headerFlexibleDimension = delegate.headerFlexibleHeight(inCollectionView: collectionView, withLayout: self, fixedDimension: itemFixedDimension)

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            if headerFlexibleDimension > 0.0 && item == 0 {
                let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: item))
                headerLayoutAttributes.frame = CGRect(x: 0, y: 0, width: contentWidth, height: headerFlexibleDimension)
                headerCache.append(headerLayoutAttributes)
            }
        }
        yOffset = [CGFloat](repeating: headerFlexibleDimension, count: numberOfColums)
        setCellPinterestLayout(indexPathRow: 0) {}
    }

    func setCellPinterestLayout(indexPathRow: Int, completion: @escaping () -> Void) {
        print("contentHeight: \(contentHeight)")
        guard let collectionView = collectionView else {
            return
        }
        guard let delegate = delegate else {
            return
        }
        let columWith = contentWidth / CGFloat(numberOfColums)
        var xOffset = [CGFloat]()
        for colum in 0 ..< numberOfColums {
            xOffset.append(CGFloat(colum) * columWith)
        }

        if indexPathRow != 0 {
            self.extraCount = 20
        }

        for item in indexPathRow ..< collectionView.numberOfItems(inSection: 0) + extraCount {
            let indexPath = IndexPath(item: item, section: 0)
            let flexibleHeight = delegate.collectionView(collectionView, heightForTitleIndexPath: indexPath)
            let height = cellPadding * 2 + flexibleHeight
            let frame = CGRect(x: xOffset[ycolum], y: yOffset[ycolum], width: columWith, height: height)
            let insertFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insertFrame
            cellCache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[ycolum] = yOffset[ycolum] + height

            ycolum = ycolum < (numberOfColums - 1) ? (ycolum + 1) : 0
        }
        completion()
    }

    func setupInit() {
        self.extraCount = 0
        self.cellCache.removeAll()
        self.headerCache.removeAll()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let header = headerCache.filter {
            $0.frame.intersects(rect)
        }
        let visibleLayoutAttributes = cellCache.filter {
            $0.frame.intersects(rect)
        }
        return header + visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellCache[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
