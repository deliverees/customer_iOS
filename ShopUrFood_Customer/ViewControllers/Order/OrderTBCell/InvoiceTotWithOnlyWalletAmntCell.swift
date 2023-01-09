//
//  InvoiceTotWithOnlyWalletAmntCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 04/09/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class InvoiceTotWithOnlyWalletAmntCell: UITableViewCell {
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var subTotalAmtLbl: UILabel!
    @IBOutlet weak var deliveryAmtlbl: UILabel!
    @IBOutlet weak var walletAmtLbl: UILabel!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var walletLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
