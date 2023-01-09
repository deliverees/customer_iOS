//
//  SideBarTileCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 22/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class SideBarTileCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var dotImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
