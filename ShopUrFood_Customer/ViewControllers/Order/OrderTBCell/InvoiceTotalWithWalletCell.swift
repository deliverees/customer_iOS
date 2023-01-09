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

    
    @IBOutlet weak var walletLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var walletAmtLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var walletLblTopHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var walletAmtLblTopHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var offerLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offerAmtLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offerLblTopHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offerAmtLblTopHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var taxLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var taxAmtLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var taxLblTopHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var taxAmtLblTopHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var cancelLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var cancelAmtLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var cancelLblTopHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var cancelAmtLblTopHeightConstraints: NSLayoutConstraint!

    
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
