//
//  OrderStatusViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple5 on 01/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class OrderStatusViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var boyImageView: UIImageView!
    @IBOutlet weak var foodReachedLbl: UILabel!
    @IBOutlet weak var enjoyTheFoodLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
     @IBOutlet weak var totalAmountToPay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 8.0
        homeBtn.layer.cornerRadius = 2 //15
        self.foodReachedLbl.text = LanguageDictonary.value(forKey: "foodreached") as? String
         self.enjoyTheFoodLbl.text = LanguageDictonary.value(forKey: "enjoyfood") as? String
        self.homeBtn.setTitle(LanguageDictonary.value(forKey: "home") as? String, for: .normal)
        // Do any additional setup after loading the view.
        totalAmountToPay.isHidden = true
        let needtopay = LanguageDictonary.value(forKey: "needtopay") as! String
    totalAmountToPay.text = String(format: "\(needtopay) : %@", AmountStringToShowForCustomer)
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.checkRootView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
