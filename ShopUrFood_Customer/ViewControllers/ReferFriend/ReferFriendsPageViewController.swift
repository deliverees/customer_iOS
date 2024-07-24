//
//  ReferFriendsPageViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 22/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ReferFriendsPageViewController: BaseViewController {

    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var offerValueLbl: UILabel!
    @IBOutlet weak var referFriendLbl: UILabel!
    var navigationType = String()
    
    @IBOutlet weak var baseContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTxt.placeholder = LanguageDictonary.value(forKey: "refereeemail") as? String
        self.submitBtn.setTitle(LanguageDictonary.value(forKey: "submit") as? String, for: .normal)
        self.getReferFriendData()
        emailTxt.layer.cornerRadius = 20.0
        emailTxt.layer.borderWidth = 0.5
        emailTxt.layer.borderColor = UIColor.lightGray.cgColor
        emailTxt.clipsToBounds = true
        //submitBtn.layer.cornerRadius = 25.0
        emailTxt.clipsToBounds = true
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: self.baseContentView)
        // Do any additional setup after loading the view.
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        if emailTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteranyemailid") as! String)
        }else if !isValidEmail(testStr: emailTxt.text!){
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentervalidemailid") as! String)
        }else{
            self.showLoadingIndicator(senderVC: self)
            let Parse = CommomParsing()
            Parse.sendReferMail(lang: login_session.value(forKey: "Language") as? String ?? "es" ,referral_email: emailTxt.text!, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    self.emailTxt.text = ""
                   self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if navigationType == "present"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "referfriend") as? String
        self.referFriendLbl.text = LanguageDictonary.value(forKey: "referfriendStatic") as? String
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getReferFriendData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getReferData(lang: login_session.value(forKey: "Language") as? String ?? "es" , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                self.emailTxt.isHidden = false
                self.submitBtn.isHidden = false

                self.offerValueLbl.text = (response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.emailTxt.isHidden = true
                self.submitBtn.isHidden = true
                self.referFriendLbl.text = LanguageDictonary.value(forKey: "unabletoreferafriend") as? String

            }
            else
            {
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
}
