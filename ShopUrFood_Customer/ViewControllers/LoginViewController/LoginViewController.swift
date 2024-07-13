//
//  LoginViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth
//import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import SCLAlertView
import UserNotifications
import AppTrackingTransparency


class LoginViewController: BaseViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate  {
    //@IBOutlet weak var newUserLbl: UILabel!
    
    
    @IBOutlet weak var btnAppleSignIn: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var socialLoginLbl: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginTitleLbl: UILabel!
    @IBOutlet weak var userLoginDataView: UIView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var fbBtnSignIn: UIImageView!
    @IBOutlet weak var googleBtnSignIn: UIImageView!
    
    var iPhoneUDIDString = String()
    var isRegister = Bool()
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginTitleLbl.text = ""//LanguageDictonary.object(forKey: "login") as! String
        self.userNameTxt.placeholder = LanguageDictonary.object(forKey: "email") as! String
        self.passwordTxt.placeholder = LanguageDictonary.object(forKey: "password") as! String
        self.goBtn.setTitle(LanguageDictonary.object(forKey: "btn_login") as! String, for: .normal)
        self.forgetPasswordBtn.setTitle(LanguageDictonary.object(forKey: "forgotpassword") as! String, for: .normal)
        self.socialLoginLbl.text = LanguageDictonary.object(forKey: "continue_with") as! String
        //self.newUserLbl.text = LanguageDictonary.object(forKey: "neewuser") as! String
        self.signUpBtn.setTitle(LanguageDictonary.object(forKey: "signup") as! String, for: .normal)
        
        self.signUpBtn.layer.borderWidth = 2
        self.signUpBtn.layer.borderColor = UIColor.red.cgColor
        
        //userLoginDataView.layer.cornerRadius = 8.0
        //userLoginDataView = self.setCornorShadowEffects(sender: userLoginDataView)
        //goBtn.layer.cornerRadius = 25.0
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        userNameTxt.delegate = self
        passwordTxt.delegate = self
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.ConnectToFCM()
        //self.logoImg.image = UIImage(named: "app_logo")
        //  self.getIconsFromAPI()
        
        userNameTxt.setPadding(left: 30, right: 0, imageName: "ic_user_email")
        /*userNameTxt.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: userNameTxt.frame.size.width - 0, y: 0, width: 32, height: 32))
        let image = UIImage(named: "ic_user_email")
        imageView.image = image
        userNameTxt.leftView = imageView*/
        
        passwordTxt.setPadding(left: 30, imageName: "ic_user_password")
        /*passwordTxt.leftViewMode = UITextField.ViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        let image2 = UIImage(named: "ic_user_password")
        imageView2.image = image2
        passwordTxt.leftView = imageView2*/
        
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let image3 = UIImage(named: "show")
        imageView3.image = image3
        
        let contentView = UIView()
        contentView.addSubview(imageView3)
        
        contentView.frame = CGRect(x:0, y: 0, width: 24, height: 24)
        imageView3.frame = CGRect(x:-10, y: 0, width: 24, height: 24)
        
        passwordTxt.rightView = contentView
        passwordTxt.rightViewMode = UITextField.ViewMode.always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagedTaped(tapGestureRecognizer:)))
        
        imageView3.isUserInteractionEnabled = true
        imageView3.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizerBtnFb = UITapGestureRecognizer(target: self, action: #selector(imagedTapedBtnFb(tapGestureRecognizer:)))
        
        fbBtnSignIn.isUserInteractionEnabled = true
        fbBtnSignIn.addGestureRecognizer(tapGestureRecognizerBtnFb)
        
        let tapGestureRecognizerGoogleBtnSignIn = UITapGestureRecognizer(target: self, action: #selector(imagedTapedGoogleBtnSignIn(tapGestureRecognizer:)))
        
        googleBtnSignIn.isUserInteractionEnabled = true
        googleBtnSignIn.addGestureRecognizer(tapGestureRecognizerGoogleBtnSignIn)
        
        let tapGestureRecognizerAppleBtnSignIn = UITapGestureRecognizer(target: self, action: #selector(handleAppleIdRequest(tapGestureRecognizer:)))
        
        btnAppleSignIn.isUserInteractionEnabled = true
        btnAppleSignIn.addGestureRecognizer(tapGestureRecognizerAppleBtnSignIn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            ATTrackingManager.requestTrackingAuthorization { status in
                print(status)
                DispatchQueue.main.async {
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {(granted, error) in
                        if (granted) {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        } else{
                            print("Notification permissions not granted")
                        }
                        
                    })
                }
            }
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

        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom("", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }

    
    fileprivate var currentNonce: String?
    
    @objc func handleAppleIdRequest(tapGestureRecognizer:UITapGestureRecognizer) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
        
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @objc func imagedTapedBtnFb(tapGestureRecognizer:UITapGestureRecognizer) {
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
            loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: completion)
        }
    }
    
    @objc func imagedTapedGoogleBtnSignIn(tapGestureRecognizer:UITapGestureRecognizer) {
        if (Reachability()?.isReachable)!
        {
            self.showLoadingIndicator(senderVC: self)
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    var iconClick = true
    
    @objc func imagedTaped(tapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(named: "hidden")
            passwordTxt.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImage.image = UIImage(named: "show")
            passwordTxt.isSecureTextEntry = true
        }
    }
    
    
    func getIconsFromAPI()
    {
        let Parse = CommomParsing()
        Parse.getSplash(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            if (response.value(forKey: "code")as! Int == 200){
                print(response)
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                login_session.setValue(tempDict.object(forKey: "signup_logo_ios"), forKey: "logo")
                login_session.synchronize()
                let logoURL = URL(string: login_session.object(forKey: "logo")as! String)
                //self.logoImg.kf.setImage(with: logoURL)
                self.logoImg.image = UIImage(named: "app_logo")
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
            }
            
        }, onFailure: {errorResponse in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    //MARK:- TextFiled delegate Meethods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Button Actions
    @IBAction func forgetBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordPage") as! ForgetPasswordPage
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func goBtnAction(_ sender: Any)
    {
        if (Reachability()?.isReachable)!
        {
            self.view.endEditing(true)
            let emailStr = userNameTxt.text
            let passwordStr = passwordTxt.text
            
            if emailStr == "" || emailStr?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenteremail") as! String)
            }else if passwordStr == "" || passwordStr?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenterpass") as! String)
            }else{
                self.showLoadingIndicator(senderVC: self)
                
                let Parse = CommomParsing()
                var fcmToken = String()
                if login_session.object(forKey: "fcmToken") != nil
                {
                    fcmToken = login_session.object(forKey: "fcmToken") as! String
                }else{
                    fcmToken = ""
                }
                Parse.NormalEmailLoginParse(lang: login_session.value(forKey: "Language") as? String ?? "es", login_id: emailStr!, cus_password: passwordStr!,ios_fcm_id: fcmToken,type: device_type, ios_device_id: iPhoneUDIDString, onSuccess: {
                    response in
                    print(response)
                    if response.object(forKey: "code") as! Int == 200{
                        let dataDict = NSMutableDictionary()
                        dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                        let user_email = dataDict.object(forKey: "user_email")as! String
                        let user_id = dataDict.object(forKey: "user_id")
                        let user_name = dataDict.object(forKey: "user_name")as! String
                        let phone = dataDict.object(forKey: "user_phone")as! String
                        //phone = phone.replacingOccurrences(of: "+91", with: "")
                        let token = dataDict.object(forKey: "token")as! String
                        login_session.setValue(user_email, forKey: "user_email")
                        login_session.setValue("0", forKey: "userCartCount")
                        login_session.setValue(user_id, forKey: "user_id")
                        login_session.setValue(user_name, forKey: "user_name")
                        login_session.setValue(phone, forKey: "user_mobileNo")
                        login_session.setValue(token, forKey: "user_token")
                        login_session.synchronize()
                        self.stopLoadingIndicator(senderVC: self)
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                        nextViewController.ComingType = "FIRST"
                        self.present(nextViewController, animated:true, completion:nil)
                    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.stopLoadingIndicator(senderVC: self)
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    }
                }, onFailure: {
                    errorResponse in
                })
            }
        }
        else
        {
            
        }
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    //MARK:Google SignIn Delegate
    @IBAction func googleBtnAction(_ sender: Any) {
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
            Parse.GoogleLogin(lang: login_session.value(forKey: "Language") as? String ?? "es", google_id:idStr!, email:emailStr!, name:nameStr!, type: device_type,ios_fcm_id:login_session.object(forKey: "fcmToken") as! String ,ios_device_id:iPhoneUDIDString, onSuccess: {
                response in
                print(response)
                let dataDict = NSMutableDictionary()
                dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                let user_email = dataDict.object(forKey: "user_email")as! String
                let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                let user_name = dataDict.object(forKey: "user_name")as! String
                let phone = dataDict.object(forKey: "user_phone")as! String
                //phone = phone.replacingOccurrences(of: "+91", with: "")
                let token = dataDict.object(forKey: "token")as! String
                login_session.setValue(user_email, forKey: "user_email")
                login_session.setValue("0", forKey: "userCartCount")
                login_session.setValue(user_id, forKey: "user_id")
                login_session.setValue(user_name, forKey: "user_name")
                login_session.setValue(phone, forKey: "user_mobileNo")
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
    
    //MARK:FaceBook SignIn Delegate
    @IBAction func fbBtnAction(_ sender: Any)
    {
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
            loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: completion)
        }
        
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //    self.dict = result as! [String : AnyObject]
                    let responseDict = result as! NSDictionary
                    self.showLoadingIndicator(senderVC: self)
                    let Parse = CommomParsing()
                    let emailStr = responseDict.object(forKey: "email")as! String
                    let fb_idStr = responseDict.object(forKey: "id")as! String
                    let nameStr = responseDict.object(forKey: "name")as! String
                    Parse.faceBookLogin(lang: login_session.value(forKey: "Language") as? String ?? "es", facebook_id: fb_idStr, email: emailStr, name: nameStr, type: device_type,ios_fcm_id: login_session.object(forKey: "fcmToken") as! String,ios_device_id:self.iPhoneUDIDString, onSuccess: {
                        response in
                        print(response)
                        if (response.value(forKey: "code")as! Int == 200){
                            let dataDict = NSMutableDictionary()
                            dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                            let user_email = dataDict.object(forKey: "user_email")as! String
                            let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                            let user_name = dataDict.object(forKey: "user_name")as! String
                            let phone = dataDict.object(forKey: "user_phone")as! String
                            //phone = phone.replacingOccurrences(of: "+91", with: "")
                            let token = dataDict.object(forKey: "token")as! String
                            login_session.setValue(user_email, forKey: "user_email")
                            login_session.setValue("0", forKey: "userCartCount")
                            login_session.setValue(user_id, forKey: "user_id")
                            login_session.setValue(user_name, forKey: "user_name")
                            login_session.setValue(phone, forKey: "user_mobileNo")
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
    
    
    
}
    
extension UITextField {
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil, imageName:String, imageNameRight:String = ""){
        if let left = left {
            let paddingView = UIView()
            paddingView.frame = CGRect.init(x: 5, y: 5, width: left, height: self.frame.size.height)
            let imageIcon = UIImageView()
            imageIcon.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
            imageIcon.image = UIImage.init(named: imageName)
            paddingView.addSubview(imageIcon)
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIView()
            paddingView.frame = CGRect.init(x: 5, y: 5, width: right, height: self.frame.size.height)        
            let imageIcon = UIImageView()
            imageIcon.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
            imageIcon.image = UIImage.init(named: imageNameRight)
            paddingView.addSubview(imageIcon)
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard var nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? "Anonymous"
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                self.showLoadingIndicator(senderVC: self)
                let Parse = CommomParsing()

                Parse.AppleLogin(lang: login_session.value(forKey: "Language") as? String ?? "es", apple_id: uid, email: email, name: displayName, type: device_type,ios_fcm_id: login_session.object(forKey: "fcmToken") as! String,ios_device_id:self.iPhoneUDIDString, onSuccess: {
                    response in
                    print(response)
                    if (response.value(forKey: "code")as! Int == 200){
                        let dataDict = NSMutableDictionary()
                        dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                        let user_email = dataDict.object(forKey: "user_email")as! String
                        let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                        let user_name = dataDict.object(forKey: "user_name")as! String
                        let phone = dataDict.object(forKey: "user_phone")as! String
                        //phone = phone.replacingOccurrences(of: "+91", with: "")
                        let token = dataDict.object(forKey: "token")as! String
                        login_session.setValue(user_email, forKey: "user_email")
                        login_session.setValue("0", forKey: "userCartCount")
                        login_session.setValue(user_id, forKey: "user_id")
                        login_session.setValue(user_name, forKey: "user_name")
                        login_session.setValue(phone, forKey: "user_mobileNo")
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
                //let db = Firestore.firestore()
                /*db.collection("User").document(uid).setData([
                    "email": email,
                    "displayName": displayName,
                    "uid": uid
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("the user has sign up or is logged in")
                    }
                }*/
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
