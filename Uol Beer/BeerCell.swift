//
//  BeerCell.swift
//  Uol Beer
//
//  Created by Jaber Vieira Da Silva Shamali on 20/11/19.
//  Copyright © 2019 Jaber Vieira Da Silva Shamali. All rights reserved.
//

import UIKit

class BeerCell: UITableViewCell {

    @IBOutlet weak var nameBeer: UILabel!
    @IBOutlet weak var teorBeer: UILabel!
    @IBOutlet weak var imgBeer: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
