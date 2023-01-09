//
//  InfoReviewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 28/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class InfoReviewCell: UITableViewCell {

    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var starReview: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingsLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
