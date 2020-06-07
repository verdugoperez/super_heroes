//
//  CustomCollectionViewCell.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 06/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var heroeImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    
  override func awakeFromNib() {
        super.awakeFromNib()
       heroeImageView.makeRounded()
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
