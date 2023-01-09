//
//  filterViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 28/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup
class filterViewController: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    @IBOutlet weak var bypriceLbl: UILabel!
    @IBOutlet weak var bynameLbl: UILabel!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var lowHightBtn: UIButton!
    @IBOutlet weak var hightLowBtn: UIButton!
    @IBOutlet weak var ZABtn: UIButton!
    @IBOutlet weak var AZBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.bynameLbl.text = LanguageDictonary.value(forKey: "byname") as? String
        self.bypriceLbl.text = LanguageDictonary.value(forKey: "byprice") as? String
        self.filterLbl.text = LanguageDictonary.value(forKey: "filter") as? String
        self.AZBtn.setTitle(LanguageDictonary.value(forKey: "acendingorder") as? String, for: .normal)
          self.ZABtn.setTitle(LanguageDictonary.value(forKey: "decendingorder") as? String, for: .normal)
          self.lowHightBtn.setTitle(LanguageDictonary.value(forKey: "lowtohigh") as? String, for: .normal)
          self.hightLowBtn.setTitle(LanguageDictonary.value(forKey: "hightolow") as? String, for: .normal)
        
        if sortByStr == "2"{
            AZBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "3"{
            ZABtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "4"{
            lowHightBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "5"{
            hightLowBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func HighLowBtnAction(_ sender: Any) {
        sortByStr = "5"
        AZBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        ZABtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func lowHightBtnAction(_ sender: Any) {
        sortByStr = "4"
        AZBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        ZABtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ZABtnAction(_ sender: Any) {
        sortByStr = "3"
        AZBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        ZABtn.setImage(UIImage(named: "select_radio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func AZBtnAction(_ sender: Any) {
        sortByStr = "2"
        AZBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        ZABtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(278)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
   
}
