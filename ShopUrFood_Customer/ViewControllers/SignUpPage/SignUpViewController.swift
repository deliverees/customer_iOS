//
//  SignUpViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 12/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import DropDown
import SCLAlertView
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn




class SignUpViewController: BaseViewController,UIGestureRecognizerDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    @IBOutlet weak var SocialLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var registerTitleLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var transpertantView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var codeTxt: UITextField!
    @IBOutlet weak var NameTxt: UITextField!
    
    @IBOutlet weak var referralCodeStaticLbl: UILabel!
    
    
    
    
    
    //dropDown
    let countryCodeDropDown = DropDown()
    let loginManager = LoginManager()
    var iPhoneUDIDString = String()
    var countryListDict = NSMutableDictionary()
    
    @IBOutlet weak var referralApplyBtn: UIButton!
    @IBOutlet weak var referralCodeTxt: UITextField!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var logoBGView: UIView!
    @IBOutlet weak var countryDropDown: UIButton!
    
    @IBOutlet weak var referralCodeBtn: UIButton!
    
    
    var referralCodeStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTitleLbl.text = LanguageDictonary.object(forKey: "register") as! String
        self.NameTxt.placeholder = LanguageDictonary.object(forKey: "name") as! String
        self.SocialLbl.text = LanguageDictonary.object(forKey: "sociallogin") as! String
        self.emailTxt.placeholder = LanguageDictonary.object(forKey: "email") as! String
        self.passwordTxt.placeholder = LanguageDictonary.object(forKey: "password") as! String
        self.codeTxt.placeholder = LanguageDictonary.object(forKey: "code") as! String
        self.mobileTxt.placeholder = LanguageDictonary.object(forKey: "mobilenumber") as! String
        self.referralCodeBtn.setTitle(LanguageDictonary.object(forKey: "referralcode") as! String, for: .normal)
        self.goBtn.setTitle(LanguageDictonary.object(forKey: "go") as! String, for: .normal)
        self.referralCodeStaticLbl.text = LanguageDictonary.object(forKey: "referral") as! String
        self.referralCodeTxt.placeholder = LanguageDictonary.object(forKey: "enterreferralcode") as! String
        self.referralApplyBtn.setTitle(LanguageDictonary.object(forKey: "apply") as! String, for: .normal)
        
      print(login_session.value(forKey: "Language") as? String)
        
            if login_session.value(forKey: "Language") as? String == "en"{
                let string1 = "Referral code? "
                let string2 = "Apply"
                
                let att = NSMutableAttributedString(string: "\(string1)\(string2)");
                att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: string1.characters.count))
                att.addAttribute(NSAttributedString.Key.foregroundColor, value: AppLightOrange, range: NSRange(location: string1.characters.count, length: string2.characters.count))
                referralCodeBtn.setAttributedTitle(att, for: .normal)
            }else{
                let string1 = "¿Codigo de referencia? "
                let string2 = "Aplicar"
                
                let att = NSMutableAttributedString(string: "\(string1)\(string2)");
                att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: string1.characters.count))
                att.addAttribute(NSAttributedString.Key.foregroundColor, value: AppLightOrange, range: NSRange(location: string1.characters.count, length: string2.characters.count))
                referralCodeBtn.setAttributedTitle(att, for: .normal)
            }
        
        
        
        
        goBtn.layer.cornerRadius = 25.0
        baseView.layer.cornerRadius = 5.0
        baseView = self.setCornorShadowEffects(sender: baseView)
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        getCountryListData()
        referralCodeStr = ""
        //alloc data to dropdown
        
        //let logoURL = URL(string: login_session.object(forKey: "logo")as! String)
        //self.logoImg.kf.setImage(with: logoURL)
        // self.logoImg.image = UIImage(named: "app_logo")
        logoBGView.layer.cornerRadius = 75.0
        logoBGView.clipsToBounds = true
        referralApplyBtn.layer.cornerRadius = 20.0
        mobileTxt.keyboardType = .numberPad
    }
    
    @IBAction func applyReferralCodeBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        if referralCodeTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "enterreferralcode") as! String)
        }else{
            referralCodeStr  = referralCodeTxt.text!
            transpertantView.isHidden = true
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func codeBtn(_ sender: Any) {
        countryCodeDropDown.show()
        
    }
    
    
    func getCountryListData()
    {
        let Parse = CommomParsing()
        Parse.getCountryList(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                self.countryListDict.addEntries(from: ((response.object(forKey: "data") as? NSDictionary)?.value(forKey: "country_details") as! NSArray).object(at: 0) as! [AnyHashable : Any])
                
                print("countryListDict : ",self.countryListDict)
                var ccArray = [String]()
                ccArray.append(self.countryListDict.value(forKey: "country_dial") as! String)
                self.countryCodeDropDown.dataSource = ccArray
                self.countryCodeDropDown.anchorView = self.countryDropDown
                self.countryCodeDropDown.direction = .bottom
                self.countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.countryDropDown.bounds.height)
                // Action triggered on selection
                self.countryCodeDropDown.selectionAction = { [weak self] (index, item) in
                    self?.codeTxt.text  = item
                }
                
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
            }
        }, onFailure: {errorResponse in})
    }
    
    @IBAction func showCouponView(_ sender: Any) {
        referralCodeTxt.text = referralCodeStr
        transpertantView.backgroundColor = BlackTranspertantColor
        transpertantView.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self // This is not required
        transpertantView.addGestureRecognizer(tap)
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        transpertantView.isHidden = true
    }
    
    @IBAction func goBtnAction(_ sender: Any) {
        
        if (NameTxt.text == "" || NameTxt.text?.count == 0){
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenterusername") as! String)
        }else if emailTxt.text == "" || emailTxt.text?.count == 0{
            self.showToastAlert(senderVC: self, messageStr:  LanguageDictonary.object(forKey: "pleaseenteremail") as! String)
        }else if codeTxt.text == "" || codeTxt.text?.count == 0{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseentercountrycode") as! String)
        }else if mobileTxt.text == "" || mobileTxt.text?.count == 0{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseentermobilenumber") as! String)
        }else if passwordTxt.text == "" || passwordTxt.text?.count == 0{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenterpass") as! String)
        }else if (!isValidEmail(testStr: emailTxt.text!)){
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseentervalidemailid") as! String)
        }else{
            referralCodeStr  = referralCodeTxt.text!
            self.showLoadingIndicator(senderVC: self)
            let mobileNoStr = codeTxt.text!+mobileTxt.text!
            let Parse = CommomParsing()
            Parse.userRegister(lang: login_session.value(forKey: "Language") as? String ?? "es", cus_fname: NameTxt.text!,cus_email: emailTxt.text!,cus_password: passwordTxt.text!,cus_phone1: mobileNoStr,referral_code: referralCodeStr,ios_device_id: iPhoneUDIDString, ios_fcm_id: login_session.object(forKey: "fcmToken") as! String, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    let dataDict = NSMutableDictionary()
                    dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                    let user_email = dataDict.object(forKey: "user_email")as! String
                    let user_id = dataDict.object(forKey: "user_id")
                    let user_name = dataDict.object(forKey: "user_name")as! String
                    let token = dataDict.object(forKey: "token")as! String
                    login_session.setValue(user_email, forKey: "user_email")
                    login_session.setValue("0", forKey: "userCartCount")
                    login_session.setValue(user_id, forKey: "user_id")
                    login_session.setValue(user_name, forKey: "user_name")
                    login_session.setValue(token, forKey: "user_token")
                    login_session.synchronize()
                    self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    print(response.object(forKey: "message") as Any)
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Ok") {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
            nextViewController.ComingType = "FIRST"
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom("", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    
    @IBAction func fbBtnTapped(_ sender: Any) {
        if (Reachability()?.isReachable)!
        {
            self.showLoadingIndicator(senderVC: self)
            let completion = {
                (result:LoginResult) in
                switch result
                {
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("YES! \n--- GRANTED PERMISSIONS ---\n\(grantedPermissions) \n--- DECLINED PERMISSIONS ---\n\(declinedPermissions) \n--- ACCESS TOKEN ---\n\(accessToken)")
                    print("check\(declinedPermissions.description)")
                    if(declinedPermissions.contains("email")){
                        print("correct\(declinedPermissions.description)")
                        let loginManager = LoginManager()
                        loginManager.logOut()
                        //Utility().showAlertWithTitle(alertTitle: APP_NAME as NSString, alertMsg:FB_PERMISSION_ALERT as NSString, viewController: self)
                    }else{
                        self.getFBUserData()
                    }
                case .failed(let error):
                    self.stopLoadingIndicator(senderVC: self)
                    print("No...\(error)")
                case .cancelled:
                    self.stopLoadingIndicator(senderVC: self)
                    print("Cancelled.")
                }
            }
            loginManager.logOut()
            loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self, completion: completion)
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //    self.dict = result as! [String : AnyObject]
                    let responseDict = result as! NSDictionary
                    self.showLoadingIndicator(senderVC: self)
                    let Parse = CommomParsing()
                    let emailStr = responseDict.object(forKey: "email")as! String
                    let fb_idStr = responseDict.object(forKey: "id")as! String
                    let nameStr = responseDict.object(forKey: "name")as! String
                    Parse.faceBookLogin(lang: login_session.value(forKey: "Language") as? String ?? "es", facebook_id: fb_idStr, email: emailStr, name: nameStr, type: device_type,ios_fcm_id: login_session.object(forKey: "fcmToken") as! String, ios_device_id:self.iPhoneUDIDString , onSuccess: {
                        response in
                        print(response)
                        if (response.value(forKey: "code")as! Int == 200){
                            let dataDict = NSMutableDictionary()
                            dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                            let user_email = dataDict.object(forKey: "user_email")as! String
                            let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                            let user_name = dataDict.object(forKey: "user_name")as! String
                            let token = dataDict.object(forKey: "token")as! String
                            login_session.setValue(user_email, forKey: "user_email")
                            login_session.setValue("0", forKey: "userCartCount")
                            login_session.setValue(user_id, forKey: "user_id")
                            login_session.setValue(user_name, forKey: "user_name")
                            login_session.setValue(token, forKey: "user_token")
                            login_session.synchronize()
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                            nextViewController.ComingType = "FIRST"
                            self.present(nextViewController, animated:true, completion:nil)
                        }else{
                            print("Failed")
                        }
                        self.stopLoadingIndicator(senderVC: self)
                    }, onFailure: {errorResponse in})
                    
                }
                
            })
        }
    }
    
    @IBAction func googleBtnTapped(_ sender: Any) {
        if (Reachability()?.isReachable)!
        {
            self.showLoadingIndicator(senderVC: self)
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue("google", forKey: "type")
            requestDict.setValue(user.userID, forKey: "id")
            requestDict.setValue(user.profile.name, forKey: "full_name")
            requestDict.setValue(user.profile.email, forKey: "email")
            print(requestDict)
            let idStr = user.userID
            let emailStr = user.profile.email
            let  nameStr = user.profile.name
            
            
            let Parse = CommomParsing()
            Parse.GoogleLogin(lang: login_session.value(forKey: "Language") as? String ?? "es", google_id:idStr!, email:emailStr!, name:nameStr!, type: device_type,ios_fcm_id:login_session.object(forKey: "fcmToken") as! String, ios_device_id: iPhoneUDIDString , onSuccess: {
                response in
                print(response)
                let dataDict = NSMutableDictionary()
                dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                let user_email = dataDict.object(forKey: "user_email")as! String
                let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                let user_name = dataDict.object(forKey: "user_name")as! String
                let token = dataDict.object(forKey: "token")as! String
                login_session.setValue(user_email, forKey: "user_email")
                login_session.setValue("0", forKey: "userCartCount")
                login_session.setValue(user_id, forKey: "user_id")
                login_session.setValue(user_name, forKey: "user_name")
                login_session.setValue(token, forKey: "user_token")
                login_session.synchronize()
                self.stopLoadingIndicator(senderVC: self)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                nextViewController.ComingType = "FIRST"
                self.present(nextViewController, animated:true, completion:nil)
            }, onFailure: {errorResponse in})
            
        } else {
            self.stopLoadingIndicator(senderVC: self)
            print("\(error.localizedDescription)")
        }
    }
}
