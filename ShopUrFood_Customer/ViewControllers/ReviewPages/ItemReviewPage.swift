//
//  ItemReviewPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup
import NVActivityIndicatorView
import Toast_Swift


class ItemReviewPage: BottomPopupViewController,UITextViewDelegate {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var product_id  = String()
    var store_id = String()
    var reviewType = String()

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reviewMsgTxt: UITextView!
    @IBOutlet weak var reviewFourBtn: UIButton!
    @IBOutlet weak var reviewThreeBtn: UIButton!
    @IBOutlet weak var reviewTwoBtn: UIButton!
    @IBOutlet weak var reviewOneBtn: UIButton!
    @IBOutlet weak var reviewSubTitleLbl: UILabel!
    @IBOutlet weak var reviewTitleLbl: UILabel!
    var reviewSelection = Int()
    @IBOutlet weak var buttonIndicatorView: UIView!
    var  CancelLoadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 40), type: .ballPulse, color: UIColor.white, padding: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.submitBtn.setTitle(LanguageDictonary.value(forKey: "submitreview") as? String, for: .normal)
        self.reviewTitleLbl.text = LanguageDictonary.value(forKey: "reviews") as? String
         self.reviewSubTitleLbl.text = LanguageDictonary.value(forKey: "whatdoyouthink") as? String
        
        reviewSelection = 0
        
        reviewMsgTxt.delegate = self
        reviewMsgTxt.textColor = UIColor.lightGray
        buttonIndicatorView.addSubview(CancelLoadingIndicator)
        submitBtn.layer.cornerRadius = 2 //20.0
        submitBtn.clipsToBounds = true
        if reviewType == "item"{
            reviewTitleLbl.text = LanguageDictonary.value(forKey: "review") as? String
        }else{
            reviewTitleLbl.text = LanguageDictonary.value(forKey: "RestaurantReview") as? String

        }
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if reviewSelection == 0{
            self.view.makeToast("Please select any review option", duration: 1.5)
        }else if reviewMsgTxt.textColor == UIColor.lightGray{
          self.view.makeToast("Please enter the review message", duration: 1.5)
        }else{
            submitBtn.setTitle("", for: .normal)
            buttonIndicatorView.isHidden = false
            CancelLoadingIndicator.startAnimating()
            
            if reviewType == "item"{
                let Parse = CommomParsing()
                Parse.postItemReview(lang: login_session.value(forKey: "Language") as? String ?? "es",product_id:product_id,review_rating: "\(reviewSelection)",review_comments: reviewMsgTxt.text , onSuccess: {
                    response in
                    print (response)
                    if response.object(forKey: "code") as! Int == 200{
                        self.CancelLoadingIndicator.startAnimating()
                        self.submitBtn.setTitle("SUBMIT REVIEW", for: .normal)
                        self.buttonIndicatorView.isHidden = true
                        CommonOrderStatusUpdateStr = "reviewAdded"
                        self.dismiss(animated: true, completion: nil)
                    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.view.makeToast(response.object(forKey: "message")as? String, duration: 1.5)
                    }
                    
                }, onFailure: {errorResponse in})
            }else{
                let Parse = CommomParsing()
                Parse.postStoreReview(lang: login_session.value(forKey: "Language") as? String ?? "es",store_id:store_id,review_rating: "\(reviewSelection)",review_comments: reviewMsgTxt.text , onSuccess: {
                    response in
                    print (response)
                    if response.object(forKey: "code") as! Int == 200{
                        self.CancelLoadingIndicator.startAnimating()
                        self.submitBtn.setTitle("SUBMIT REVIEW", for: .normal)
                        self.buttonIndicatorView.isHidden = true
                        CommonOrderStatusUpdateStr = "reviewAdded"
                        self.dismiss(animated: true, completion: nil)
                    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.view.makeToast(response.object(forKey: "message")as? String, duration: 1.5)
                    }
            }, onFailure: {errorResponse in})
            
            
        }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Comment"
            textView.textColor = UIColor.lightGray
        }
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
    
    @IBAction func reviewFourAction(_ sender: Any) {
        reviewOneBtn.setImage(UIImage(named: "review_one"), for: .normal)
        reviewTwoBtn.setImage(UIImage(named: "Review_two"), for: .normal)
        reviewThreeBtn.setImage(UIImage(named: "Review_three"), for: .normal)
        reviewFourBtn.setImage(UIImage(named: "Review_four_selected"), for: .normal)
        reviewSelection = 4
    }
    @IBAction func reviewThreeAction(_ sender: Any) {
        reviewOneBtn.setImage(UIImage(named: "review_one"), for: .normal)
        reviewTwoBtn.setImage(UIImage(named: "Review_two"), for: .normal)
        reviewThreeBtn.setImage(UIImage(named: "Review_three_selected"), for: .normal)
        reviewFourBtn.setImage(UIImage(named: "Review_four"), for: .normal)
        reviewSelection = 3
    }
    @IBAction func reviewTwoAction(_ sender: Any) {
        reviewOneBtn.setImage(UIImage(named: "review_one"), for: .normal)
        reviewTwoBtn.setImage(UIImage(named: "Review_two_selected"), for: .normal)
        reviewThreeBtn.setImage(UIImage(named: "Review_three"), for: .normal)
        reviewFourBtn.setImage(UIImage(named: "Review_four"), for: .normal)
        reviewSelection = 1
    }
    @IBAction func reviewOneAction(_ sender: Any) {
        reviewOneBtn.setImage(UIImage(named: "Review_one_selected"), for: .normal)
        reviewTwoBtn.setImage(UIImage(named: "Review_two"), for: .normal)
        reviewThreeBtn.setImage(UIImage(named: "Review_three"), for: .normal)
        reviewFourBtn.setImage(UIImage(named: "Review_four"), for: .normal)
        reviewSelection = 2

    }    
}
