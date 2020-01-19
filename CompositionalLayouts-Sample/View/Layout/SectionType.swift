//
//  SectionType.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/18.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

// NSCollectionLayoutSection毎の種別
enum SectionType {
    case grid // グリッド表示されるセクション
    case largeAndSmallSquare // 大小2種類の正方形で構成されるセクション(インスタ風)
    case verticalRectangle // 縦の長方形１つのみのセクション
    case rectangleHorizonContinuousWithHeader // 縦の長方形が横スクロールで流れていくセクション（ヘッダー付き）
    case squareWithHeader // 正方形が1つのみのセクション（ヘッダー付き）

    init?(section: Int, type: LayoutType) {
        switch (section, type) {
        case (0, .grid):
            self = .grid
        case (0, .insta):
            self = .largeAndSmallSquare
        case (0, .netflix):
            self = .verticalRectangle
        case (1, .netflix):
            self = .rectangleHorizonContinuousWithHeader
        case (2, .netflix):
            self = .rectangleHorizonContinuousWithHeader
        case (3, .netflix):
            self = .squareWithHeader
        default: return nil
        }
    }

    func sectionTitle(section: Int, type: LayoutType) -> String {
        switch (section, type) {
        case (1, .netflix):
            return "オーストラリア"
        case (2, .netflix):
            return "グアム"
        case (3, .netflix):
            return "ベトナム"
        default: return "" // セクション表示なしルート
        }
    }

    func section(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        switch self {
        case .grid:
            return gridSection(collectionViewBounds: collectionViewBounds)
        case .largeAndSmallSquare:
            return largeAndSmallSquareSection(collectionViewBounds: collectionViewBounds)
        case .verticalRectangle:
            return verticalRectangleSection(collectionViewBounds: collectionViewBounds)
        case .rectangleHorizonContinuousWithHeader:
            return rectangleHorizonContinuousWithHeaderSection(collectionViewBounds: collectionViewBounds)
        case .squareWithHeader:
            return squareWithHeaderSection(collectionViewBounds: collectionViewBounds)
        }
    }

    /// グリッド表示
    private func gridSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemCount = 3 // 横に並べる数
        let lineCount = itemCount - 1
        let itemSpacing = CGFloat(1) // セル間のスペース
        let itemLength = (collectionViewBounds.width - (itemSpacing * CGFloat(lineCount))) / CGFloat(itemCount)
        // １つのitemを生成
        // .absoluteは固定値で指定する方法
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        // itemを3つ横並びにしたGroupを生成
        // .fractional~は親Viewとの割合
        let items = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                          heightDimension: .fractionalHeight(1.0)),
                                                       subitem: item,
                                                       count: itemCount)
        // Group内のitem間のスペースを設定
        items.interItemSpacing = .fixed(itemSpacing)

        // 生成したGroup(items)が縦に並んでいくGroupを生成（実質これがSection）
        let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: .absolute(itemLength)),
                                                      subitems: [items])
        // 用意したGroupを基にSectionを生成
        // 基本的にセルの数は意識しない、セルが入る構成(セクション)を用意しておくだけで勝手に流れてく
        let section = NSCollectionLayoutSection(group: groups)

        // Section間のスペースを設定
        section.interGroupSpacing = itemSpacing
        return section
    }

    /// (大+小縦2)+(小縦2*横3)+(小縦2+大)+(小縦2*横3)の計18アイテム
    private func largeAndSmallSquareSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemSpacing = CGFloat(2) // セル間のスペース

        // 小itemが縦に2つ並んだグループ
        let itemLength = (collectionViewBounds.width - (itemSpacing * 2)) / 3
        let largeItemLength = itemLength * 2 + itemSpacing

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        let verticalItemTwo = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                                                  heightDimension: .absolute(largeItemLength)),
                                                               subitem: item,
                                                               count: 2)
        verticalItemTwo.interItemSpacing = .fixed(itemSpacing)

        // 大item + 小item*2 のグループ
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

        // 小ブロックが縦に2つ並んだグループを横に3つ並べたグループ
        let twoThreeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                      heightDimension: .absolute(largeItemLength)),
                                                                   subitem: verticalItemTwo,
                                                                   count: 3)
        twoThreeItemGroup.interItemSpacing = .fixed(itemSpacing)

        // 各グループを縦に並べたグループ
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
        return section
    }

    /// 縦長の長方形が１つだけのセクション
    private func verticalRectangleSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let verticalRectangleHeight = collectionViewBounds.height * 0.7
        let verticalRectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(1.0)))
        let verticalRectangleGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                         heightDimension: .absolute(verticalRectangleHeight)),
                                                                      subitem: verticalRectangleItem,
                                                                      count: 1)
        return NSCollectionLayoutSection(group: verticalRectangleGroup)
    }

    /// 縦長の長方形が横スクロールするセクション（ヘッダー付き）
    private func rectangleHorizonContinuousWithHeaderSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let headerHeight = CGFloat(50)
        let headerElementKind = "header-element-kind"
        let insetSpacing = CGFloat(5) // groupとsectionの間隔調整用
        let rectangleItemWidth = collectionViewBounds.width * 0.9 / 3
        let rectangleItemHeight = rectangleItemWidth * (4/3)
        let rectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                      heightDimension: .fractionalHeight(1.0)))
        let horizonRectangleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(rectangleItemWidth),
                                                                                                          heightDimension: .absolute(rectangleItemHeight)),
                                                                       subitem: rectangleItem,
                                                                       count: 1)
        horizonRectangleGroup.contentInsets = NSDirectionalEdgeInsets(top: insetSpacing, leading: insetSpacing, bottom: insetSpacing, trailing: insetSpacing)
        let horizonRectangleContinuousSection = NSCollectionLayoutSection(group: horizonRectangleGroup)
        let sectionHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(headerHeight)),
            elementKind: headerElementKind,
            alignment: .top)
        sectionHeaderItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insetSpacing, bottom: 0, trailing: insetSpacing)
        horizonRectangleContinuousSection.boundarySupplementaryItems = [sectionHeaderItem] // セクションに対してヘッダーを付与
        horizonRectangleContinuousSection.orthogonalScrollingBehavior = .continuous // セクションに対して横スクロール属性を付与
        horizonRectangleContinuousSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insetSpacing, bottom: 0, trailing: insetSpacing)
        return horizonRectangleContinuousSection
    }

    /// 正方形が1つだけのセクション（ヘッダー付き）
    private func squareWithHeaderSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemLength = collectionViewBounds.width
        let headerHeight = CGFloat(50)
        let headerInsetSpacing = CGFloat(10)
        let headerElementKind = "header-element-kind"
        let squareItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let squareGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .absolute(itemLength)),
                                                           subitem: squareItem,
                                                           count: 1)
        let squareSection = NSCollectionLayoutSection(group: squareGroup)
        let sectionHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(headerHeight)),
            elementKind: headerElementKind,
            alignment: .top)
        sectionHeaderItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: headerInsetSpacing, bottom: headerInsetSpacing, trailing: 0)
        squareSection.boundarySupplementaryItems = [sectionHeaderItem]
        return squareSection
    }
}
