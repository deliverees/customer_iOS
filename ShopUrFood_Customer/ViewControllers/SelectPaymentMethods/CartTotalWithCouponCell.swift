//
//  CartTotalWithCouponCell.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 24/08/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class CartTotalWithCouponCell: UITableViewCell {

    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var subTotalAmtLbl: UILabel!
    @IBOutlet weak var deliveryAmtlbl: UILabel!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var peakHoursFeeBtn: UIButton!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var couponAmtLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var taxValueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
