//
//  Invoice_price_TBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 06/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class Invoice_price_TBCell: UITableViewCell {

    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalTitleLbl: UILabel!
    @IBOutlet weak var deliveryFeeValueLbl: UILabel!
    @IBOutlet weak var deliveryTitleLbl: UILabel!
    @IBOutlet weak var subTotalValueLbl: UILabel!
    @IBOutlet weak var subTotal_titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
