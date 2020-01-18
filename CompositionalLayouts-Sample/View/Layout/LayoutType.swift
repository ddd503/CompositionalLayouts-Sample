//
//  LayoutType.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/06.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

enum LayoutType {
    case none // 適用レイアウトなしの状態
    case grid // グリッド形式での表示（3 * n）
    case insta // Instagramの検索画面
    case netflix // Netflixのトップ(動画一覧)画面

    // 各レイアウト毎の表示セクション順（本来はデータソースの数で決めるので、データソースが複数ある場合のみ必要）
    var sectionArray: [Int] {
        switch self {
        case .none:
            return []
        case .grid, .insta:
            return [0]
        case .netflix:
            return [0, 1, 2, 3]
        }
    }

    // 各レイアウト毎、セッション別に表示するitemの情報を返す（今回は画像のタイトルのみなので[String]）
    func items(section: Int) -> [String] {
        let australiaPhotoTitles = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let guamPhotoTitles = ["10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]
        let allPhotoTitles = australiaPhotoTitles + guamPhotoTitles

        switch self {
        case .none:
            return []
        case .grid:
            return allPhotoTitles
        case .insta:
            return allPhotoTitles
        case .netflix:
            switch section {
            case 0:
                return ["leaf"]
            case 1:
                return australiaPhotoTitles
            case 2:
                return guamPhotoTitles
            case 3:
                return ["cat"]
            default:
                return []
            }
        }
    }

    func layout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        switch self {
        case .none:
            return UICollectionViewLayout()
        case .grid:
            return UICollectionViewCompositionalLayout(section: SectionType.grid.gridSection(collectionViewBounds: collectionViewBounds))
        case .insta:
            return UICollectionViewCompositionalLayout(section: SectionType.largeAndSmallSquare.section(collectionViewBounds: collectionViewBounds))
        case .netflix:
            return netFlixLayout(collectionViewBounds: collectionViewBounds)
        }
    }

    func netFlixLayout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            let sectionType = SectionType(section: section, type: .netflix)!
            return sectionType.section(collectionViewBounds: collectionViewBounds)
        }
        return layout
    }
}
