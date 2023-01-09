//
//  CartHeaderCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 25/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class CartHeaderCell: UITableViewCell {

    @IBOutlet weak var preOrderLbl: UILabel!
    @IBOutlet weak var preOrderImg: UIImageView!
    @IBOutlet weak var preOrderBtn: UIButton!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var closePreOrderBtn: UIButton!

    @IBOutlet weak var closePreOrderButtonWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
