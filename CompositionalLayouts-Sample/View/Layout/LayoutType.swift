//
//  LayoutType.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/06.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

enum LayoutType {
    case grid // グリッド形式での表示（3 * n）
    case insta // Instagramの検索画面
    case netflix // Netflixのトップ(動画一覧)画面

    func layout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        switch self {
        case .grid:
            return gridLayout(collectionViewBounds: collectionViewBounds)
        case .insta:
            return instaLayout(collectionViewBounds: collectionViewBounds)
        case .netflix:
            return netFlixLayout(collectionViewBounds: collectionViewBounds)
        }
    }

    func gridLayout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        let itemCount = 3 // 横に並べる数
        let lineCount = itemCount - 1
        let itemSpacing = CGFloat(2) // セル間のスペース
        let itemLength = (collectionViewBounds.width - (itemSpacing * CGFloat(lineCount))) / CGFloat(itemCount)
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        let items = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                          heightDimension: .fractionalHeight(1.0)),
                                                       subitem: item,
                                                       count: itemCount)
        items.interItemSpacing = .fixed(itemSpacing)
        let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: .absolute(itemLength)),
                                                      subitems: [items])
        let section = NSCollectionLayoutSection(group: groups) // ここでセルの数に反映
        section.interGroupSpacing = itemSpacing
        section.contentInsets = .init(top: 0, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func instaLayout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        let itemSpacing = CGFloat(2) // セル間のスペース
        // 小ブロック縦2グループ
        let itemLength = (collectionViewBounds.width - (itemSpacing * 2)) / 3
        let largeItemLength = itemLength * 2 + itemSpacing

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        let verticalItemTwo = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                                                  heightDimension: .absolute(largeItemLength)),
                                                               subitem: item,
                                                               count: 2)
        verticalItemTwo.interItemSpacing = .fixed(itemSpacing)
        // 大ブロックありグループ
        let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(largeItemLength),
                                                                                  heightDimension: .absolute(largeItemLength)))

        let largeItemLeftGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                       heightDimension: .absolute(largeItemLength)),
                                                                    subitems: [largeItem, verticalItemTwo])
        largeItemLeftGroup.interItemSpacing = .fixed(itemSpacing)

        let largeItemRightGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                        heightDimension: .absolute(largeItemLength)),
                                                                     subitems: [verticalItemTwo, largeItem])
        largeItemRightGroup.interItemSpacing = .fixed(itemSpacing)
        // 小ブロック縦2横3グループ
        let twoThreeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                      heightDimension: .absolute(largeItemLength)),
                                                                   subitem: verticalItemTwo,
                                                                   count: 3)
        twoThreeItemGroup.interItemSpacing = .fixed(itemSpacing)

        let subitems = [largeItemLeftGroup, twoThreeItemGroup, largeItemRightGroup, twoThreeItemGroup]
        let groupsSpaceCount = CGFloat(subitems.count - 1)
        let heightDimension = NSCollectionLayoutDimension.absolute(largeItemLength * CGFloat(subitems.count) + (itemSpacing * groupsSpaceCount))
        // MEMO: 高さの計算は後に追加するスペース分も足す
        let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: heightDimension),
                                                      subitems: subitems)
        groups.interItemSpacing = .fixed(itemSpacing)
        let section = NSCollectionLayoutSection(group: groups)
        section.interGroupSpacing = itemSpacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func netFlixLayout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        // 縦長方形グループ
        let verticalRectangleHeight = collectionViewBounds.height * 0.8
        let verticalRectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(1.0)))
        let verticalRectangleGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                         heightDimension: .absolute(verticalRectangleHeight)),
                                                                      subitem: verticalRectangleItem,
                                                                      count: 1)

        // (ヘッダー+横長方形グループ) * 2
        let headerHeight = CGFloat(50)
        let horizonRectangleItemHeight = collectionViewBounds.width * 0.9 / 3 * (4/3)
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                   heightDimension: .absolute(headerHeight)))
        let horizonRectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                             heightDimension: .absolute(horizonRectangleItemHeight)))
        let horizonRectangleGroupHeight = headerHeight + horizonRectangleItemHeight
        let horizonRectangleGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                        heightDimension: .absolute(horizonRectangleGroupHeight)),
                                                                     subitems: [headerItem, horizonRectangleItem])
        let horizonRectangleDoubleGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                              heightDimension: .absolute(horizonRectangleGroupHeight * 2)),
                                                                           subitem: horizonRectangleGroup,
                                                                           count: 2)
        // ヘッダー+正方形グループ
        let squareItemLength = collectionViewBounds.width
        let squareItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                   heightDimension: .fractionalHeight(squareItemLength)))
        let squareItemGroup = NSCollectionLayoutGroupCustomItemProvider
        let groupsHeight = verticalRectangleHeight + (horizonRectangleGroupHeight * 2)
        let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: .absolute(groupsHeight)),
                                                      subitems: [verticalRectangleGroup, horizonRectangleDoubleGroup])
        let section = NSCollectionLayoutSection(group: groups)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
