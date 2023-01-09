//
//  PaymentDetailFirstCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class PaymentDetailFirstCell: UITableViewCell {

    @IBOutlet weak var clientIdTxt: UITextField!
   
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var baseContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        secondView.layer.borderWidth = 0.5
        secondView.layer.borderColor = UIColor.lightGray.cgColor
        secondView.cornerRadius = 5.0
        baseContentView.layer.cornerRadius = 5.0
        baseContentView.backgroundColor = UIColor.white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
