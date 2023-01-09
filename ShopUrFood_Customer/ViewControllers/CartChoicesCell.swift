//
//  CartChoicesCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class CartChoicesCell: UITableViewCell {

    @IBOutlet weak var toppingPriceLbl: UILabel!
    @IBOutlet weak var toppingNameLbl: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
