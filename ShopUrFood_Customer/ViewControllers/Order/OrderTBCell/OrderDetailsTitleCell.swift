//
//  OrderDetailsTitleCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 04/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class OrderDetailsTitleCell: UITableViewCell {

    @IBOutlet weak var addStoreReviewBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var trackBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var order_Cancel: UIButton!

    @IBOutlet weak var order_close: UIButton!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var status_titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var orderedFoodImg: UIImageView!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var dateValueLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
