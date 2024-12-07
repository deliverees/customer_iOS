//
//  InvoiceTotalWithWalletCell.swift
//  ShopUrFood_Customer
//
//  Created by Dinesh on 29/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class InvoiceTotalWithWalletCell: UITableViewCell {
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var subTotalAmtLbl: UILabel!
    @IBOutlet weak var deliveryAmtlbl: UILabel!
    @IBOutlet weak var walletAmtLbl: UILabel!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var walletLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var offerUsedLbl: UILabel!
    @IBOutlet weak var offerUsedAmountLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var taxAmountLbl: UILabel!
    @IBOutlet weak var cancelledLbl: UILabel!
    @IBOutlet weak var cancelledAmountLbl: UILabel!
    @IBOutlet weak var managmenetFeeLbl: UILabel!
    @IBOutlet weak var managementFeeAmountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        totalView.layer.borderWidth = 0.2
        totalView.layer.cornerRadius = 5.0
        totalView.layer.borderColor = AppLightOrange.cgColor
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
