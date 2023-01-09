//
//  AllReviewsTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 28/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class AllReviewsTableViewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var ratingStar: UIImageView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var reviewMsgLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImg.layer.cornerRadius = 35.0
        userImg.clipsToBounds = true
        baseView.layer.cornerRadius = 5.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
