//
//  MyOffersTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 16/08/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class MyOffersTableViewCell: UITableViewCell {

    @IBOutlet weak var BaseView: UIView!
    @IBOutlet weak var toptxtLbl: UILabel!
    @IBOutlet weak var SlashDownLbl: UILabel!
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var expiredOnLbl: UILabel!
    @IBOutlet weak var offerAmountLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!

    @IBOutlet weak var statusStaticLbl: UILabel!
    @IBOutlet weak var offerAmountStaticLbl: UILabel!
    @IBOutlet weak var expiresONStaticLbl: UILabel!
    @IBOutlet weak var orderIDLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var orderIDLblLineHeightConstraints: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
