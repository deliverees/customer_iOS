//
//  RewardedHistoryCell.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 13/08/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class RewardedHistoryCell: UITableViewCell {

    @IBOutlet weak var BaseView: UIView!
    @IBOutlet weak var rewardedAmountLbl: UILabel!
    @IBOutlet weak var pointsEarnedLbl: UILabel!
    @IBOutlet weak var actionedOnLbl: UILabel!

    @IBOutlet weak var actionOnStaticLbl: UILabel!
    @IBOutlet weak var ernStaticLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
