//
//  RestaurantListTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 17/07/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class RestaurantListTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantSelectedButtons: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
