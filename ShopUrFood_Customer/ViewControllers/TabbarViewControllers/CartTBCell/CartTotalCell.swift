//
//  CartTotalCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 26/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class CartTotalCell: UITableViewCell {

    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var deliveryFeeValueLbl: UILabel!
    @IBOutlet weak var subTotalValueLbl: UILabel!
    @IBOutlet weak var deliveryFeeLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var peakHoursFeeBtn: UIButton!
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
