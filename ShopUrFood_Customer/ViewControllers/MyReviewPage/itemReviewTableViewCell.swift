//
//  itemReviewTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 25/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class itemReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var startThree: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var foodImg: UIImageView!
    
    @IBOutlet weak var msgLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foodImg.layer.cornerRadius = 5.0
        foodImg.clipsToBounds = true
        foodImg.layer.borderWidth = 0.3
        foodImg.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
