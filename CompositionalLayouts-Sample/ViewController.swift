//
//  ViewController.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/02.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case main
    }

    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func createLayout() -> UICollectionViewLayout {
        let 外枠からの横幅: CGFloat = 18
        let セル間の横幅: CGFloat = 8
        let グループ間の縦幅: CGFloat = 8
        let CVの横幅: CGFloat = view.bounds.width
        let 小さい方の四角形の横幅: CGFloat = (CVの横幅 - (外枠からの横幅 * 2 + セル間の横幅 * 2)) / 3
        let 大きい方の四角形の横幅: CGFloat = 小さい方の四角形の横幅 * 2 + セル間の横幅
        let 大きい四角形側のグループの高さ: CGFloat = 大きい方の四角形の横幅 + グループ間の縦幅
        let 小さい四角形側のグループの高さ: CGFloat = 小さい方の四角形の横幅 + グループ間の縦幅

        let sections = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            // グループ1
            let 小2中1のグループ: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(小さい方の四角形の横幅 + セル間の横幅)))
                smallSquareItem.contentInsets = NSDirectionalEdgeInsets(top: グループ間の縦幅, leading: 0, bottom: 0, trailing: セル間の横幅)
                let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(小さい方の四角形の横幅 + セル間の横幅),
                                                      heightDimension: .fractionalHeight(1.0)),
                    subitem: smallSquareItem, count: 2)

                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(大きい方の四角形の横幅),
                                                      heightDimension: .fractionalHeight(1.0)))
                mediumSquareItem.contentInsets = NSDirectionalEdgeInsets(top: グループ間の縦幅, leading: 0, bottom: 0, trailing: 0)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(大きい四角形側のグループの高さ)),
                    subitems: [smallSquareGroup, mediumSquareItem])
                return nestedGroup
            }()

            // グループ2
            let 中1小2のグループ: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(大きい方の四角形の横幅 + セル間の横幅),
                                                      heightDimension: .fractionalHeight(1.0)))
                mediumSquareItem.contentInsets = NSDirectionalEdgeInsets(top: グループ間の縦幅, leading: 0, bottom: 0, trailing: セル間の横幅)

                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(小さい方の四角形の横幅 + セル間の横幅)))
                smallSquareItem.contentInsets = NSDirectionalEdgeInsets(top: グループ間の縦幅, leading: 0, bottom: 0, trailing: 0)
                let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(小さい方の四角形の横幅),
                                                      heightDimension: .fractionalHeight(1.0)),
                    subitem: smallSquareItem, count: 2)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(大きい四角形側のグループの高さ)),
                    subitems: [mediumSquareItem, smallSquareGroup])
                return nestedGroup
            }()

            // グループ3
            let 小3のグループ: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(小さい方の四角形の横幅),
                                                      heightDimension: .fractionalHeight(1.0)))

                let smallSquareGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(小さい四角形側のグループの高さ)),
                    subitem: smallSquareItem,
                    count: 3)
                smallSquareGroup.interItemSpacing = .fixed(セル間の横幅)
                smallSquareGroup.contentInsets = NSDirectionalEdgeInsets(top: グループ間の縦幅, leading: 0, bottom: 0, trailing: 0)

                return smallSquareGroup
            }()

            // グループの集合体
            let groups = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(大きい四角形側のグループの高さ * 2 + 小さい四角形側のグループの高さ * 2)),
            subitems: [小2中1のグループ, 小3のグループ, 中1小2のグループ, 小3のグループ])

            // セクション
            let section = NSCollectionLayoutSection(group: groups)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 外枠からの横幅, bottom: 0, trailing: 外枠からの横幅)
            return section

        }
        return sections
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = .red
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
           print("didUnhighlightItemAt")
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = .blue
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 27
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .main:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
            cell.update(text: "\(indexPath.section), \(indexPath.row)")
            return cell
        }
    }
}
