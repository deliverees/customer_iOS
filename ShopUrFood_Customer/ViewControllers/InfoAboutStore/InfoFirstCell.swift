//
//  InfoFirstCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 28/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class InfoFirstCell: UITableViewCell {

    @IBOutlet weak var workingHoursBtn: UIButton!
    @IBOutlet weak var reviewStatusLbl: UILabel!
    @IBOutlet weak var reviewTitleLbl: UILabel!
    @IBOutlet weak var refundValueLbl: UILabel!
    @IBOutlet weak var refundTitleLbl: UILabel!
    @IBOutlet weak var cacellationValueLbl: UILabel!
    @IBOutlet weak var cancellationPolicyLbl: UILabel!
    @IBOutlet weak var preOrderValueLbl: UILabel!
    @IBOutlet weak var preOrderTitleLbl: UILabel!
    @IBOutlet weak var descriptionValueLbl: UILabel!
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var restaurantTitleLbl: UILabel!
    @IBOutlet weak var cancelStatusLbl: UILabel!
    @IBOutlet weak var cancelStatusResultLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
