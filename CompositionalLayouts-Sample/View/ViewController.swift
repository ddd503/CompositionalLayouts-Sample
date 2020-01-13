//
//  ViewController.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/02.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CollectionViewCell.nib(),
                                    forCellWithReuseIdentifier: CollectionViewCell.identifier)
            collectionView.dataSource = self
            // bottomのsafeAreaを外す場合
//            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayoutType(type: .insta)
    }

    func setLayoutType(type: LayoutType) {
        collectionView.collectionViewLayout = type.layout(collectionViewBounds: collectionView.bounds)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 27
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                      for: indexPath) as! CollectionViewCell
        cell.update(text: "\(indexPath.section), \(indexPath.row)")
        return cell
    }
}
