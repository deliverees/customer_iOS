//
//  WorkingHoursTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class WorkingHoursTableViewCell: UITableViewCell {

    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var closeTimeValueLbl: UILabel!
    @IBOutlet weak var openTimeValueLbl: UILabel!
    @IBOutlet weak var closeTimeLbl: UILabel!
    @IBOutlet weak var openTimeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var leftGrayView: UIView!
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
