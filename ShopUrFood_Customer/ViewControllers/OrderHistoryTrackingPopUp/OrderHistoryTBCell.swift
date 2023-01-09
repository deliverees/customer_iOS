//
//  OrderHistoryTBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 29/05/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class OrderHistoryTBCell: UITableViewCell {

    @IBOutlet weak var trackbtn: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        trackbtn.layer.cornerRadius = 15.0
        trackbtn.clipsToBounds = true
        // Initialization code
    }

    

}
