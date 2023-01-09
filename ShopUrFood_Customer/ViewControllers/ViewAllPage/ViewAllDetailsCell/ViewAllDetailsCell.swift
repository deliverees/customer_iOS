//
//  ViewAllDetailsCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 14/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ViewAllDetailsCell: UITableViewCell {

    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var startRating: UIImageView!
    @IBOutlet weak var reviewRatingImageView: UIImageView!

    @IBOutlet weak var closedTransperantView: UIView!
    @IBOutlet weak var closedLbl: UILabel!
    @IBOutlet weak var ratingsLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var offerPercentLbl: UILabel!

    @IBOutlet weak var deliBoyImageView: UIImageView!
    @IBOutlet weak var offerPercentImageView: UIImageView!

    @IBOutlet weak var openTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var food_imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
