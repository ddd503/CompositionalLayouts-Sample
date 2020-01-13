//
//  CollectionViewCell.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/05.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func update(text: String) {
        label.text = text
    }

}
