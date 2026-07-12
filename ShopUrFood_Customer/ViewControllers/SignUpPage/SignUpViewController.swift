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
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import FirebaseAuth

// ✅ ELIMINADOS: GIDSignInDelegate, GIDSignInUIDelegate (ya no existen en GoogleSignIn 7.x)
class SignUpViewController: BaseViewController, UIGestureRecognizerDelegate {
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
    var countryListArray: NSArray = [] // Para guardar todos los países
    var selectedCountryDict: NSDictionary? // Para el país seleccionado
    
    // 🔥 NUEVAS PROPIEDADES PARA FIREBASE
    var verificationID: String?
    var pendingUserId: Int?
    var pendingPhoneNumber: String?
    var firebaseConfig: [String: Any]?
    
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
        
        NameTxt.setPadding(left: 30, right: 0, imageName: "ic_user")
        emailTxt.setPadding(left: 30, right: 0, imageName: "ic_user_email")
        passwordTxt.setPadding(left: 30, right: 0, imageName: "ic_user_password")
        mobileTxt.setPadding(left: 30, right: 0, imageName: "ic_phone")
        
        if login_session.value(forKey: "Language") as? String == "en"{
            let string1 = "Referral code? "
            let string2 = "Apply"
            
            let att = NSMutableAttributedString(string: "\(string1)\(string2)");
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: string1.count))
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: AppLightOrange, range: NSRange(location: string1.count, length: string2.count))
            referralCodeBtn.setAttributedTitle(att, for: .normal)
        }else{
            let string1 = "¿Codigo de referencia? "
            let string2 = "Aplicar"
            
            let att = NSMutableAttributedString(string: "\(string1)\(string2)");
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: string1.count))
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: AppLightOrange, range: NSRange(location: string1.count, length: string2.count))
            referralCodeBtn.setAttributedTitle(att, for: .normal)
        }
        
        baseView.layer.cornerRadius = 5.0
        baseView = self.setCornorShadowEffects(sender: baseView)
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        getCountryListData()
        referralCodeStr = ""
        
        logoBGView.layer.cornerRadius = 75.0
        logoBGView.clipsToBounds = true
        referralApplyBtn.layer.cornerRadius = 2
        mobileTxt.keyboardType = .numberPad
        
        let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(imagedTapedName(tapGestureRecognizer:)))
        
        showHideName.isUserInteractionEnabled = true
        showHideName.addGestureRecognizer(tapGestureRecognizerName)
        
        let tapGestureRecognizerEmail = UITapGestureRecognizer(target: self, action: #selector(imagedTapedEmail(tapGestureRecognizer:)))
        
        showHideEmail.isUserInteractionEnabled = true
        showHideEmail.addGestureRecognizer(tapGestureRecognizerEmail)
        
        let tapGestureRecognizerPassword = UITapGestureRecognizer(target: self, action: #selector(imagedTapedPassword(tapGestureRecognizer:)))
        
        showHidePassword.isUserInteractionEnabled = true
        showHidePassword.addGestureRecognizer(tapGestureRecognizerPassword)
    }
    
    var iconClick = false
    var iconClick1 = false
    var iconClick2 = true
    
    @IBOutlet weak var showHideName: UIImageView!
    @IBOutlet weak var showHideEmail: UIImageView!
    @IBOutlet weak var showHidePassword: UIImageView!
    
    @objc func imagedTapedName(tapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(named: "hidden")
            NameTxt.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImage.image = UIImage(named: "show")
            NameTxt.isSecureTextEntry = true
        }
    }
    
    @objc func imagedTapedEmail(tapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick1 {
            iconClick1 = false
            tappedImage.image = UIImage(named: "hidden")
            emailTxt.isSecureTextEntry = false
        } else {
            iconClick1 = true
            tappedImage.image = UIImage(named: "show")
            emailTxt.isSecureTextEntry = true
        }
    }
    
    @objc func imagedTapedPassword(tapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick2 {
            iconClick2 = false
            tappedImage.image = UIImage(named: "hidden")
            passwordTxt.isSecureTextEntry = false
        } else {
            iconClick2 = true
            tappedImage.image = UIImage(named: "show")
            passwordTxt.isSecureTextEntry = true
        }
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
    
    func getCountryListData() {
        let Parse = CommomParsing()
        let language = login_session.value(forKey: "Language") as? String ?? "es"
        
        // OBTENER EL PAÍS GUARDADO DESDE USERDEFAULTS
        let defaults = UserDefaults.standard
        let userCountryCode = defaults.string(forKey: "userCountryCode") ?? ""
        
        print("Usando código de país para API: \(userCountryCode)")
        
        Parse.getCountryList(lang: language, countryCode: userCountryCode, onSuccess: { response in
            if response.object(forKey: "code") as! Int == 200 {
                guard let dataDict = response.object(forKey: "data") as? NSDictionary,
                      let countryDetails = dataDict.value(forKey: "country_details") as? NSArray,
                      let defaultCountry = dataDict.value(forKey: "default_country") as? NSDictionary else {
                    print("Error: No se pudo obtener la lista de países")
                    return
                }
                
                self.countryListArray = countryDetails
                
                var ccArray = [String]()
                var dialCodeArray = [String]()
                
                for country in countryDetails {
                    if let countryDict = country as? NSDictionary,
                       let countryDial = countryDict.value(forKey: "country_dial") as? String,
                       let countryName = countryDict.value(forKey: "country_name") as? String {
                        
                        let displayText = "\(countryDial) \(countryName)"
                        ccArray.append(displayText)
                        dialCodeArray.append(countryDial)
                    }
                }
                
                self.countryCodeDropDown.dataSource = ccArray
                
                self.countryCodeDropDown.selectionAction = { [weak self] (index, item) in
                    self?.codeTxt.text = dialCodeArray[index]
                    
                    if index < self?.countryListArray.count ?? 0 {
                        self?.selectedCountryDict = self?.countryListArray[index] as? NSDictionary
                    }
                }
                
                // USAR EL PAÍS PREDETERMINADO (basado en ubicación)
                if let defaultDialCode = defaultCountry.value(forKey: "country_dial") as? String {
                    self.codeTxt.text = defaultDialCode
                    self.selectedCountryDict = defaultCountry
                    
                    print("País predeterminado establecido: \(defaultDialCode)")
                }
                
            } else if response.object(forKey: "code") as! Int == 400 && response.object(forKey: "message") as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message") as! String)
            }
        }, onFailure: { errorResponse in
            print("Error en la petición: \(errorResponse)")
        })
    }
    
    @IBAction func showCouponView(_ sender: Any) {
        referralCodeTxt.text = referralCodeStr
        transpertantView.backgroundColor = BlackTranspertantColor
        transpertantView.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        transpertantView.addGestureRecognizer(tap)
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        transpertantView.isHidden = true
    }
    
    @IBAction func goBtnAction(_ sender: Any) {
        print("\n🔥 ========== INICIO REGISTRO ==========")
        
        // Validaciones
        if (NameTxt.text == "" || NameTxt.text?.count == 0) {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenterusername") as! String)
            return
        }
        
        if emailTxt.text == "" || emailTxt.text?.count == 0 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenteremail") as! String)
            return
        }
        
        if codeTxt.text == "" || codeTxt.text?.count == 0 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseentercountrycode") as! String)
            return
        }
        
        if mobileTxt.text == "" || mobileTxt.text?.count == 0 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseentermobilenumber") as! String)
            return
        }
        
        if passwordTxt.text == "" || passwordTxt.text?.count == 0 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseenterpass") as! String)
            return
        }
        
        if !isValidEmail(testStr: emailTxt.text!) {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.object(forKey: "pleaseentervalidemailid") as! String)
            return
        }
        
        print("✅ Validaciones pasadas")
        
        // Proceder con el registro
        referralCodeStr = referralCodeTxt.text ?? ""
        self.showLoadingIndicator(senderVC: self)
        
        let mobileNoStr = codeTxt.text! + mobileTxt.text!
        print("📱 Número completo:", mobileNoStr)
        
        let Parse = CommomParsing()
        
        Parse.userRegister(
            lang: login_session.value(forKey: "Language") as? String ?? "es",
            cus_fname: NameTxt.text!,
            cus_email: emailTxt.text!,
            cus_password: passwordTxt.text!,
            cus_phone1: mobileNoStr,
            referral_code: referralCodeStr,
            ios_device_id: iPhoneUDIDString,
            ios_fcm_id: login_session.object(forKey: "fcmToken") as! String,
            onSuccess: { response in
                self.stopLoadingIndicator(senderVC: self)
                
                print("\n📦 ========== RESPUESTA DEL SERVIDOR ==========")
                print("Response completo:", response)
                
                guard let code = response.object(forKey: "code") as? Int else {
                    print("❌ No hay código en la respuesta")
                    self.showToastAlert(senderVC: self, messageStr: "Error: Respuesta inválida del servidor")
                    return
                }
                
                print("📊 Código:", code)
                
                if code == 200 {
                    guard let dataDict = response.object(forKey: "data") as? [String: Any] else {
                        print("❌ No hay data en la respuesta")
                        self.showToastAlert(senderVC: self, messageStr: "Error: Datos incompletos del servidor")
                        return
                    }
                    
                    print("📦 Data recibida:", dataDict)
                    
                    // 🔥 VERIFICAR SI REQUIERE VERIFICACIÓN DE TELÉFONO
                    let requiresVerification: Bool
                    if let reqVerif = dataDict["requires_phone_verification"] as? Bool {
                        requiresVerification = reqVerif
                        print("🔍 requires_phone_verification (Bool):", requiresVerification)
                    } else if let reqVerif = dataDict["requires_phone_verification"] as? Int {
                        requiresVerification = reqVerif == 1
                        print("🔍 requires_phone_verification (Int):", reqVerif, "→", requiresVerification)
                    } else if let reqVerif = dataDict["requires_phone_verification"] as? String {
                        requiresVerification = (reqVerif == "1" || reqVerif.lowercased() == "true")
                        print("🔍 requires_phone_verification (String):", reqVerif, "→", requiresVerification)
                    } else {
                        requiresVerification = false
                        print("⚠️ requires_phone_verification no encontrado, asumiendo false")
                    }
                    
                    print("✅ Valor final requiresVerification:", requiresVerification)
                    
                    if requiresVerification {
                        print("\n🔥 ========== INICIANDO VERIFICACIÓN DE TELÉFONO ==========")
                        
                        // Guardar datos para la verificación
                        if let userId = dataDict["user_id"] as? Int {
                            self.pendingUserId = userId
                            print("✅ User ID:", userId)
                        } else if let userId = dataDict["user_id"] as? String, let userIdInt = Int(userId) {
                            self.pendingUserId = userIdInt
                            print("✅ User ID (String→Int):", userIdInt)
                        } else {
                            print("❌ No se pudo obtener user_id")
                        }
                        
                        self.pendingPhoneNumber = dataDict["user_phone"] as? String
                        self.firebaseConfig = dataDict["firebase_config"] as? [String: Any]
                        
                        print("📱 Phone:", self.pendingPhoneNumber ?? "❌ nil")
                        print("📱 Firebase Config:", self.firebaseConfig ?? "❌ nil")
                        
                        // Verificar que tenemos todos los datos
                        guard let userId = self.pendingUserId,
                              let phoneNumber = self.pendingPhoneNumber,
                              let config = self.firebaseConfig else {
                            print("❌ ERROR: Faltan datos para verificación")
                            print("   - userId:", self.pendingUserId ?? "nil")
                            print("   - phoneNumber:", self.pendingPhoneNumber ?? "nil")
                            print("   - config:", self.firebaseConfig != nil ? "exists" : "nil")
                            self.showToastAlert(senderVC: self, messageStr: "Error: Datos incompletos del servidor")
                            return
                        }
                        
                        // Verificar que el config tiene todas las claves necesarias
                        print("\n🔍 Verificando Firebase Config:")
                        print("   - apiKey:", config["apiKey"] != nil ? "✅" : "❌ FALTA")
                        print("   - projectId:", config["projectId"] != nil ? "✅" : "❌ FALTA")
                        print("   - appId:", config["appId"] != nil ? "✅" : "❌ FALTA")
                        print("   - messagingSenderId:", config["messagingSenderId"] != nil ? "✅" : "❌ FALTA")
                        print("   - clientId:", config["clientId"] != nil ? "✅" : "❌ FALTA")
                        
                        // Configurar Firebase con las credenciales del backend
                        print("\n🔥 Configurando Firebase...")
                        self.configureFirebase()
                        
                        // Iniciar verificación de teléfono
                        print("\n📞 Iniciando verificación de teléfono...")
                        self.startPhoneVerification(phoneNumber: phoneNumber)
                        
                    } else {
                        print("\n✅ Registro completado SIN verificación (flujo antiguo)")
                        // Registro completado sin verificación (caso antiguo)
                        self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                    }
                    
                } else if code == 400 && response.object(forKey: "message") as! String == "Token is Expired" {
                    print("⚠️ Token expirado")
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message") as! String)
                } else {
                    print("❌ Error del servidor:", response.object(forKey: "message") as Any)
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
                
                print("========================================\n")
            },
            onFailure: { errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                print("❌ Error de red:", errorResponse)
                self.showToastAlert(senderVC: self, messageStr: "Error al registrar usuario")
            }
        )
    }
    
    func configureFirebase() {
        guard let config = firebaseConfig,
              let apiKey = config["apiKey"] as? String,
              let projectId = config["projectId"] as? String,
              let appId = config["appId"] as? String,
              let messagingSenderId = config["messagingSenderId"] as? String else {
            print("❌ Error: Firebase config incompleta")
            print("Config recibida:", firebaseConfig ?? "nil")
            return
        }
        
        print("📱 Configurando Firebase Phone Auth:")
        print("  - API Key:", String(apiKey.prefix(20)) + "...")
        print("  - Project ID:", projectId)
        print("  - App ID:", String(appId.prefix(30)) + "...")
        
        // Eliminar app existente si hay conflicto
        if let existingApp = FirebaseApp.app(name: "PhoneAuthApp") {
            print("⚠️ Eliminando app PhoneAuthApp existente")
            existingApp.delete { success in
                if success {
                    print("✅ App anterior eliminada")
                }
            }
        }
        
        // Crear opciones de Firebase
        let options = FirebaseOptions(
            googleAppID: appId,
            gcmSenderID: messagingSenderId
        )
        options.apiKey = apiKey
        options.projectID = projectId
        
        if let storageBucket = config["storageBucket"] as? String {
            options.storageBucket = storageBucket
        }
        
        options.bundleID = Bundle.main.bundleIdentifier ?? "com.deliverees.customer"
        
        // Client ID del backend
        if let clientId = config["clientId"] as? String, !clientId.isEmpty {
            options.clientID = clientId
            print("  - Client ID:", String(clientId.prefix(40)) + "...")
        } else {
            print("⚠️ WARNING: No hay clientId en firebase_config")
        }
        
        // Configurar Firebase
        FirebaseApp.configure(name: "PhoneAuthApp", options: options)
        print("✅ Firebase PhoneAuthApp configurado")
    }

    func startPhoneVerification(phoneNumber: String) {
        print("📞 Iniciando verificación para:", phoneNumber)
        
        // Esperar a que Firebase se inicialice
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            guard let app = FirebaseApp.app(name: "PhoneAuthApp") else {
                print("❌ Error: Firebase PhoneAuthApp no encontrada")
                self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
                return
            }
            
            print("✅ Firebase PhoneAuthApp obtenida")
            
            let auth = Auth.auth(app: app)
            auth.settings?.isAppVerificationDisabledForTesting = false
            
            print("📱 Llamando a PhoneAuthProvider.verifyPhoneNumber...")
            
            PhoneAuthProvider.provider(auth: auth).verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                
                if let error = error {
                    print("❌ Error en verificación:", error.localizedDescription)
                    
                    if let authError = error as NSError? {
                        print("❌ Código:", authError.code)
                        print("❌ Dominio:", authError.domain)
                        
                        switch authError.code {
                        case 17048: // Token Mismatch
                            self.showToastAlert(senderVC: self, messageStr: "Error de configuración. Contacta soporte.")
                        case 17010: // Invalid phone
                            self.showToastAlert(senderVC: self, messageStr: "Número de teléfono inválido")
                        default:
                            self.showToastAlert(senderVC: self, messageStr: "Error: \(error.localizedDescription)")
                        }
                    }
                    return
                }
                
                print("✅ Código enviado. VerificationID:", verificationID ?? "nil")
                self.verificationID = verificationID
                
                // Mostrar pantalla de verificación
                self.showVerificationCodeInput()
            }
        }
    }

    func showVerificationCodeInput() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Código de verificación")
        txt.keyboardType = .numberPad
        
        alert.addButton("Verificar") {
            let code = txt.text ?? ""
            if code.isEmpty {
                self.showToastAlert(senderVC: self, messageStr: "Ingresa el código")
            } else if code.count < 6 {
                self.showToastAlert(senderVC: self, messageStr: "El código debe tener 6 dígitos")
            } else {
                self.verifyCode(code: code)
            }
        }
        
        alert.addButton("Reenviar") {
            self.showToastAlert(senderVC: self, messageStr: "Reenviando código...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.startPhoneVerification(phoneNumber: self.pendingPhoneNumber!)
            }
        }
        
        let icon = UIImage(named: "ic_phone")
        alert.showCustom(
            "Verificación de Teléfono",
            subTitle: "Ingresa el código de 6 dígitos enviado a \(self.pendingPhoneNumber ?? "")",
            color: AppLightOrange,
            icon: icon!
        )
    }

    func verifyCode(code: String) {
        guard let verificationID = verificationID else {
            self.showToastAlert(senderVC: self, messageStr: "Error: No hay ID de verificación")
            return
        }
        
        print("🔍 Verificando código:", code)
        self.showLoadingIndicator(senderVC: self)
        
        guard let app = FirebaseApp.app(name: "PhoneAuthApp") else {
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error de configuración")
            return
        }
        
        let auth = Auth.auth(app: app)
        let credential = PhoneAuthProvider.provider(auth: auth).credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        auth.signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.stopLoadingIndicator(senderVC: self)
                print("❌ Error verificando:", error.localizedDescription)
                
                if let authError = error as NSError? {
                    switch authError.code {
                    case 17044: // Invalid code
                        self.showToastAlert(senderVC: self, messageStr: "Código inválido")
                    case 17052: // Expired
                        self.showToastAlert(senderVC: self, messageStr: "Código expirado")
                    default:
                        self.showToastAlert(senderVC: self, messageStr: "Código inválido")
                    }
                }
                return
            }
            
            print("✅ Código verificado")
            
            authResult?.user.getIDToken { idToken, error in
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
                
                print("✅ ID Token obtenido")
                self.confirmPhoneVerification(idToken: idToken)
            }
        }
    }

    func confirmPhoneVerification(idToken: String) {
        guard let userId = self.pendingUserId,
              let phoneNumber = self.pendingPhoneNumber else {
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: "Error: Datos no encontrados")
            return
        }
        
        let Parse = CommomParsing()
        
        Parse.verifyPhoneToken(
            userId: userId,
            phoneNumber: phoneNumber,
            idToken: idToken,
            credentialType: "AppiOS_SMS_customer",
            lang: login_session.value(forKey: "Language") as? String ?? "es",
            onSuccess: { response in
                self.stopLoadingIndicator(senderVC: self)
                
                if response.object(forKey: "code") as! Int == 200 {
                    print("✅ Verificación completada")
                    
                    // Limpiar Firebase app
                    if let app = FirebaseApp.app(name: "PhoneAuthApp") {
                        app.delete { _ in }
                    }
                    
                    self.showSuccessPopUp(msgStr: "¡Registro y verificación exitosos!")
                } else {
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
            },
            onFailure: { errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                print("❌ Error en backend:", errorResponse)
                self.showToastAlert(senderVC: self, messageStr: "Error al confirmar verificación")
            }
        )
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
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let msg = LanguageDictonary.object(forKey: "WehavesentaverificationemailValidateyouraccounttocontinue") as! String
            nextViewController.showSuccessPopUp(msgStr: msg)
            self.dismiss(animated: true, completion: nil)
        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom("", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    
    @IBAction func fbBtnTapped(_ sender: Any) {
        if (Reachability()?.isReachable)!
        {
            self.showLoadingIndicator(senderVC: self)
            loginManager.logOut()
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] result, error in
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
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
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
                            login_session.setUserLogged(true)
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
    
    // ✅ GOOGLE SIGN IN ACTUALIZADO A 7.x
   
    @IBAction func googleBtnTapped(_ sender: Any) {
        print("🔍 Google button tapped - SignUp")
        
        guard (Reachability()?.isReachable)! else {
            self.showToastAlert(senderVC: self, messageStr: "No hay conexión a Internet")
            return
        }
        
        self.showLoadingIndicator(senderVC: self)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            print("❌ No se pudo obtener rootViewController")
            self.stopLoadingIndicator(senderVC: self)
            return
        }
        
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        print("✅ Iniciando Google Sign In desde SignUp...")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            // ✅ SIEMPRE en hilo principal
            DispatchQueue.main.async {
                
                if let error = error {
                    print("❌ Google Sign In Error: \(error.localizedDescription)")
                    self.stopLoadingIndicator(senderVC: self)
                    // ✅ Mostrar error al usuario
                    if (error as NSError).code != GIDSignInError.canceled.rawValue {
                        self.showToastAlert(senderVC: self, messageStr: "Error al iniciar sesión con Google")
                    }
                    return
                }
                
                guard let signInResult = signInResult else {
                    print("❌ No se obtuvo resultado de Google Sign In")
                    self.stopLoadingIndicator(senderVC: self)
                    return
                }
                
                print("✅ Google Sign In exitoso desde SignUp")
                
                let user = signInResult.user
                let idStr = user.userID ?? ""
                let emailStr = user.profile?.email ?? ""
                let nameStr = user.profile?.name ?? ""
                
                print("📧 Email: \(emailStr)")
                print("👤 Name: \(nameStr)")
                print("🆔 ID: \(idStr)")
                
                let Parse = CommomParsing()
                Parse.GoogleLogin(
                    lang: login_session.value(forKey: "Language") as? String ?? "es",
                    google_id: idStr,
                    email: emailStr,
                    name: nameStr,
                    type: device_type,
                    ios_fcm_id: login_session.object(forKey: "fcmToken") as? String ?? "",
                    ios_device_id: self.iPhoneUDIDString,
                    onSuccess: { response in
                        DispatchQueue.main.async {
                            self.stopLoadingIndicator(senderVC: self)
                            
                            print("📦 Google Login Response:", response)
                            
                            // ✅ Verificar código ANTES de hacer force cast
                            guard let code = response.object(forKey: "code") as? Int else {
                                print("❌ No hay código en la respuesta")
                                self.showToastAlert(senderVC: self, messageStr: "Error en la respuesta del servidor")
                                return
                            }
                            
                            guard code == 200 else {
                                let msg = response.object(forKey: "message") as? String ?? "Error desconocido"
                                print("❌ Error del servidor: \(msg)")
                                self.showToastAlert(senderVC: self, messageStr: msg)
                                return
                            }
                            
                            // ✅ Acceso seguro a data
                            guard let data = response.object(forKey: "data") as? [AnyHashable: Any] else {
                                print("❌ No hay data en la respuesta")
                                self.showToastAlert(senderVC: self, messageStr: "Error al procesar datos")
                                return
                            }
                            
                            let dataDict = NSMutableDictionary()
                            dataDict.addEntries(from: data)
                            
                            guard let user_email = dataDict.object(forKey: "user_email") as? String,
                                  let user_id = dataDict.object(forKey: "user_id") as? Int,
                                  let user_name = dataDict.object(forKey: "user_name") as? String,
                                  let token = dataDict.object(forKey: "token") as? String else {
                                print("❌ Faltan campos en la respuesta")
                                self.showToastAlert(senderVC: self, messageStr: "Error: datos incompletos")
                                return
                            }
                            
                            print("✅ Login exitoso - guardando sesión")
                            login_session.setValue(user_email, forKey: "user_email")
                            login_session.setValue("0", forKey: "userCartCount")
                            login_session.setValue(String(user_id), forKey: "user_id")
                            login_session.setValue(user_name, forKey: "user_name")
                            login_session.setValue(token, forKey: "user_token")
                            login_session.setUserLogged(true)
                            login_session.synchronize()
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                            nextViewController.ComingType = "FIRST"
                            self.present(nextViewController, animated: true, completion: nil)
                        }
                    },
                    onFailure: { errorResponse in
                        DispatchQueue.main.async {
                            self.stopLoadingIndicator(senderVC: self)
                            // ✅ Ahora muestra el error
                            print("❌ Error en API Google Login:", errorResponse)
                            self.showToastAlert(senderVC: self, messageStr: "Error al conectar con el servidor")
                        }
                    }
                )
            }
        }
    }
}
