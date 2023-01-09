//
//  sideBarTopCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class sideBarTopCell: UITableViewCell {

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var bgImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
