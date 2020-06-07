//
//  CustomTableViewCell.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 06/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreLabel: UILabel!    
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var heroeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

