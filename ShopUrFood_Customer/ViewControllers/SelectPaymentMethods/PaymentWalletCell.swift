//
//  PaymentWalletCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 19/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class PaymentWalletCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var walletAmtLbl: UILabel!
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
