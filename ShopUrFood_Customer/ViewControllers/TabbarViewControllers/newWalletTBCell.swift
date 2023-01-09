//
//  newWalletTBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 30/05/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class newWalletTBCell: UITableViewCell {

    @IBOutlet weak var thirdValueLbl: UILabel!
    @IBOutlet weak var secondValueLbl: UILabel!
    @IBOutlet weak var firstValueLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var baesCiew: UIView!
    
    @IBOutlet weak var thirdLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var thirdValueLblHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var thirdLblBottomHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var thirdValueLblBottomHeightConstraints: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baesCiew.layer.borderWidth  = 0.3
        baesCiew.layer.borderColor = UIColor.lightGray.cgColor
        baesCiew.cornerRadius = 10.0
        baesCiew.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
