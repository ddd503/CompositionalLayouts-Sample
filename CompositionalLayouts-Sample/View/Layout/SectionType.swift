//
//  SectionType.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/18.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

// NSCollectionLayoutSection毎の種別
enum SectionType {
    case grid // グリッド表示されるセッション
    case largeAndSmallSquare // 大小2種類の正方形で構成されるセッション
    case verticalRectangle // 縦の長方形１つのみのセッション
    case verticalRectangleHorizonContinuousWithHeader // 縦の長方形が横スクロールで流れていくセッション（ヘッダー付き）
    case squareWithHeader // 正方形が1つのみのセッション（ヘッダー付き）

    init?(rawValue: Int, type: LayoutType) {
        switch (rawValue, type) {
        case (0, .grid):
            self = .grid
        case (0, .insta):
            self = .largeAndSmallSquare
        case (0, .netflix):
            self = .verticalRectangle
        case (1, .netflix):
            self = .verticalRectangleHorizonContinuousWithHeader
        case (2, .netflix):
            self = .verticalRectangleHorizonContinuousWithHeader
        case (3, .netflix):
            self = .squareWithHeader
        default: return nil
        }
    }
}
