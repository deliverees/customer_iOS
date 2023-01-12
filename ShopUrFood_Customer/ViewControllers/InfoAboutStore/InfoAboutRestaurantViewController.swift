//
//  InfoAboutRestaurantViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 27/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup

class InfoAboutRestaurantViewController: BottomPopupViewController,UITableViewDelegate,UITableViewDataSource {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var ResultData = NSMutableDictionary()

    @IBOutlet weak var infoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        infoTable.dataSource = self
        infoTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override var popupHeight : CGFloat {
        return height ?? CGFloat(278)
    }
    
    override var popupTopCornerRadius: CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override var popupPresentDuration : Double {
        return presentDuration ?? 1.0
    }
    
    override var popupDismissDuration : Double {
        return dismissDuration ?? 1.0
    }
    
    override var popupShouldDismissInteractivelty : Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return (ResultData.object(forKey: "restaurant_review")as! NSArray).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoFirstCell") as? InfoFirstCell
            cell?.selectionStyle = .none
            
            cell?.descriptionTitleLbl.text = LanguageDictonary.value(forKey: "description") as? String
             cell?.preOrderTitleLbl.text = LanguageDictonary.value(forKey: "preorder") as? String
             cell?.cancellationPolicyLbl.text = LanguageDictonary.value(forKey: "cancellationpolicy") as? String
             cell?.cancelStatusLbl.text = LanguageDictonary.value(forKey: "cancelstatus") as? String
             cell?.refundTitleLbl.text = LanguageDictonary.value(forKey: "refundstatus") as? String
             cell?.reviewTitleLbl.text = LanguageDictonary.value(forKey: "reviews") as? String
          
            
            
            cell?.restaurantTitleLbl.text = ((ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "restaurant_name")as! String)
            cell?.descriptionValueLbl.text = ((ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "restaurant_desc")as! String)
            if (ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "pre_order")as! String == "Yes"{
                 cell?.preOrderValueLbl.text = LanguageDictonary.value(forKey: "preorderavailable") as? String
            }else{
                cell?.preOrderValueLbl.text = LanguageDictonary.value(forKey: "preorderunavailable") as? String
            }
            if (ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "refund_status")as! String == "Yes"{
                cell?.refundValueLbl.text = LanguageDictonary.value(forKey: "refundavailable") as? String
            }else{
                cell?.preOrderValueLbl.text = LanguageDictonary.value(forKey: "refundunavailable") as? String
            }
            cell?.cacellationValueLbl.text = ((ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "cancellation_policy")as? String) ?? ""
            if (ResultData.object(forKey: "restaurant_review")as! NSArray).count == 0{
                cell?.reviewStatusLbl.text = LanguageDictonary.value(forKey: "notyetupdate") as? String
            }else{
                let count = (ResultData.object(forKey: "restaurant_review")as! NSArray).count
                cell?.reviewStatusLbl.text = "\(count) \(LanguageDictonary.value(forKey: "review") as! String)"
            }
            
            if (ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "cancel_status")as! String == "Yes"{
                cell?.cancelStatusResultLbl.text = LanguageDictonary.value(forKey: "cancelavailable") as? String
            }else{
                cell?.cancelStatusResultLbl.text = LanguageDictonary.value(forKey: "cancelunavailable") as? String
            }
            
            cell?.workingHoursBtn.setTitle(LanguageDictonary.object(forKey: "viewworkinghours") as! String, for: .normal)
            
            cell?.workingHoursBtn.addTarget(self, action: #selector(workingHoursBtnTapped), for:.touchUpInside)
            return cell!
         }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoReviewCell") as? InfoReviewCell
            cell?.selectionStyle = .none
             let rating = (((ResultData.object(forKey: "restaurant_review")as! NSArray).object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! NSNumber)
            if rating == 0 {
                cell?.starReview.isHidden = false
                cell?.ratingCountLbl.isHidden = true
            }else{
                cell?.starReview.isHidden = true
                cell?.ratingCountLbl.isHidden = false
                cell?.ratingCountLbl.text = "\(rating)"
            }
            cell?.nameLbl.text = (((ResultData.object(forKey: "restaurant_review")as! NSArray).object(at: indexPath.row)as! NSDictionary).object(forKey: "review_customer_name")as! String)
            cell?.descLbl.text = (((ResultData.object(forKey: "restaurant_review")as! NSArray).object(at: indexPath.row)as! NSDictionary).object(forKey: "review_comments")as! String)
            return cell!
        }
    }
    
    @objc func workingHoursBtnTapped(sender:UIButton){
        showWorkingHoursView = "true"
        self.dismiss(animated: true, completion: nil)
    }
    

}
