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
    @IBOutlet private weak var imageView: UIImageView!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func setInfo(title: String, image: UIImage?) {
        label.text = title
        imageView.image = image
    }

}
