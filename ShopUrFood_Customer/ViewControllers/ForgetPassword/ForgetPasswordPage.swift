//
//  ForgetPasswordPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 12/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ForgetPasswordPage: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var subTitlelbl: UILabel!
    @IBOutlet weak var forgetPasswordTitleLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var forgetPasswordView: UIView!
    @IBOutlet weak var goBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forgetPasswordTitleLbl.text = LanguageDictonary.object(forKey: "forgotpassword") as! String
        self.subTitlelbl.text = LanguageDictonary.object(forKey: "noworries") as! String
        self.emailText.placeholder = LanguageDictonary.object(forKey: "email") as! String
        self.goBtn.setTitle(LanguageDictonary.object(forKey: "go") as! String, for: .normal)
        forgetPasswordView.layer.cornerRadius = 8.0
        forgetPasswordView = self.setCornorShadowEffects(sender: forgetPasswordView)
        //goBtn.layer.cornerRadius = 25.0
        // Do any additional setup after loading the view.
        emailText.delegate = self
          //self.logoImg.image = UIImage(named: "app_logo")
        
        emailText.setPadding(left: 30, right: 0, imageName: "ic_user_email")
       
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- TextFiled delegate Meethods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func goBtnAction(_ sender: Any) {
        if (Reachability()?.isReachable)!
        {
            let emailStr = emailText.text
            if emailStr == "" || emailStr?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteremail") as! String)
            }else if !isValidEmail(testStr: emailText.text!){
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentervalidmail") as! String)
            }else{
                 self.showLoadingIndicator(senderVC: self)
                let Parse = CommomParsing()
                Parse.forgetPassword(lang: login_session.value(forKey: "Language") as? String ?? "es",cus_email: emailStr!, onSuccess: {
                    response in
                    print(response)
                    if(response.object(forKey: "code")as! Int == 200){
                        self.showSuccessAlert(messageStr: response.object(forKey: "message") as! String)
                        self.dismiss(animated: true, completion: nil)
                    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }
                    self.stopLoadingIndicator(senderVC: self)
                }, onFailure: {errorResponse in})
            }

        }
    }
    
    
}
