//
//  CollectionViewHeader.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/18.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {

    @IBOutlet weak private var titleLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
}
