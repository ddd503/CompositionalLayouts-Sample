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
    case insta
    case pintarest

    func layout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        switch self {
        case .grid:
            let itemLength = NSCollectionLayoutDimension.absolute(collectionViewBounds.width / 3)
            let itemSpacing = CGFloat(2)
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: itemLength, heightDimension: itemLength))
            let items = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(1.0)),
                                                           subitem: item,
                                                           count: 3)
            items.interItemSpacing = .fixed(itemSpacing)
            items.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                             heightDimension: itemLength),
                                                          subitems: [items])
            let sections = NSCollectionLayoutSection(group: groups) // ここでセルの数に反映
            sections.interGroupSpacing = itemSpacing
            sections.contentInsets = .init(top: 0, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
            let layout = UICollectionViewCompositionalLayout(section: sections)
            return layout
        default: return UICollectionViewLayout()
        }
    }
}
