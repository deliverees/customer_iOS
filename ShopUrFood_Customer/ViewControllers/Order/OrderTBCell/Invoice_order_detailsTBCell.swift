//
//  Invoice_order_detailsTBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 06/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class Invoice_order_detailsTBCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var paymentValueLbl: UILabel!
    @IBOutlet weak var payment_titleLbl: UILabel!
    @IBOutlet weak var orderDate_valueLbl: UILabel!
    @IBOutlet weak var orderDate_titleLbl: UILabel!
    @IBOutlet weak var orderNumberValueLbl: UILabel!
    @IBOutlet weak var orderNumber_titleLbl: UILabel!
    @IBOutlet weak var orderTitleLbl: UILabel!
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var orderTypeValueLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var paymentStatusValueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
