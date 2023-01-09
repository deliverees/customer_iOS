//
//  PaymentDetailsSecondCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class PaymentDetailsSecondCell: UITableViewCell {

    @IBOutlet weak var ifscCodeTxt: UITextField!
    @IBOutlet weak var branchNameTxt: UITextField!
    @IBOutlet weak var bankNameTxt: UITextField!
    @IBOutlet weak var accountNumberTxt: UITextField!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var baseContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        firstView.layer.borderWidth = 0.5
        firstView.layer.borderColor = UIColor.lightGray.cgColor
        firstView.cornerRadius = 5.0
        
        secondView.layer.borderWidth = 0.5
        secondView.layer.borderColor = UIColor.lightGray.cgColor
        secondView.cornerRadius = 5.0
        
        thirdView.layer.borderWidth = 0.5
        thirdView.layer.borderColor = UIColor.lightGray.cgColor
        thirdView.cornerRadius = 5.0
        
        fourView.layer.borderWidth = 0.5
        fourView.layer.borderColor = UIColor.lightGray.cgColor
        fourView.cornerRadius = 5.0
        baseContentView.layer.cornerRadius = 5.0
        baseContentView.backgroundColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
