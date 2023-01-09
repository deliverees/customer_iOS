//
//  WalletTBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 12/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class WalletTBCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
