//
//  ViewController.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/02.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 表示中のレイアウト
    private var layoutType: LayoutType = .none {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                // setされる度に更新をかける
                self.collectionView.collectionViewLayout = self.layoutType.layout(collectionViewBounds: self.collectionView.bounds)
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    @IBOutlet weak private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CollectionViewCell.nib(),
                                    forCellWithReuseIdentifier: CollectionViewCell.identifier)
            collectionView.register(CollectionViewHeader.nib(),
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: CollectionViewHeader.identifier)
//            collectionView.dataSource = self
            // bottomのsafeAreaを外す場合
            //            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    // MEMO: collectionViewにsetした時点で監視されるため、開放等は行わない
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutType = .grid
        setupDataSource()
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { [unowned self] (collectionView, indexPath, title) -> UICollectionViewCell? in
            guard let sessionType = SectionType(rawValue: indexPath.section, type: self.layoutType) else {
                return nil
            }
            // カスタムセルの選択（のちのスケールを考慮）
            switch sessionType {
            case .grid, .largeAndSmallSquare,
                 .verticalRectangle, .squareWithHeader,
                 .verticalRectangleHorizonContinuousWithHeader:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                              for: indexPath) as! CollectionViewCell
                cell.update(text: "\(title)")
                return cell
            }
        }

        // ヘッダー等のItemの設定
        dataSource.supplementaryViewProvider =  { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let sessionType = SectionType(rawValue: indexPath.section, type: self.layoutType) else {
                return nil
            }
            let headerKindString = UICollectionView.elementKindSectionHeader
            switch (kind, sessionType) {
            case (headerKindString, .squareWithHeader),
                 (headerKindString, .verticalRectangleHorizonContinuousWithHeader):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: headerKindString,
                                                                             withReuseIdentifier: CollectionViewHeader.identifier,
                                                                             for: indexPath) as! CollectionViewHeader
                header.setTitle("\(indexPath.section)")
                return header
            default: return nil
            }
        }

        // リソースのセット
        var resource = NSDiffableDataSourceSnapshot<Int, String>()
        let sectionArray = layoutType.sectionArray
        resource.appendSections(sectionArray)
        let stringsArray = sectionArray.map { layoutType.items(section: $0) }
        stringsArray.forEach { resource.appendItems($0) }

        // リソースの反映
        dataSource.apply(resource, animatingDifferences: true)
    }
}
