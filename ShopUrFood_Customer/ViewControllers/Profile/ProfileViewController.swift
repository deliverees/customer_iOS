//
//  ProfileViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 07/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import FirebaseCore
import FirebaseAuth




class ProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var customerAddressLbl: UILabel!
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var changePhotoLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    var imagePicker = UIImagePickerController()
    var resultDict = NSMutableDictionary()
    var userLocationStr = String() {
        didSet {
            addressTxt.isHidden = userLocationStr.isEmpty
            addressTxt.text = userLocationStr
        }
    }
    var userLatitude = String()
    var userLongitude = String()
    
    @IBOutlet weak var transpertantView: UIView!
    
    @IBOutlet weak var otpVerifyBtn: UIButton!
    @IBOutlet weak var numberSixLbl: UILabel!
    @IBOutlet weak var numberFiveLbl: UILabel!
    @IBOutlet weak var numberFourLbl: UILabel!
    @IBOutlet weak var numerbThreeLbl: UILabel!
    @IBOutlet weak var numberTwoLbl: UILabel!
    @IBOutlet weak var numberoneLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var mobileNumberBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var userNameBtn: UIButton!
    var verificationID: String?
    var pendingVerificationToken: String?
    var firebaseConfig: [String: Any]?
    
    var gettingOtp = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameLbl.text = LanguageDictonary.value(forKey: "username") as? String
        self.emailLbl.text = LanguageDictonary.value(forKey: "email") as? String
        self.mobileNumberLbl.text = LanguageDictonary.value(forKey: "mobilenumber") as? String
        self.customerAddressLbl.text = LanguageDictonary.value(forKey: "customeraddress") as? String
        self.userNameTxt.placeholder = LanguageDictonary.value(forKey: "username") as? String
        self.emailTxt.placeholder = LanguageDictonary.value(forKey: "email") as? String
        self.mobileNumberTxt.placeholder = LanguageDictonary.value(forKey: "mobilenumber") as? String
        self.addressTxt.placeholder = LanguageDictonary.value(forKey: "customeraddress") as? String
        self.saveBtn.setTitle(LanguageDictonary.value(forKey: "save") as? String, for: .normal)
        self.changePhotoLbl.text = LanguageDictonary.value(forKey: "changephoto") as? String
        
        self.showLoadingIndicator(senderVC: self)
        self.ProfileData()
        //        self.baseView.layer.cornerRadius = 10.0
        //        baseView = self.setCornorShadowEffects(sender: baseView)
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        userImageView.layer.cornerRadius = 50.0
        userImageView.clipsToBounds = true
        saveBtn.layer.cornerRadius = 2 //20.0
        mobileNumberTxt.keyboardType = .numberPad
        photoBtn.layer.cornerRadius = 2 //50.0
        photoBtn.clipsToBounds = true
        photoBtn.backgroundColor = OrangeTransperantColor
        userNameBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        emailBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        mobileNumberBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        addressBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        ActAsSelectedAddress = ""
        ActAsSelectedLatitude = ""
        ActAsSelectedLongitude = ""
        ActAsSelectedZipCode = ""
        otpVerifyBtn.layer.cornerRadius = 2 //20.0
        otpVerifyBtn.clipsToBounds = true
        
    }
    
    @objc func editBtnAction(sender:UIButton){
        userNameTxt.isUserInteractionEnabled = false
        emailTxt.isUserInteractionEnabled = false
        mobileNumberTxt.isUserInteractionEnabled = false
        if sender.tag == 0{
            userNameTxt.isUserInteractionEnabled = true
            userNameTxt.becomeFirstResponder()
        }else if sender.tag == 1{
            emailTxt.isUserInteractionEnabled = true
            emailTxt.becomeFirstResponder()
        }else if sender.tag == 2{
            mobileNumberTxt.isUserInteractionEnabled = true
            mobileNumberTxt.becomeFirstResponder()
        }else if sender.tag == 3 {
            MapLocationPageFrom = "address"
            AppRouter.shared.presentMapLocation(from: self) { newAddress in
                self.userLocationStr = newAddress.addressString ?? ""
                self.userLatitude = String(newAddress.latitude)
                self.userLongitude = String(newAddress.longitude)
                ActAsSelectedZipCode = newAddress.zipCode ?? ""
                ActAsSelectedAddress = newAddress.addressString ?? ""
                ActAsSelectedLatitude = String(newAddress.latitude)
                ActAsSelectedLongitude = String(newAddress.longitude)
            }
        }
    }
    
    //MARK:- API Methods
    private func ProfileData(){
        let Parse = CommomParsing()
        Parse.getCustomerProfileInfo(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.setData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    //MARK:- LoadData to UI
    func setData(){
        var mobileTxt = self.resultDict.object(forKey: "user_phone")as? String ?? ""
        mobileTxt = mobileTxt.replacingOccurrences(of: "+", with: "")
        userNameTxt.text = self.resultDict.object(forKey: "user_name")as? String ?? ""
        emailTxt.text = self.resultDict.object(forKey: "user_email")as? String ?? ""
        mobileNumberTxt.text = mobileTxt
        userLocationStr = self.resultDict.object(forKey: "user_address")as? String ?? ""
        let userImgeURL = URL(string: self.resultDict.object(forKey: "user_avatar")as! String)
        userImageView.kf.setImage(with: userImgeURL)
        userLatitude = self.resultDict.object(forKey: "user_latitude")as? String ?? ""
        userLongitude = self.resultDict.object(forKey: "user_longitude")as? String ?? ""
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if profilepageComesFrom == "settings"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "profile") as? String
        self.navigationController?.navigationBar.isHidden = true
        if ActAsSelectedAddress != "" {
            userLocationStr = ActAsSelectedAddress
            locationLbl.text = userLocationStr
            addressTxt.isHidden = true
        }
    }
    
    
    @IBAction func changePhotoBtnAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: Appname, message: LanguageDictonary.value(forKey: "chooseimage") as? String, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from Gallery
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK: - ImagePickerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.userImageView.image = editedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        let mobilenNo2 = self.resultDict.object(forKey: "user_phone2")as? String ?? ""
        
        if ActAsSelectedAddress != ""{
            userLocationStr = ActAsSelectedAddress
            userLatitude = ActAsSelectedLatitude
            userLongitude = ActAsSelectedLongitude
        }
        isfromShippingAddressPage = true
        
        if userNameTxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenterusername") as! String)
        }else if emailTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteremail") as! String)
        }else if !isValidEmail(testStr: emailTxt.text!){
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentervalidmail") as! String)
        }else if mobileNumberTxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentermobilenumber") as! String)
        }else if userLocationStr == "" && ActAsSelectedAddress == ""{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteraddress") as! String)
        }
        else {
            requestUpdateProfile()
        }
    }
    
    func requestUpdateProfile() {
        self.showLoadingIndicator(senderVC: self)
        
        let finalURL = BASEURL_CUSTOMER + UPDATE_PROFILE
        let tokenString = "Bearer \(login_session.object(forKey: "user_token") as! String)"
        
        let headers: HTTPHeaders = [
            "Authorization": tokenString
        ]
        
        let params: [String: String] = [
            "lang": "en",
            "cus_name": userNameTxt.text ?? "",
            "cus_email": emailTxt.text ?? "",
            "cus_phone1": "+\(mobileNumberTxt.text ?? "")",
            "cus_phone2": resultDict.object(forKey: "user_phone2") as? String ?? "",
            "cus_address": userLocationStr,
            "cus_lat": userLatitude,
            "cus_long": userLongitude
        ]
        
        // ✅ NUEVO FORMATO ALAMOFIRE 5.8
        AF.upload(
            multipartFormData: { multipartFormData in
                // Agregar parámetros
                for (key, value) in params {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                
                // Agregar imagen si existe
                if let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(
                        imageData,
                        withName: "cus_image",
                        fileName: "profile.jpeg",
                        mimeType: "image/jpeg"
                    )
                }
            },
            to: finalURL,
            method: .post,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { [weak self] response in
            guard let self = self else { return }
            self.stopLoadingIndicator(senderVC: self)

            switch response.result {
            case .success(let value):
                guard let jsonResponse = value as? [String: Any] else {
                    self.showToastAlert(senderVC: self, messageStr: "Invalid response")
                    return
                }

                print("✅ Response: \(jsonResponse)")

                guard let code = jsonResponse["code"] as? Int else {
                    self.showToastAlert(senderVC: self, messageStr: "Invalid response")
                    return
                }

                if code == 200 {
                    self.showSuccessPopUp(msgStr: jsonResponse["message"] as? String ?? "Actualizado")

                } else if code == 201 {
                    // 🔥 Requiere verificación de teléfono vía Firebase
                    guard let dataDict = jsonResponse["data"] as? [String: Any] else {
                        self.showToastAlert(senderVC: self, messageStr: "Error: datos incompletos")
                        return
                    }

                    if let error = dataDict["error"] as? String {
                        print("❌ Firebase config error:", error)
                        self.showToastAlert(senderVC: self, messageStr: "Error de configuración. Contacta soporte.")
                        return
                    }

                    self.pendingVerificationToken = dataDict["verification_token"] as? String
                    self.firebaseConfig = dataDict["firebase_config"] as? [String: Any]

                    guard self.pendingVerificationToken != nil, self.firebaseConfig != nil else {
                        self.showToastAlert(senderVC: self, messageStr: "Error: datos incompletos del servidor")
                        return
                    }

                    let fullPhone = "+\(self.mobileNumberTxt.text ?? "")"

                    self.configureFirebase()
                    self.startPhoneVerification(phoneNumber: fullPhone)

                } else if code == 400, jsonResponse["message"] as? String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: "Token is Expired")
                } else {
                    self.showToastAlert(senderVC: self, messageStr: jsonResponse["message"] as? String ?? "Error occurred")
                }

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                self.showToastAlert(senderVC: self, messageStr: "Network error occurred")
            }
        }
    }
    
    func configureFirebase() {
        guard let config = firebaseConfig,
              let apiKey = config["apiKey"] as? String,
              let projectId = config["projectId"] as? String,
              let appId = config["appId"] as? String,
              let messagingSenderId = config["messagingSenderId"] as? String else {
            print("❌ Error: Firebase config incompleta")
            return
        }

        if let existingApp = FirebaseApp.app(name: "PhoneAuthApp") {
            existingApp.delete { _ in }
        }

        let options = FirebaseOptions(googleAppID: appId, gcmSenderID: messagingSenderId)
        options.apiKey = apiKey
        options.projectID = projectId
        if let storageBucket = config["storageBucket"] as? String {
            options.storageBucket = storageBucket
        }
        options.bundleID = Bundle.main.bundleIdentifier ?? "com.deliverees.customer"
        if let clientId = config["clientId"] as? String, !clientId.isEmpty {
            options.clientID = clientId
        }

        FirebaseApp.configure(name: "PhoneAuthApp", options: options)
        print("✅ Firebase PhoneAuthApp configurado (update profile)")
    }

    func startPhoneVerification(phoneNumber: String) {
        print("📞 [UPDATE] Iniciando verificación para:", phoneNumber)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let app = FirebaseApp.app(name: "PhoneAuthApp") else {
                print("❌ [UPDATE] Firebase PhoneAuthApp no encontrada")
                self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
                return
            }
            
            print("✅ [UPDATE] Firebase PhoneAuthApp obtenida, llamando a verifyPhoneNumber...")

            let auth = Auth.auth(app: app)
            PhoneAuthProvider.provider(auth: auth).verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("❌ [UPDATE] Error en verificación:", error.localizedDescription)
                    if let authError = error as NSError? {
                        print("❌ [UPDATE] Código:", authError.code, "Dominio:", authError.domain)
                    }
                    self.showToastAlert(senderVC: self, messageStr: "Error: \(error.localizedDescription)")
                    return
                }
                print("✅ [UPDATE] Código enviado. VerificationID:", verificationID ?? "nil")
                self.verificationID = verificationID
                self.showVerificationCodeInput()
            }
        }
    }

    func showVerificationCodeInput() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Código de verificación")
        txt.keyboardType = .numberPad

        alert.addButton("Verificar") {
            let code = txt.text ?? ""
            if code.count < 6 {
                self.showToastAlert(senderVC: self, messageStr: "El código debe tener 6 dígitos")
            } else {
                self.verifyCode(code: code)
            }
        }

        alert.showCustom("Verificación de Teléfono", subTitle: "Ingresa el código enviado a tu nuevo número", color: AppLightOrange, icon: UIImage(named: "ic_phone")!)
    }

    func verifyCode(code: String) {
        guard let verificationID = verificationID,
              let app = FirebaseApp.app(name: "PhoneAuthApp") else {
            self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
            return
        }

        self.showLoadingIndicator(senderVC: self)
        let auth = Auth.auth(app: app)
        let credential = PhoneAuthProvider.provider(auth: auth).credential(withVerificationID: verificationID, verificationCode: code)

        auth.signIn(with: credential) { authResult, error in
            if let error = error {
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: "Código inválido")
                print("❌ Error verificando:", error.localizedDescription)
                return
            }

            authResult?.user.getIDToken { idToken, error in
                guard let idToken = idToken, error == nil else {
                    self.stopLoadingIndicator(senderVC: self)
                    self.showToastAlert(senderVC: self, messageStr: "Error al obtener token")
                    return
                }
                self.confirmPhoneVerification(idToken: idToken)
            }
        }
    }

    func confirmPhoneVerification(idToken: String) {
        guard let verificationToken = pendingVerificationToken else {
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error: falta el token de verificación")
            return
        }

        let finalURL = BASEURL_CUSTOMER + PROFILE_UPDATE_OTP // debe apuntar a customer_update_account_with_otp
        let tokenString = "Bearer \(login_session.object(forKey: "user_token") as! String)"
        let headers: HTTPHeaders = ["Authorization": tokenString]

        let params: [String: String] = [
            "lang": "en",
            "verification_token": verificationToken,
            "firebase_id_token": idToken
        ]

        AF.request(finalURL, method: .post, parameters: params, headers: headers)
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                self.stopLoadingIndicator(senderVC: self)

                switch response.result {
                case .success(let value):
                    guard let jsonResponse = value as? [String: Any],
                          let code = jsonResponse["code"] as? Int else {
                        self.showToastAlert(senderVC: self, messageStr: "Invalid response")
                        return
                    }

                    if code == 200 {
                        if let app = FirebaseApp.app(name: "PhoneAuthApp") {
                            app.delete { _ in }
                        }
                        self.showSuccessPopUp(msgStr: jsonResponse["message"] as? String ?? "Actualizado")
                    } else {
                        self.showToastAlert(senderVC: self, messageStr: jsonResponse["message"] as? String ?? "Error al confirmar")
                    }

                case .failure(let error):
                    print("❌ Error:", error.localizedDescription)
                    self.showToastAlert(senderVC: self, messageStr: "Error de red")
                }
            }
    }
    
    func showOTPVerifyView(otpNumber:String){
        gettingOtp = otpNumber
        self.transpertantView.isHidden = false
        self.transpertantView.backgroundColor = BlackTranspertantColor
        numberoneLbl.layer.cornerRadius = 3.0
        numberoneLbl.layer.borderWidth = 0.5
        numberoneLbl.layer.borderColor = AppDarkOrange.cgColor
        numberTwoLbl.layer.cornerRadius = 3.0
        numberTwoLbl.layer.borderWidth = 0.5
        numberTwoLbl.layer.borderColor = AppDarkOrange.cgColor
        numerbThreeLbl.layer.cornerRadius = 3.0
        numerbThreeLbl.layer.borderWidth = 0.5
        numerbThreeLbl.layer.borderColor = AppDarkOrange.cgColor
        numberFourLbl.layer.cornerRadius = 3.0
        numberFourLbl.layer.borderWidth = 0.5
        numberFourLbl.layer.borderColor = AppDarkOrange.cgColor
        numberFiveLbl.layer.cornerRadius = 3.0
        numberFiveLbl.layer.borderWidth = 0.5
        numberFiveLbl.layer.borderColor = AppDarkOrange.cgColor
        numberSixLbl.layer.cornerRadius = 3.0
        numberSixLbl.layer.borderWidth = 0.5
        numberSixLbl.layer.borderColor = AppDarkOrange.cgColor
        let numbers = Array(otpNumber)
        numberoneLbl.text = "\(numbers[0])"
        numberTwoLbl.text = "\(numbers[1])"
        numerbThreeLbl.text = "\(numbers[2])"
        numberFourLbl.text = "\(numbers[3])"
        numberFiveLbl.text = "\(numbers[4])"
        numberSixLbl.text = "\(numbers[5])"
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 16.0)!,
            kButtonFont: UIFont(name: "TruenoRg", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        let timeoutValue: TimeInterval = 2.0
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
            print("Timeout occurred")
        }
        
        _ = alert.showCustom(LanguageDictonary.object(forKey: "success") as! String, subTitle: msgStr, color: color, icon: icon!, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction), circleIconImage: icon!)
    }
    @IBAction func otpVerifyBtnAction(_ sender: Any) {
        transpertantView.isHidden = true
        let mobilenNo2 = self.resultDict.object(forKey: "user_phone2")as? String ?? ""
        
        self.showLoadingIndicator(senderVC: self)
        
        requestOtpVerify()
    }
    
    func requestOtpVerify() {
        self.showLoadingIndicator(senderVC: self)
        
        let finalURL = BASEURL_CUSTOMER + PROFILE_UPDATE_OTP
        let tokenString = "Bearer \(login_session.object(forKey: "user_token") as! String)"
        
        let headers: HTTPHeaders = [
            "Authorization": tokenString
        ]
        
        let params: [String: String] = [
            "lang": "en",
            "cus_name": userNameTxt.text ?? "",
            "cus_email": emailTxt.text ?? "",
            "cus_phone1": mobileNumberTxt.text ?? "",
            "cus_phone2": resultDict.object(forKey: "user_phone2") as? String ?? "",
            "cus_address": userLocationStr,
            "cus_lat": userLatitude,
            "cus_long": userLongitude,
            "otp": gettingOtp,
            "current_otp": gettingOtp
        ]
        
        // ✅ NUEVO FORMATO ALAMOFIRE 5.8
        AF.upload(
            multipartFormData: { multipartFormData in
                // Agregar parámetros
                for (key, value) in params {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                
                // Agregar imagen
                if let imageData = self.userImageView.image?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(
                        imageData,
                        withName: "cus_image",
                        fileName: "profile.jpeg",
                        mimeType: "image/jpeg"
                    )
                }
            },
            to: finalURL,
            method: .post,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { [weak self] response in
            guard let self = self else { return }
            
            self.stopLoadingIndicator(senderVC: self)
            
            switch response.result {
            case .success(let value):
                guard let jsonResponse = value as? [String: Any] else {
                    self.showToastAlert(senderVC: self, messageStr: "Invalid response")
                    return
                }
                
                print("✅ Response: \(jsonResponse)")
                
                if let code = jsonResponse["code"] as? Int {
                    if code == 200 {
                        self.showSuccessPopUp(msgStr: jsonResponse["message"] as! String)
                    } else if code == 201 {
                        if let tempData = jsonResponse["data"] as? [String: Any],
                           let otp = tempData["otp"] as? String {
                            self.showOTPVerifyView(otpNumber: otp)
                        }
                    } else if code == 400,
                              jsonResponse["message"] as? String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: "Token is Expired")
                    } else {
                        self.showToastAlert(
                            senderVC: self,
                            messageStr: jsonResponse["message"] as? String ?? "Error occurred"
                        )
                    }
                }
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                self.showToastAlert(senderVC: self, messageStr: "Network error occurred")
            }
        }
    }
    
}
