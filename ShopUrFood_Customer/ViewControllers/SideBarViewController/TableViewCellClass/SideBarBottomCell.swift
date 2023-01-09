//
//  SideBarBottomCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class SideBarBottomCell: UITableViewCell {
    @IBOutlet weak var dotImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
