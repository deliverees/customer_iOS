//
//  StripePaymentCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 18/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Stripe

class StripePaymentCell: UITableViewCell, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        cardTextField.postalCodeEntryEnabled = false
        cardTextField.postalCode = ""
        cardTextField.delegate = self
        return cardTextField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        creditCardView.layer.cornerRadius = 3.0
        creditCardView.layer.borderWidth = 0.3
        creditCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        cardTextField.translatesAutoresizingMaskIntoConstraints = false
        creditCardView.addSubview(cardTextField)
        NSLayoutConstraint.activate([
            cardTextField.topAnchor.constraint(equalTo: creditCardView.topAnchor),
            cardTextField.leadingAnchor.constraint(equalTo: creditCardView.leadingAnchor),
            cardTextField.trailingAnchor.constraint(equalTo: creditCardView.trailingAnchor),
            cardTextField.bottomAnchor.constraint(equalTo: creditCardView.bottomAnchor)
            ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        if textField.isValid {
            textField.resignFirstResponder()
        }
    }
}
