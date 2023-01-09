//
//  SideBarMidCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class SideBarMidCell: UITableViewCell {

    @IBOutlet weak var fav_dotImg: UIImageView!
    @IBOutlet weak var fav_Icon: UIImageView!
    @IBOutlet weak var favLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
