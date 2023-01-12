//
//  CancelOrderPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup
import NVActivityIndicatorView
import Toast_Swift



class CancelOrderPage: BottomPopupViewController,UITextViewDelegate {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var dataDict = NSMutableDictionary()
    var OrderId = String()

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var msgTxt: UITextView!
    @IBOutlet weak var dishNameLbl: UILabel!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var BaseView: UIView!
    var  CancelLoadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 36), type: .ballPulse, color: UIColor.white, padding: 0)

    
    @IBOutlet weak var buttonIndicatorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataDict)
        restaurantNameLbl.text = (dataDict.object(forKey: "restaurant_name")as! String)
        dishNameLbl.text = (dataDict.object(forKey: "item_name")as! String)
        cancelOrderBtn.layer.cornerRadius = 17.5
        msgTxt.delegate = self
        msgTxt.textColor = UIColor.lightGray
        closeBtn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        cancelOrderBtn.addTarget(self, action: #selector(cancelOrderBtnTapped), for: .touchUpInside)
        buttonIndicatorView.addSubview(CancelLoadingIndicator)

    }
    
    @objc func closeBtnTapped(sender:UIButton){
       self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelOrderBtnTapped(sender:UIButton){
        if msgTxt.textColor == UIColor.lightGray {
            self.view.makeToast("Please enter the reason for cancel", duration: 3.0)
        }else{
            cancelOrderBtn.setTitle("", for: .normal)
            buttonIndicatorView.isHidden = false
            CancelLoadingIndicator.startAnimating()
            let Parse = CommomParsing()
            Parse.setOrderToCancell(lang: login_session.value(forKey: "Language") as? String ?? "es",orderId: OrderId,reason: msgTxt.text, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    self.CancelLoadingIndicator.startAnimating()
                    self.cancelOrderBtn.setTitle("CANCEL ORDER", for: .normal)
                    self.buttonIndicatorView.isHidden = true
                    CommonOrderStatusUpdateStr = "Cancelled"
                    self.dismiss(animated: true, completion: nil)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.view.makeToast(response.object(forKey: "message")as? String, duration: 1.5)
                }
                
            }, onFailure: {errorResponse in})
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
}
