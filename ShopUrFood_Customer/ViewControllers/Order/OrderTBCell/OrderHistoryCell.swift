//
//  OrderHistoryCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class OrderHistoryCell: UITableViewCell {

    @IBOutlet weak var trackBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var reOrderBtn: UIButton!
    @IBOutlet weak var TotalAmtValueLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderOnLbl: UILabel!
    @IBOutlet weak var invoiceBtn: UIButton!
    @IBOutlet weak var orderIdValueLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackBtn.layer.cornerRadius = 14.0
        trackBtn.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
