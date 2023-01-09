//
//  CartTotalWithWalletCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 19/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class CartTotalWithWalletCell: UITableViewCell {

    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var subTotalAmtLbl: UILabel!
    @IBOutlet weak var deliveryAmtlbl: UILabel!
    @IBOutlet weak var walletAmtLbl: UILabel!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var walletLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var peakHoursFeeBtn: UIButton!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var offerAmtLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var taxValueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        totalView.layer.borderWidth = 0.2
        totalView.layer.cornerRadius = 5.0
        totalView.layer.borderColor = AppLightOrange.cgColor
        checkOutBtn.layer.cornerRadius = 20.0
        checkOutBtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
