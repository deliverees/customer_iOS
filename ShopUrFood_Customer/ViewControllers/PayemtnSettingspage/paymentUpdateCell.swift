//
//  paymentUpdateCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class paymentUpdateCell: UITableViewCell {

    @IBOutlet weak var updateBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        updateBtn.layer.cornerRadius = 20.0
        updateBtn.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
