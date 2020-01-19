//
//  ViewController.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/02.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var segmentedControl: UISegmentedControl! {
        didSet {
            // タイトルの色とフォントサイズの指定
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        }
    }

    // MEMO: IB側で定義するとなぜかレイアウト生成後のスクロールoffsetがbottomになってしまう
    private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
            collectionView.register(SingleViewCell.nib(), forCellWithReuseIdentifier: SingleViewCell.identifier)
            collectionView.register(CollectionViewHeader.nib(),
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: CollectionViewHeader.identifier)
            //             bottomのsafeAreaを外す場合
            //                        collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    // MEMO: collectionViewにsetした時点で監視されるため、開放等は行わない
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>! = nil

    // 表示中のレイアウト
    private var layoutType: LayoutType = .none {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // setされる度に更新をかける（レイアウト毎変える場合は、レイアウト、データソースの順で更新する）
                self.setupCollectionView()
                self.setupDataSource()
                self.collectionView.collectionViewLayout = self.layoutType.layout(collectionViewBounds: self.collectionView.bounds)
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.backgroundColor = self.layoutType.backgroundColor
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期レイアウトを指定
        layoutType = LayoutType(rawValue: segmentedControl.selectedSegmentIndex)!
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: layoutType.layout(collectionViewBounds: view.bounds))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // 回転時の可変対応(今回は回転がないので不要)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        view.bringSubviewToFront(segmentedControl)
    }

    // CollectionViewとDataSourceを関連付ける
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { [unowned self] (collectionView, indexPath, title) -> UICollectionViewCell? in
            guard let sessionType = SectionType(section: indexPath.section, type: self.layoutType) else {
                fatalError("invalid SectionType")
            }
            // カスタムセルの選択（のちのスケールを考慮）
            switch sessionType {
            case .grid, .largeAndSmallSquare,
                 .squareWithHeader, .rectangleHorizonContinuousWithHeader:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                              for: indexPath) as! CollectionViewCell
                cell.setInfo(title: "\(title)", image: UIImage(named: title))
                return cell
            case .verticalRectangle:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleViewCell.identifier,
                                                              for: indexPath) as! SingleViewCell
                let image = UIImage(named: title)
                cell.setInfo(backgroundImage: image, centerImage: image, title: title)
                return cell
            }
        }

        // ヘッダー等のItemの設定
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let sessionType = SectionType(section: indexPath.section, type: self.layoutType) else {
                return nil
            }
            let headerKindString = "header-element-kind"
            switch (kind, sessionType) {
            case (headerKindString, .squareWithHeader),
                 (headerKindString, .rectangleHorizonContinuousWithHeader):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: CollectionViewHeader.identifier,
                                                                             for: indexPath) as! CollectionViewHeader
                header.setTitle(sessionType.sectionTitle(section: indexPath.section, type: self.layoutType))
                return header
            default: return nil
            }
        }
        // リソースのセット
        var resource = NSDiffableDataSourceSnapshot<Int, String>()
        let sectionArray = layoutType.sectionArray
        // Memo: Sectionセット → Itemセットを交互にしないとデータソースが組み上がらない（Section全てappend、Item全てappendしたら最後のSectionにItem全て入る）
        sectionArray.forEach {
            resource.appendSections([$0])
            resource.appendItems(layoutType.items(section: $0))
        }
        // リソースの反映
        dataSource.apply(resource, animatingDifferences: false)
    }

    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        guard let layoutType = LayoutType(rawValue: sender.selectedSegmentIndex) else { return }
        self.layoutType = layoutType
    }

}
