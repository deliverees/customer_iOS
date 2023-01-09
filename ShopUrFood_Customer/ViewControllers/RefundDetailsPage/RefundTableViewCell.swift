//
//  RefundTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 26/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class RefundTableViewCell: UITableViewCell {

    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var cancelTypeValueLbl: UILabel!
    @IBOutlet weak var itemAmtValueLbl: UILabel!
    @IBOutlet weak var itemNameValuelbl: UILabel!
    @IBOutlet weak var cancelTypelbl: UILabel!
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var orderIDValueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
