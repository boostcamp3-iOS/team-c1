//
//  SearchKeywordFlowLayout.swift
//  CoCo
//
//  Created by 이호찬 on 12/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        // "UICollectionViewFlowLayout has cached frame mismatch" 에러를 없에기 위해 값을 복사해줌
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }

        let leftPadding: CGFloat = 8
        let interItemSpacing = minimumInteritemSpacing

        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        // index 번째 줄의 첫 x 값과, 마지막 x 값 ex) [[8, 240], [8, 300]] 쉽게 말해 최소 공간과 cell width 값들을 다 합친값 (---  _  ----  _  -----) >>> (---_----_-----)
        var rowSizes = [[CGFloat]]()
        // 현재 줄의 위치
        var currentRow: Int = 0

        // 한줄에 각각 셀 별로 x 값을 가져와서 첫 x 값과 마지막 x 값을 rowSize 에 저장
        attributes.enumerated().forEach { index, layoutAttribute in

            print(layoutAttribute.frame)

            if index != attributes.count - 1 { // 헤더 값 제거
                if layoutAttribute.frame.origin.y >= currentY {
                    currentX = leftPadding
                    if !rowSizes.isEmpty {
                        currentRow += 1
                    }
                    rowSizes.append([currentX, 0])
                }
                layoutAttribute.frame.origin.x = currentX
                currentX += layoutAttribute.frame.width + interItemSpacing
                currentY = max(layoutAttribute.frame.maxY, currentY)
                // 현재 cell의 x + width 값에서 처음 떨어진 값을 빼주면 길이가 나옴
                rowSizes[currentRow][1] = currentX - interItemSpacing
            }
        }
        print(rowSizes)

        // 가져온 위치값들로 centerAlign 계산
        currentX = leftPadding
        currentY = 0
        currentRow = 0
        attributes.enumerated().forEach { index, layoutAttribute in
            if index != attributes.count - 1 { // 헤더 값 제거
                if layoutAttribute.frame.origin.y >= currentY {
                    currentX = leftPadding
                    // last.x - first.x
                    let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0]
                    let appendedMargin = ((collectionView?.frame.width ?? 0.0) - rowWidth - leftPadding * 2) / 2
                    currentX += appendedMargin
                    currentRow += 1
                }
                layoutAttribute.frame.origin.x = currentX
                currentX += layoutAttribute.frame.width + interItemSpacing
                currentY = max(layoutAttribute.frame.maxY, currentY)

                print(layoutAttribute.frame)
            }
        }

        return attributes
    }
}
