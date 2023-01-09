//
//  OrderReviewTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 25/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class OrderReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var reviewMsgLbl: UILabel!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
