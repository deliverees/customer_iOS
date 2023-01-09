//
//  FavouriteTBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 07/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class FavouriteTBCell: UITableViewCell {

    @IBOutlet weak var disLikeBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var mainPriceLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var food_nameLbl: UILabel!
    @IBOutlet weak var food_image: UIImageView!
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        food_image.layer.borderWidth = 0.5
        food_image.layer.borderColor = UIColor.lightGray.cgColor
        food_image.layer.cornerRadius = 5.0
        food_image.clipsToBounds = true
    }

}
