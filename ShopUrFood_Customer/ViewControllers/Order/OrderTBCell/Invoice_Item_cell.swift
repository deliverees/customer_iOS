//
//  Invoice_Item_cell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 06/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class Invoice_Item_cell: UITableViewCell {

    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var qtyButton: UIButton!

    @IBOutlet weak var foodPriceLbl: UILabel!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var food_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
}
