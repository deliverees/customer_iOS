//
//  OrderDetailsCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 04/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var order_close: UIButton!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var status_titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var orderedFoodImg: UIImageView!
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func orderCancelAction(_ sender: Any) {
        print("Btn Tapped")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
