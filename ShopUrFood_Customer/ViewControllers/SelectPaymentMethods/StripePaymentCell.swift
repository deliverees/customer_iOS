//
//  StripePaymentCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 18/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class StripePaymentCell: UITableViewCell {

    @IBOutlet weak var cvvTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var ExpDateBtn: UIButton!
    @IBOutlet weak var cvvView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    @IBOutlet weak var creditCardNumberTxt: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        creditCardView.layer.cornerRadius = 3.0
        creditCardView.layer.borderWidth = 0.3
        creditCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        calendarView.layer.cornerRadius = 3.0
        calendarView.layer.borderWidth = 0.3
        calendarView.layer.borderColor = UIColor.lightGray.cgColor
        
        cvvView.layer.cornerRadius = 3.0
        cvvView.layer.borderWidth = 0.3
        cvvView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
