//
//  LoginViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import CryptoKit
import SCLAlertView
import UserNotifications
import AppTrackingTransparency

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var socialLoginLbl: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginTitleLbl: UILabel!
    @IBOutlet weak var userLoginDataView: UIView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var fbBtnSignIn: FBLoginButton!
    private var googleBtnSignIn: GIDSignInButton!
    private var btnAppleSignIn: ASAuthorizationAppleIDButton!
    // 🔥 NUEVAS PROPIEDADES PARA VERIFICACIÓN
    private var pendingVerificationUserId: Int?
    private var pendingVerificationPhone: String?
    private var firebaseVerificationConfig: [String: Any]?
    private var verificationID: String?
    
    @IBOutlet weak var socialSignInButtonsStackView: UIStackView!
    
    var iPhoneUDIDString = String()
    var isRegister = Bool()
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSocialButtons()
        
        // Configuración de textos
        self.loginTitleLbl.text = ""
        self.userNameTxt.placeholder = LanguageDictonary.object(forKey: "email") as! String
        self.passwordTxt.placeholder = LanguageDictonary.object(forKey: "password") as! String
        self.goBtn.setTitle(LanguageDictonary.object(forKey: "btn_login") as! String, for: .normal)
        self.forgetPasswordBtn.setTitle(LanguageDictonary.object(forKey: "forgotpassword") as! String, for: .normal)
        self.socialLoginLbl.text = LanguageDictonary.object(forKey: "continue_with") as! String
        self.signUpBtn.setTitle(LanguageDictonary.object(forKey: "signup") as! String, for: .normal)
        
        self.signUpBtn.layer.borderWidth = 2
        self.signUpBtn.layer.borderColor = UIColor.red.cgColor
        
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        userNameTxt.delegate = self
        passwordTxt.delegate = self
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.ConnectToFCM()
        
        // Configuración de campos de texto
        userNameTxt.setPadding(left: 30, right: 0, imageName: "ic_user_email")
        passwordTxt.setPadding(left: 30, imageName: "ic_user_password")
        
        // Configurar show/hide password
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
        
        // ✅ VERIFICACIÓN DE CONFIGURACIÓN DE GOOGLE SIGN IN (solo en DEBUG)
        #if DEBUG
        print("\n🔍 ========== GOOGLE SIGN IN DEBUG ==========")
        print("🔍 Configuration exists: \(GIDSignIn.sharedInstance.configuration != nil)")
        
        if let config = GIDSignIn.sharedInstance.configuration {
            print("🔍 Client ID: \(String(config.clientID.prefix(30)))...")
        } else {
            print("❌ WARNING: Google Sign In NO está configurado!")
            print("❌ Verifica que AppDelegate esté cargando GoogleService-Info.plist")
        }
        
        // Verificar URL Schemes en Info.plist
        if let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] {
            print("🔍 URL Schemes configurados en Info.plist:")
            for urlType in urlTypes {
                if let schemes = urlType["CFBundleURLSchemes"] as? [String],
                   let name = urlType["CFBundleURLName"] as? String {
                    if name.contains("google") {
                        print("   ✅ Google Scheme: \(schemes.first ?? "none")")
                        
                        // Verificar que coincida con el esperado
                        if let expectedScheme = schemes.first,
                           expectedScheme == "com.googleusercontent.apps.802377568198-ck0p6fn9irk8803na2c12f18aseh0tvm" {
                            print("   ✅ URL Scheme CORRECTO")
                        } else {
                            print("   ⚠️ URL Scheme puede ser incorrecto")
                        }
                    }
                }
            }
        } else {
            print("❌ NO se encontraron URL Schemes en Info.plist")
        }
        
        // Verificar GoogleService-Info.plist
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) {
            print("🔍 GoogleService-Info.plist encontrado:")
            if let clientID = plist["CLIENT_ID"] as? String {
                print("   ✅ CLIENT_ID: \(String(clientID.prefix(30)))...")
            }
            if let reversedClientID = plist["REVERSED_CLIENT_ID"] as? String {
                print("   ✅ REVERSED_CLIENT_ID: \(reversedClientID)")
            }
        } else {
            print("❌ GoogleService-Info.plist NO encontrado")
        }
        
        print("==========================================\n")
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PermissionsManager.shared.requestAuthorizationAndNotificationsPermissions()
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
    
    @objc func handleAppleIdRequest(_ sender: Any?) {
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
    
    // ✅ FACEBOOK LOGIN - Gesture Recognizer
    @objc func imagedTapedBtnFb(tapGestureRecognizer:UITapGestureRecognizer) {
        if (Reachability()?.isReachable)! {
            self.showLoadingIndicator(senderVC: self)
            self.loginManager.logOut()
            self.loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.stopLoadingIndicator(senderVC: self)
                    print("Facebook login error: \(error)")
                    return
                }
                
                guard let result = result, !result.isCancelled else {
                    self.stopLoadingIndicator(senderVC: self)
                    print("Facebook login cancelled")
                    return
                }
                
                let hasEmail = result.grantedPermissions.contains("email")
                if !hasEmail {
                    self.loginManager.logOut()
                    self.stopLoadingIndicator(senderVC: self)
                    return
                }
                
                self.getFBUserData()
            }
        }
    }
    
    // ✅ GOOGLE LOGIN - Gesture Recognizer
    @objc func imagedTapedGoogleBtnSignIn(tapGestureRecognizer:UITapGestureRecognizer) {
        if (Reachability()?.isReachable)! {
            self.showLoadingIndicator(senderVC: self)
            
            guard let presentingVC = self.view.window?.rootViewController else {
                self.stopLoadingIndicator(senderVC: self)
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] signInResult, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.stopLoadingIndicator(senderVC: self)
                    print("Google Sign In Error: \(error.localizedDescription)")
                    return
                }
                
                guard let signInResult = signInResult else {
                    self.stopLoadingIndicator(senderVC: self)
                    return
                }
                
                self.handleGoogleSignIn(signInResult: signInResult)
            }
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
                self.logoImg.image = UIImage(named: "app_logo")
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
            }
            
        }, onFailure: {errorResponse in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- TextFiled delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Button Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
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
                
                Parse.NormalEmailLoginParse(lang: login_session.value(forKey: "Language") as? String ?? "es",
                                           login_id: emailStr!,
                                           cus_password: passwordStr!,
                                           ios_fcm_id: fcmToken,
                                           type: device_type,
                                           ios_device_id: iPhoneUDIDString,
                                           onSuccess: { response in
                    print(response)
                    
                    // ✅ PRIMERO VERIFICAR SI ES TOKEN EXPIRADO
                    if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                        self.stopLoadingIndicator(senderVC: self)
                        return
                    }
                    
                    // ✅ MANEJO PRINCIPAL DE RESPUESTAS
                    if response.object(forKey: "code") as! Int == 200 {
                        // ✅ LOGIN EXITOSO
                        let dataDict = NSMutableDictionary()
                        dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                        
                        let user_email = dataDict.object(forKey: "user_email") as! String
                        let user_id = dataDict.object(forKey: "user_id")
                        let user_name = dataDict.object(forKey: "user_name") as! String
                        let phone = dataDict.object(forKey: "user_phone") as! String
                        let token = dataDict.object(forKey: "token") as! String
                        
                        // 🔥 NUEVO: VERIFICAR SI EL TELÉFONO ESTÁ VERIFICADO
                        if let phoneVerified = dataDict.object(forKey: "phone_verified") as? Int,
                           phoneVerified == 0,
                           !phone.isEmpty {
                            
                            print("📱 Teléfono NO verificado. Redirigiendo a verificación...")
                            
                            // Guardar datos en sesión temporalmente
                            login_session.setValue(user_email, forKey: "user_email")
                            login_session.setValue("0", forKey: "userCartCount")
                            login_session.setValue(user_id, forKey: "user_id")
                            login_session.setValue(user_name, forKey: "user_name")
                            login_session.setValue(phone, forKey: "user_mobileNo")
                            login_session.setValue(token, forKey: "user_token")
                            login_session.setUserLogged(true)
                            login_session.synchronize()
                            
                            // Guardar datos para verificación
                            self.pendingVerificationUserId = user_id as? Int
                            self.pendingVerificationPhone = phone
                            
                            // Extraer configuración Firebase si está disponible
                            if let firebaseConfig = dataDict.object(forKey: "firebase_config") as? [String: Any] {
                                self.firebaseVerificationConfig = firebaseConfig
                            }
                            
                            self.stopLoadingIndicator(senderVC: self)
                            
                            // Mostrar alerta de verificación
                            self.showPhoneVerificationAlert(
                                phoneNumber: phone,
                                email: user_email,
                                userName: user_name
                            )
                            
                        } else {
                            // ✅ TELÉFONO YA VERIFICADO - FLUJO NORMAL
                            login_session.setValue(user_email, forKey: "user_email")
                            login_session.setValue("0", forKey: "userCartCount")
                            login_session.setValue(user_id, forKey: "user_id")
                            login_session.setValue(user_name, forKey: "user_name")
                            login_session.setValue(phone, forKey: "user_mobileNo")
                            login_session.setValue(token, forKey: "user_token")
                            login_session.setUserLogged(true)
                            login_session.synchronize()
                            
                            self.stopLoadingIndicator(senderVC: self)
                            
                            // ✅ VERIFICAR SI YA TIENE UBICACIÓN GUARDADA
                            if login_session.object(forKey: "user_longitude") != nil {
                                self.dismiss(animated: true)
                                return
                            }
                            
                            // ✅ NAVEGAR A PEDIR UBICACIÓN
                            MapLocationPageFrom = "login"
                            AppRouter.shared.presentLocationOption(from: self, comingType: "FIRST")
                        }
                        
                    } else if response.object(forKey: "code") as! Int == 403 {
                        // 🔥 CÓDIGO 403 - VERIFICACIÓN DE TELÉFONO REQUERIDA
                        self.stopLoadingIndicator(senderVC: self)
                        
                        // Intentar extraer datos del usuario
                        if let data = response.object(forKey: "data") as? [String: Any] {
                            print("📱 Datos de verificación recibidos:", data)
                            
                            // Guardar datos para verificación
                            self.pendingVerificationUserId = data["user_id"] as? Int
                            self.pendingVerificationPhone = data["user_phone"] as? String
                            self.firebaseVerificationConfig = data["firebase_config"] as? [String: Any]
                            
                            // Guardar en sesión temporalmente
                            if let userId = data["user_id"] as? Int,
                               let userEmail = data["user_email"] as? String,
                               let userName = data["user_name"] as? String {
                                
                                login_session.setValue(userEmail, forKey: "user_email")
                                login_session.setValue("0", forKey: "userCartCount")
                                login_session.setValue(userId, forKey: "user_id")
                                login_session.setValue(userName, forKey: "user_name")
                                login_session.setValue(data["user_phone"] as? String ?? "", forKey: "user_mobileNo")
                                login_session.synchronize()
                            }
                            
                            // Mostrar alerta de verificación
                            self.showPhoneVerificationAlert(
                                phoneNumber: data["user_phone"] as? String ?? "",
                                email: data["user_email"] as? String ?? "",
                                userName: data["user_name"] as? String ?? ""
                            )
                            
                        } else {
                            // Mostrar mensaje genérico
                            let message = response.object(forKey: "message") as? String ?? "Verificación de teléfono requerida"
                            self.showToastAlert(senderVC: self, messageStr: message)
                        }
                        
                    } else {
                        // ⚠️ OTROS ERRORES (401, 404, etc.)
                        self.stopLoadingIndicator(senderVC: self)
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    }
                    
                }, onFailure: { errorResponse in
                    self.stopLoadingIndicator(senderVC: self)
                    self.showToastAlert(senderVC: self, messageStr: "Error de conexión")
                })
            }
        }
    }
    
    // MARK: - Métodos para Verificación Telefónica

    private func showPhoneVerificationAlert(phoneNumber: String, email: String, userName: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Verificar Ahora") {
            print("🔍 Iniciando verificación para: \(phoneNumber)")
            self.sendPhoneVerificationCode(phoneNumber: phoneNumber)
        }
        
        alert.addButton("Posponer") {
            print("⏰ El usuario pospuso la verificación")
            self.showToastAlert(senderVC: self, messageStr: "Podrás verificar tu teléfono más tarde desde tu perfil.")
            
            // Limpiar sesión temporal si el usuario pospone
            login_session.removeObject(forKey: "user_email")
            login_session.removeObject(forKey: "user_id")
            login_session.removeObject(forKey: "user_name")
            login_session.removeObject(forKey: "user_mobileNo")
            login_session.removeObject(forKey: "user_token")
            login_session.synchronize()
        }
        
        let icon = UIImage(named: "ic_phone")
        let maskedPhone = self.maskPhoneNumber(phoneNumber)
        
        alert.showCustom(
            "Verificación Requerida",
            subTitle: "Tu número \(maskedPhone) necesita verificación. ¿Deseas verificarlo ahora?",
            color: AppLightOrange,
            icon: icon!
        )
    }

    private func maskPhoneNumber(_ phone: String) -> String {
        guard phone.count > 4 else { return phone }
        let start = phone.prefix(3)
        let end = phone.suffix(4)
        return "\(start)****\(end)"
    }

    private func sendPhoneVerificationCode(phoneNumber: String) {
        self.showLoadingIndicator(senderVC: self)
        
        // Configurar Firebase
        self.configureFirebaseForVerification { [weak self] success in
            guard let self = self else { return }
            
            if !success {
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
                return
            }
            
            // Enviar código de verificación
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.executePhoneVerification(phoneNumber: phoneNumber)
            }
        }
    }

    private func configureFirebaseForVerification(completion: @escaping (Bool) -> Void) {
        // Si tenemos configuración del backend, usarla
        if let config = self.firebaseVerificationConfig {
            self.configureFirebaseWithBackendConfig(config: config, completion: completion)
        } else {
            // Si no, usar Firebase por defecto
            if FirebaseApp.app() == nil {
                if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
                    FirebaseApp.configure()
                    print("✅ Firebase configurado con GoogleService-Info.plist")
                    completion(true)
                } else {
                    print("❌ No se encontró GoogleService-Info.plist")
                    completion(false)
                }
            } else {
                print("✅ Firebase ya está configurado")
                completion(true)
            }
        }
    }

    private func configureFirebaseWithBackendConfig(config: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let apiKey = config["apiKey"] as? String,
              let appId = config["appId"] as? String,
              let messagingSenderId = config["messagingSenderId"] as? String,
              let projectId = config["projectId"] as? String else {
            print("❌ Configuración Firebase incompleta")
            completion(false)
            return
        }
        
        // Crear nueva app de Firebase para verificación
        let appName = "PhoneVerification_\(UUID().uuidString.prefix(8))"
        
        let options = FirebaseOptions(
            googleAppID: appId,
            gcmSenderID: messagingSenderId
        )
        options.apiKey = apiKey
        options.projectID = projectId
        
        if let storageBucket = config["storageBucket"] as? String {
            options.storageBucket = storageBucket
        }
        
        if let clientId = config["clientId"] as? String {
            options.clientID = clientId
        }
        
        options.bundleID = Bundle.main.bundleIdentifier ?? "com.deliverees.customer"
        
        FirebaseApp.configure(name: appName, options: options)
        print("✅ Firebase configurado para verificación: \(appName)")
        completion(true)
    }

    private func executePhoneVerification(phoneNumber: String) {
        // Encontrar la app de Firebase configurada
        let firebaseApps = FirebaseApp.allApps ?? [:]
        let verificationAppName = firebaseApps.keys.first { $0.contains("PhoneVerification") } ?? "__FIRAPP_DEFAULT"
        
        guard let app = FirebaseApp.app(name: verificationAppName) ?? FirebaseApp.app() else {
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
            return
        }
        
        let auth = Auth.auth(app: app)
        
        print("📞 Enviando código a: \(phoneNumber)")
        
        PhoneAuthProvider.provider(auth: auth).verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            guard let self = self else { return }
            
            self.stopLoadingIndicator(senderVC: self)
            
            if let error = error {
                print("❌ Error enviando código:", error.localizedDescription)
                self.showVerificationErrorAlert(message: "Error al enviar código: \(error.localizedDescription)")
                return
            }
            
            self.verificationID = verificationID
            print("✅ Código enviado")
            
            // Mostrar alerta para ingresar código
            self.showCodeInputAlert()
        }
    }

    private func showCodeInputAlert() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let codeTextField = alert.addTextField("Código de 6 dígitos")
        codeTextField.keyboardType = .numberPad
        
        alert.addButton("Verificar") {
            guard let code = codeTextField.text, !code.isEmpty else {
                self.showToastAlert(senderVC: self, messageStr: "Ingresa el código de verificación")
                return
            }
            
            if code.count != 6 {
                self.showToastAlert(senderVC: self, messageStr: "El código debe tener 6 dígitos")
                return
            }
            
            self.verifyPhoneCode(code: code)
        }
        
        alert.addButton("Reenviar Código") {
            if let phone = self.pendingVerificationPhone {
                self.sendPhoneVerificationCode(phoneNumber: phone)
            }
        }
        
        let icon = UIImage(named: "ic_phone")
        let maskedPhone = self.pendingVerificationPhone.map { self.maskPhoneNumber($0) } ?? ""
        
        alert.showCustom(
            "Código de Verificación",
            subTitle: "Ingresa el código de 6 dígitos enviado a \(maskedPhone):",
            color: AppLightOrange,
            icon: icon!
        )
    }

    private func verifyPhoneCode(code: String) {
        guard let verificationID = self.verificationID,
              let userId = self.pendingVerificationUserId,
              let phoneNumber = self.pendingVerificationPhone else {
            self.showToastAlert(senderVC: self, messageStr: "Error: Datos incompletos")
            return
        }
        
        self.showLoadingIndicator(senderVC: self)
        
        // Encontrar la app de Firebase
        let firebaseApps = FirebaseApp.allApps ?? [:]
        let verificationAppName = firebaseApps.keys.first { $0.contains("PhoneVerification") } ?? "__FIRAPP_DEFAULT"
        
        guard let app = FirebaseApp.app(name: verificationAppName) ?? FirebaseApp.app() else {
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
            return
        }
        
        let auth = Auth.auth(app: app)
        let credential = PhoneAuthProvider.provider(auth: auth).credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        auth.signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.stopLoadingIndicator(senderVC: self)
                print("❌ Error verificando código:", error.localizedDescription)
                self.showVerificationErrorAlert(message: "Código inválido o expirado")
                return
            }
            
            // Obtener token de Firebase
            authResult?.user.getIDToken { [weak self] idToken, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.stopLoadingIndicator(senderVC: self)
                    print("❌ Error obteniendo token:", error.localizedDescription)
                    self.showToastAlert(senderVC: self, messageStr: "Error al verificar")
                    return
                }
                
                guard let idToken = idToken else {
                    self.stopLoadingIndicator(senderVC: self)
                    self.showToastAlert(senderVC: self, messageStr: "Error al obtener token")
                    return
                }
                
                // Confirmar verificación con backend
                self.confirmVerificationWithBackend(
                    userId: userId,
                    phoneNumber: phoneNumber,
                    idToken: idToken
                )
            }
        }
    }

    private func confirmVerificationWithBackend(userId: Int, phoneNumber: String, idToken: String) {
        let Parse = CommomParsing()
        
        Parse.verifyPhoneToken(
            userId: userId,
            phoneNumber: phoneNumber,
            idToken: idToken,
            credentialType: "AppiOS_SMS_customer",
            lang: login_session.value(forKey: "Language") as? String ?? "es",
            onSuccess: { [weak self] response in
                guard let self = self else { return }
                
                self.stopLoadingIndicator(senderVC: self)
                
                if response.object(forKey: "code") as! Int == 200 {
                    print("✅ Verificación completada")
                    
                    // Mostrar éxito y hacer login automático
                    self.showVerificationSuccessAndLogin()
                    
                } else {
                    let message = response.object(forKey: "message") as? String ?? "Error al verificar"
                    self.showToastAlert(senderVC: self, messageStr: message)
                }
            },
            onFailure: { [weak self] errorResponse in
                guard let self = self else { return }
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: "Error de conexión")
            }
        )
    }

    private func showVerificationSuccessAndLogin() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Continuar") {
            // Hacer login automático con las credenciales ya ingresadas
            if let email = self.userNameTxt.text,
               let password = self.passwordTxt.text {
                self.performAutoLogin(email: email, password: password)
            }
        }
        
        let icon = UIImage(named: "success_tick")
        let color = UIColor(red: 0.2, green: 0.7, blue: 0.2, alpha: 1.0)
        
        alert.showCustom(
            "¡Verificado!",
            subTitle: "Tu número ha sido verificado. Continuando con el login...",
            color: color,
            icon: icon!,
            circleIconImage: icon!
        )
    }

    private func performAutoLogin(email: String, password: String) {
        self.showLoadingIndicator(senderVC: self)
        
        let Parse = CommomParsing()
        let fcmToken = login_session.object(forKey: "fcmToken") as? String ?? ""
        
        Parse.NormalEmailLoginParse(
            lang: login_session.value(forKey: "Language") as? String ?? "es",
            login_id: email,
            cus_password: password,
            ios_fcm_id: fcmToken,
            type: device_type,
            ios_device_id: iPhoneUDIDString,
            onSuccess: { response in
                self.stopLoadingIndicator(senderVC: self)
                
                if response.object(forKey: "code") as! Int == 200 {
                    let dataDict = NSMutableDictionary()
                    dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                    
                    let user_email = dataDict.object(forKey: "user_email") as! String
                    let user_id = dataDict.object(forKey: "user_id")
                    let user_name = dataDict.object(forKey: "user_name") as! String
                    let phone = dataDict.object(forKey: "user_phone") as! String
                    let token = dataDict.object(forKey: "token") as! String
                    
                    login_session.setValue(user_email, forKey: "user_email")
                    login_session.setValue("0", forKey: "userCartCount")
                    login_session.setValue(user_id, forKey: "user_id")
                    login_session.setValue(user_name, forKey: "user_name")
                    login_session.setValue(phone, forKey: "user_mobileNo")
                    login_session.setValue(token, forKey: "user_token")
                    login_session.setUserLogged(true)
                    login_session.synchronize()
                    
                    // Limpiar datos temporales
                    self.pendingVerificationUserId = nil
                    self.pendingVerificationPhone = nil
                    self.firebaseVerificationConfig = nil
                    self.verificationID = nil
                    
                    // Navegar a ubicación
                    if login_session.object(forKey: "user_longitude") != nil {
                        self.dismiss(animated: true)
                        return
                    }
                    
                    MapLocationPageFrom = "login"
                    AppRouter.shared.presentLocationOption(from: self, comingType: "FIRST")
                    
                } else {
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
            },
            onFailure: { errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: "Error de conexión")
            }
        )
    }

    private func showVerificationErrorAlert(message: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: true
        )
        
        let alert = SCLAlertView(appearance: appearance)
        alert.showError("Error", subTitle: message)
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // ✅ GOOGLE LOGIN - Button Action (NUEVA IMPLEMENTACIÓN 7.x)
    @IBAction func googleBtnAction(_ sender: Any?) {
        print("\n🔍 ========== GOOGLE SIGN IN ==========")
        
        guard Reachability()?.isReachable ?? false else {
            self.showToastAlert(senderVC: self, messageStr: "No hay conexión a Internet")
            return
        }
        
        self.showLoadingIndicator(senderVC: self)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootVC = window.rootViewController else {
            print("❌ No se pudo obtener rootViewController")
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
            return
        }
        
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        print("🔍 Presenting from: \(type(of: topVC))")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [weak self] result, error in
            guard let self = self else { return }
            
            // ✅ SIEMPRE en hilo principal
            DispatchQueue.main.async {
                
                if let error = error {
                    let nsError = error as NSError
                    print("❌ Google Sign In Error: \(error.localizedDescription)")
                    print("❌ Code: \(nsError.code), Domain: \(nsError.domain)")
                    self.stopLoadingIndicator(senderVC: self)
                    // -5 = usuario canceló, no mostrar error
                    if nsError.code != -5 {
                        self.showToastAlert(senderVC: self, messageStr: "Error al iniciar sesión con Google")
                    }
                    return
                }
                
                guard let result = result else {
                    print("❌ No result from Google Sign In")
                    self.stopLoadingIndicator(senderVC: self)
                    return
                }
                
                print("✅ Google Sign In exitoso")
                print("   - Email: \(result.user.profile?.email ?? "nil")")
                print("   - Name: \(result.user.profile?.name ?? "nil")")
                
                // ✅ AHORA SÍ LLAMA A handleGoogleSignIn
                self.handleGoogleSignIn(signInResult: result)
            }
        }
        
        print("🔍 signIn() llamado")
        print("========================================\n")
    }
    
    // PASO 2: Agrega este nuevo método privado
    private func performGoogleSignIn() {
        // Obtener el presenting ViewController correcto
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }),
              let rootVC = window.rootViewController else {
            print("❌ No se pudo obtener rootViewController")
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error al inicializar Google Sign In")
            return
        }
        
        // Encontrar el ViewController más alto en la jerarquía
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        print("✅ Iniciando Google Sign In desde: \(type(of: topVC))")
        
        // Configurar Google Sign In
        let config = GIDConfiguration(clientID: GOOGLE_CLIENT_ID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Realizar el Sign In
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            // Manejar error
            if let error = error {
                let nsError = error as NSError
                print("❌ Google Sign In Error: \(error.localizedDescription)")
                print("❌ Error domain: \(nsError.domain), code: \(nsError.code)")
                
                self.stopLoadingIndicator(senderVC: self)
                
                // -5 = usuario canceló
                if nsError.code != -5 {
                    self.showToastAlert(senderVC: self, messageStr: "Error al iniciar sesión con Google")
                } else {
                    print("ℹ️ Usuario canceló el login")
                }
                return
            }
            
            // Manejar éxito
            guard let signInResult = signInResult else {
                print("❌ No se obtuvo resultado de Google Sign In")
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: "Error al obtener datos de Google")
                return
            }
            
            print("✅ Google Sign In exitoso")
            print("✅ User ID: \(signInResult.user.userID ?? "nil")")
            print("✅ Email: \(signInResult.user.profile?.email ?? "nil")")
            print("✅ Name: \(signInResult.user.profile?.name ?? "nil")")
            
            // Procesar el login
            self.handleGoogleSignIn(signInResult: signInResult)
        }
    }

    // PASO 3: Método auxiliar para procesar el login
    private func handleGoogleSignIn(signInResult: GIDSignInResult) {
        let user = signInResult.user
        let idStr = user.userID ?? ""
        let emailStr = user.profile?.email ?? ""
        let nameStr = user.profile?.name ?? ""
        
        // Validar que tenemos los datos necesarios
        guard !idStr.isEmpty, !emailStr.isEmpty else {
            print("❌ Datos de Google incompletos")
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "No se pudieron obtener datos de Google")
            return
        }
        
        #if DEBUG
        print("📤 Enviando datos a API:")
        print("   - ID: \(idStr)")
        print("   - Email: \(emailStr)")
        print("   - Name: \(nameStr)")
        #endif
        
        let Parse = CommomParsing()
        Parse.GoogleLogin(
            lang: login_session.value(forKey: "Language") as? String ?? "es",
            google_id: idStr,
            email: emailStr,
            name: nameStr,
            type: device_type,
            ios_fcm_id: login_session.object(forKey: "fcmToken") as? String ?? "",
            ios_device_id: iPhoneUDIDString,
            onSuccess: { [weak self] response in
                guard let self = self else { return }
                
                #if DEBUG
                print("✅ Respuesta de API recibida:")
                print(response)
                #endif
                
                guard response.object(forKey: "code") as? Int == 200 else {
                    self.stopLoadingIndicator(senderVC: self)
                    let message = response.object(forKey: "message") as? String ?? "Error desconocido"
                    self.showToastAlert(senderVC: self, messageStr: message)
                    return
                }
                
                // Guardar datos del usuario
                let dataDict = NSMutableDictionary()
                dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                
                let user_email = dataDict.object(forKey: "user_email") as! String
                let user_id = String(dataDict.object(forKey: "user_id") as! Int)
                let user_name = dataDict.object(forKey: "user_name") as! String
                let phone = dataDict.object(forKey: "user_phone") as! String
                let token = dataDict.object(forKey: "token") as! String
                
                login_session.setValue(user_email, forKey: "user_email")
                login_session.setValue("0", forKey: "userCartCount")
                login_session.setValue(user_id, forKey: "user_id")
                login_session.setValue(user_name, forKey: "user_name")
                login_session.setValue(phone, forKey: "user_mobileNo")
                login_session.setValue(token, forKey: "user_token")
                login_session.setUserLogged(true)
                login_session.synchronize()
                
                self.stopLoadingIndicator(senderVC: self)
                
                #if DEBUG
                print("✅ Sesión guardada, navegando a LocationOptionPage")
                #endif
                
                // Navegar a la siguiente pantalla
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                nextViewController.ComingType = "FIRST"
                self.present(nextViewController, animated: true, completion: nil)
            },
            onFailure: { [weak self] errorResponse in
                guard let self = self else { return }
                
                print("❌ Error en API: \(errorResponse)")
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: "Error al conectar con el servidor")
            }
        )
    }
    
    // ✅ FACEBOOK LOGIN - Button Action
    @objc func fbBtnAction(_ sender: Any) {
        if (Reachability()?.isReachable)! {
            self.showLoadingIndicator(senderVC: self)
            self.loginManager.logOut()
            self.loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.stopLoadingIndicator(senderVC: self)
                    print("Facebook login error: \(error)")
                    return
                }
                
                guard let result = result, !result.isCancelled else {
                    self.stopLoadingIndicator(senderVC: self)
                    print("Facebook login cancelled")
                    return
                }
                
                let hasEmail = result.grantedPermissions.contains("email")
                if !hasEmail {
                    self.loginManager.logOut()
                    self.stopLoadingIndicator(senderVC: self)
                    return
                }
                
                self.getFBUserData()
            }
        }
    }
    
    // ✅ GET FACEBOOK USER DATA
    func getFBUserData() {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let responseDict = result as! NSDictionary
                    self.showLoadingIndicator(senderVC: self)
                    let Parse = CommomParsing()
                    let emailStr = responseDict.object(forKey: "email") as! String
                    let fb_idStr = responseDict.object(forKey: "id") as! String
                    let nameStr = responseDict.object(forKey: "name") as! String
                    
                    Parse.faceBookLogin(
                        lang: login_session.value(forKey: "Language") as? String ?? "es",
                        facebook_id: fb_idStr,
                        email: emailStr,
                        name: nameStr,
                        type: device_type,
                        ios_fcm_id: login_session.object(forKey: "fcmToken") as? String ?? "",
                        ios_device_id: self.iPhoneUDIDString,
                        onSuccess: { response in
                            print(response)
                            if (response.value(forKey: "code") as! Int == 200) {
                                let dataDict = NSMutableDictionary()
                                dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                                let user_email = dataDict.object(forKey: "user_email") as! String
                                let user_id = String(dataDict.object(forKey: "user_id") as! Int)
                                let user_name = dataDict.object(forKey: "user_name") as! String
                                let phone = dataDict.object(forKey: "user_phone") as! String
                                let token = dataDict.object(forKey: "token") as! String
                                
                                login_session.setValue(user_email, forKey: "user_email")
                                login_session.setValue("0", forKey: "userCartCount")
                                login_session.setValue(user_id, forKey: "user_id")
                                login_session.setValue(user_name, forKey: "user_name")
                                login_session.setValue(phone, forKey: "user_mobileNo")
                                login_session.setValue(token, forKey: "user_token")
                                login_session.setUserLogged(true)
                                login_session.synchronize()
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                                nextViewController.ComingType = "FIRST"
                                self.present(nextViewController, animated: true, completion: nil)
                            } else {
                                print("Failed")
                            }
                            self.stopLoadingIndicator(senderVC: self)
                        },
                        onFailure: { errorResponse in
                            self.stopLoadingIndicator(senderVC: self)
                        }
                    )
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

// ✅ APPLE SIGN IN - Extension completa
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                self.showToastAlert(senderVC: self, messageStr: "Error al obtener token de Apple")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.showToastAlert(senderVC: self, messageStr: "Error al procesar credenciales")
                return
            }
            
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Firebase Auth error: \(error.localizedDescription)")
                    self.showToastAlert(senderVC: self, messageStr: "Error al iniciar sesión con Apple")
                    return
                }
                
                guard let user = authResult?.user else {
                    print("No user data received")
                    self.showToastAlert(senderVC: self, messageStr: "No se pudo obtener información del usuario")
                    return
                }
                
                let email = user.email ?? ""
                let displayName = user.displayName ?? "Anonymous"
                
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("Unable to get user UID")
                    self.showToastAlert(senderVC: self, messageStr: "Error al obtener ID de usuario")
                    return
                }
                
                self.showLoadingIndicator(senderVC: self)
                let Parse = CommomParsing()
                
                Parse.AppleLogin(
                    lang: login_session.value(forKey: "Language") as? String ?? "es",
                    apple_id: uid,
                    email: email,
                    name: displayName,
                    type: device_type,
                    ios_fcm_id: login_session.object(forKey: "fcmToken") as? String ?? "",
                    ios_device_id: self.iPhoneUDIDString,
                    onSuccess: { response in
                        print("Apple Login Response: \(response)")
                        
                        if response.value(forKey: "code") as! Int == 200 {
                            let dataDict = NSMutableDictionary()
                            dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                            
                            let user_email = dataDict.object(forKey: "user_email") as! String
                            let user_id = String(dataDict.object(forKey: "user_id") as! Int)
                            let user_name = dataDict.object(forKey: "user_name") as! String
                            let phone = dataDict.object(forKey: "user_phone") as! String
                            let token = dataDict.object(forKey: "token") as! String
                            
                            login_session.setValue(user_email, forKey: "user_email")
                            login_session.setValue("0", forKey: "userCartCount")
                            login_session.setValue(user_id, forKey: "user_id")
                            login_session.setValue(user_name, forKey: "user_name")
                            login_session.setValue(phone, forKey: "user_mobileNo")
                            login_session.setValue(token, forKey: "user_token")
                            login_session.setUserLogged(true)
                            login_session.synchronize()
                            
                            self.stopLoadingIndicator(senderVC: self)
                            
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                            nextViewController.ComingType = "FIRST"
                            self.present(nextViewController, animated: true, completion: nil)
                            
                        } else {
                            self.stopLoadingIndicator(senderVC: self)
                            let message = response.object(forKey: "message") as? String ?? "Error en el inicio de sesión"
                            self.showToastAlert(senderVC: self, messageStr: message)
                            print("Apple Login Failed: \(message)")
                        }
                    },
                    onFailure: { errorResponse in
                        self.stopLoadingIndicator(senderVC: self)
                        self.showToastAlert(senderVC: self, messageStr: "Error al conectar con el servidor")
                        print("Apple Login API Error: \(errorResponse)")
                    }
                )
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error.localizedDescription)")
        
        if (error as NSError).code != 1001 {
            self.showToastAlert(senderVC: self, messageStr: "Error al iniciar sesión con Apple")
        }
    }
}

// ✅ PRESENTATION CONTEXT PROVIDER
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// ✅ CONFIGURE SOCIAL BUTTONS ACTUALIZADO
extension LoginViewController {
    private func configureSocialButtons() {
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
        // ✅ GOOGLE BUTTON CON TAP GESTURE RECOGNIZER
        let googleButton = GIDSignInButton()
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.isUserInteractionEnabled = true
        
        // Agregar Tap Gesture para Google Button
        googleButton.addTarget(self, action: #selector(googleBtnAction(_:)), for: .touchUpInside)
        
        let facebookButton = FBLoginButton()
        facebookButton.permissions = ["public_profile", "email"]
        facebookButton.addTarget(self, action: #selector(fbBtnAction), for: .touchUpInside)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.isHidden = true
        
        [appleButton, facebookButton, googleButton].forEach { view in
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
        
        [appleButton, facebookButton, googleButton]
            .forEach(socialSignInButtonsStackView.addArrangedSubview)
        
        self.googleBtnSignIn = googleButton
    }
}
