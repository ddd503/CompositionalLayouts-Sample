//
//  SingleViewCell.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/19.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

class SingleViewCell: UICollectionViewCell {

    @IBOutlet weak private var backgroundImageView: UIImageView!
    @IBOutlet weak private var centerImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func setInfo(backgroundImage: UIImage?, centerImage: UIImage?, title: String) {
        backgroundImageView.image = backgroundImage
        centerImageView.image = centerImage
        titleLabel.text = title
    }
}
