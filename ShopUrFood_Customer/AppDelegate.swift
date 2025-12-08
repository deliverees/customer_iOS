//
//  AppDelegate.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import SWRevealViewController
import Firebase
import IQKeyboardManager
import UserNotifications
import FirebaseMessaging
import AVFoundation
import PayPalCheckout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let gcmOrderIDKey = "gcm.notification.transaction_id"
    let gcmTypeId = "type_id"
    let gcmOrderId = "order_id"
    let gcmStoreId = "store_id"
    var player = AVAudioPlayer()
    var IsMuted: Bool = false
    var delegateTimer: Timer? = nil {
        willSet {
            delegateTimer?.invalidate()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if isRunningTests {
            return true
        }
        
        // =====================================
        // UI Configuration
        // =====================================
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .selected)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected)
        
        // =====================================
        // ✅ FACEBOOK LOGIN
        // =====================================
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // =====================================
        // ✅ GOOGLE SIGN IN
        // =====================================
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let clientID = plist["CLIENT_ID"] as? String {
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            #if DEBUG
            print("✅ Google Sign In Configuration:")
            print("   - CLIENT_ID: \(String(clientID.prefix(30)))...")
            print("   - Configuration created: ✓")
            
            // Verificar URL Schemes en Info.plist
            if let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] {
                print("   - URL Schemes registrados en Info.plist:")
                for urlType in urlTypes {
                    if let schemes = urlType["CFBundleURLSchemes"] as? [String],
                       let name = urlType["CFBundleURLName"] as? String {
                        print("      • \(name): \(schemes.joined(separator: ", "))")
                    }
                }
            }
            #endif
        } else {
            print("❌ ERROR: No se pudo cargar GoogleService-Info.plist")
        }
        
        // =====================================
        // ✅ GOOGLE MAPS
        // =====================================
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        GoogleApi.shared.initialiseWithKey(googleMapsApiKey)
        
        // =====================================
        // ✅ PAYPAL
        // =====================================
        configurePayPal()
        
        // =====================================
        // ✅ FIREBASE & NOTIFICATIONS
        // =====================================
        UNUserNotificationCenter.current().delegate = self
        IQKeyboardManager.shared().isEnabled = true
        
        // 🔥 CONFIGURAR FIREBASE DEFAULT (SOLO PARA FCM/NOTIFICACIONES)
        // Las apps secundarias (PhoneAuthApp) se configuran dinámicamente
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            print("✅ Firebase configurado (default app para FCM/Notificaciones)")
        } else {
            print("✅ Firebase ya estaba configurado")
        }
        
        Messaging.messaging().delegate = self
        
        if let token = Messaging.messaging().fcmToken {
            print("📱 FCM token inicial: \(token)")
            self.ConnectToFCM()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.tokenRefreshNotificaiton),
            name: NSNotification.Name.MessagingRegistrationTokenRefreshed,
            object: nil
        )
        
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        self.languageUpdate()
        self.ConnectToFCM()
        AppRouter.shared.initialize()
        
        print("✅ App inicializada correctamente")
        
        return true
    }
    
    // =====================================
    // 🔥 MÉTODO CRÍTICO: MANEJO DE DEEP LINKS
    // =====================================
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        #if DEBUG
        print("\n📲 ========== DEEP LINK RECEIVED ==========")
        print("📲 URL: \(url.absoluteString)")
        print("📲 Scheme: \(url.scheme ?? "nil")")
        print("📲 Host: \(url.host ?? "nil")")
        print("📲 Path: \(url.path)")
        print("==========================================\n")
        #endif
        
        // 🔥 1. FIREBASE PHONE AUTH (reCAPTCHA callback)
        // Formato: app-1-802377568198-ios-f61f66c81ed66b54b12cc7://firebaseauth/link
        if let scheme = url.scheme, scheme.hasPrefix("app-1-802377568198-ios") {
            print("✅ Firebase Phone Auth reCAPTCHA callback detectado")
            // Firebase maneja esto internamente, solo retornamos true
            return true
        }
        
        // 🔥 2. GOOGLE SIGN IN - MÁXIMA PRIORIDAD
        if let scheme = url.scheme, scheme.hasPrefix("com.googleusercontent.apps") {
            print("✅ Handling Google Sign In URL...")
            let handled = GIDSignIn.sharedInstance.handle(url)
            print("✅ Google handled: \(handled)")
            return handled
        }
        
        // 🔥 3. FACEBOOK
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            print("✅ Facebook handled")
            return true
        }
        
        // 🔥 4. PAYPAL
        if let scheme = url.scheme, scheme == "deliverees" {
            print("✅ PayPal handled")
            // Tu código de PayPal aquí
            return true
        }
        
        print("⚠️ URL no manejada: \(url.absoluteString)")
        return false
    }
    
    // =====================================
    // ✅ MÉTODO ADICIONAL PARA iOS 13+ (Scene-based)
    // =====================================
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        #if DEBUG
        print("\n🔗 ========== UNIVERSAL LINK ==========")
        print("🔗 Activity Type: \(userActivity.activityType)")
        if let url = userActivity.webpageURL {
            print("🔗 URL: \(url.absoluteString)")
        }
        print("======================================\n")
        #endif
        
        return true
    }
    
    // =====================================
    // ✅ CONFIGURACIÓN DE PAYPAL
    // =====================================
    private func configurePayPal() {
        let config = CheckoutConfig(
            clientID: PAYPAL_CLIENT_ID,
            createOrder: nil,
            onApprove: nil,
            onShippingChange: nil,
            onCancel: nil,
            onError: nil,
            environment: PAYPAL_ENVIRONMENT == "sandbox" ? .sandbox : .live
        )
        
        Checkout.set(config: config)
        
        #if DEBUG
        print("✅ PayPal SDK Configured")
        print("📱 Mode: \(PAYPAL_ENVIRONMENT.uppercased())")
        print("🔑 Client ID: \(String(PAYPAL_CLIENT_ID.prefix(20)))...")
        #endif
    }
    
    // =====================================
    // FCM TOKEN MANAGEMENT
    // =====================================
    @objc func tokenRefreshNotificaiton(_ notification: Foundation.Notification) {
        print("🔄 FCM Token refrescado")
        ConnectToFCM()
    }
    
    func ConnectToFCM() {
        if let token = Messaging.messaging().fcmToken {
            print("📱 FCM token actualizado: \(token)")
            UserDefaults.standard.set(token, forKey: "fcmToken")
            login_session.set(token, forKey: "fcmToken")
            login_session.synchronize()
        } else {
            print("⚠️ FCM token no disponible aún")
        }
    }
    
    // =====================================
    // FIREBASE MESSAGING DELEGATE
    // =====================================
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("🔥 Firebase registration token refreshed: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        login_session.set(fcmToken, forKey: "fcmToken")
        login_session.synchronize()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 Firebase registration token: \(fcmToken ?? "nil")")
        if let fcmToken = fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
            login_session.set(fcmToken, forKey: "fcmToken")
            login_session.synchronize()
        }
    }
    
    // =====================================
    // AUDIO PLAYER
    // =====================================
    func play() {
        guard !IsMuted else { return }
        
        if let soundURL = Bundle.main.url(forResource: "marimba_arpegio", withExtension: "aiff") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player.numberOfLoops = 50
                player.play()
                print("🔊 Reproduciendo sonido")
            } catch {
                print("❌ Error al reproducir sonido: \(error)")
            }
        }
    }
    
    func startDelegateTimer() {
        if delegateTimer == nil {
            delegateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(playerStop), userInfo: nil, repeats: true)
        }
    }
    
    @objc func playerStop() {
        player.stop()
        print("🔇 Sonido detenido")
    }
    
    // =====================================
    // LANGUAGE MANAGEMENT
    // =====================================
    func languageUpdate() {
        if login_session.value(forKey: "Language") == nil {
            UserDefaults.standard.setValue(1, forKey: "SelectedLang")
            login_session.setValue("es", forKey: "Language")
            loadLanguageFile(name: "spanish", locale: "es")
        } else if login_session.value(forKey: "Language") as! String == "en" {
            UserDefaults.standard.setValue(0, forKey: "SelectedLang")
            login_session.setValue("en", forKey: "Language")
            loadLanguageFile(name: "English", locale: "en_US")
        } else {
            UserDefaults.standard.setValue(1, forKey: "SelectedLang")
            login_session.setValue("es", forKey: "Language")
            loadLanguageFile(name: "spanish", locale: "es")
        }
    }
    
    private func loadLanguageFile(name: String, locale: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                if let dict = convertToDictionary(text: myJSON) as NSDictionary? {
                    LanguageDictonary.addEntries(from: dict as! [AnyHashable: Any])
                    localeIdendifier = NSLocale(localeIdentifier: locale)
                    localeIdendifierStr = locale
                    print("✅ Idioma cargado: \(name)")
                }
            } catch {
                print("❌ Error cargando idioma: \(error)")
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("❌ Error parseando JSON: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    // =====================================
    // LOGOUT
    // =====================================
    func ManualLogoutOption() {
        let domain = Bundle.main.bundleIdentifier!
        login_session.persistentDomain(forName: domain)
        login_session.synchronize()
        
        // Limpiar todos los datos de sesión
        for key in login_session.dictionaryRepresentation().keys {
            login_session.removeObject(forKey: key)
        }
        
        login_session.synchronize()
        print("🚪 Usuario deslogueado")
        
        AppRouter.shared.presentLogin()
    }
    
    // =====================================
    // PUSH NOTIFICATIONS
    // =====================================
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📬 Notificación recibida en primer plano")
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("📬 Usuario tocó la notificación")
        
        // Reset badge
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        let userInfo = response.notification.request.content.userInfo
        print("📋 User Info: \(userInfo)")
        
        // 🔥 IGNORAR NOTIFICACIONES DE FIREBASE AUTH (reCAPTCHA)
        if let _ = userInfo["com.google.firebase.auth"] {
            print("🔥 Notificación de Firebase Auth (reCAPTCHA), ignorando...")
            completionHandler()
            return
        }
        
        guard let ReceivedTypeID = userInfo[gcmTypeId] as? String else {
            print("⚠️ Notificación sin type_id")
            completionHandler()
            return
        }
        
        print("📌 Type ID: \(ReceivedTypeID)")
        
        // Reproducir sonido
        self.play()
        
        // Manejar navegación según tipo de notificación
        handleNotificationNavigation(typeId: ReceivedTypeID, userInfo: userInfo)
        
        completionHandler()
    }
    
    private func handleNotificationNavigation(typeId: String, userInfo: [AnyHashable: Any]) {
        
        guard login_session.isUserLogged() else {
            print("⚠️ Usuario no logueado, ignorando navegación")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch typeId {
        case "0": // Ofertas
            if let vc = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as? MyOffersViewController {
                vc.isfromNotificationClick = true
                AppRouter.shared.presentInRoot(vc: vc)
            }
            
        case "5": // Wallet
            if let vc = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as? WalletViewController {
                vc.isfromSideBarOrNotifyPage = true
                AppRouter.shared.presentInRoot(vc: vc)
            }
            
        case "3": // Orden rechazada
            if let orderId = userInfo[gcmOrderId] as? String {
                if let vc = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as? OrderDetailsPage {
                    vc.orderId = orderId
                    vc.isfromNotificationClick = true
                    vc.navigationTypeStr = "present"
                    vc.orderisRejected = true
                    AppRouter.shared.presentInRoot(vc: vc)
                }
            }
            
        case "8": // Tracking
            if let orderId = userInfo[gcmOrderId] as? String,
               let storeId = userInfo[gcmStoreId] as? String {
                if let vc = storyboard.instantiateViewController(withIdentifier: "TrackingScreen") as? TrackingScreen {
                    vc.order_id = orderId
                    vc.store_id = storeId
                    vc.navigationTypeStr = "Notification"
                    AppRouter.shared.presentInRoot(vc: vc)
                }
            }
            
        default:
            print("⚠️ Tipo de notificación no manejado: \(typeId)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("📬 Notificación remota recibida (método antiguo)")
        
        // 🔥 IGNORAR NOTIFICACIONES DE FIREBASE AUTH
        if let _ = userInfo["com.google.firebase.auth"] {
            print("🔥 Notificación de Firebase Auth, ignorando...")
            return
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("📬 Notificación remota recibida con fetch handler")
        
        // 🔥 IGNORAR NOTIFICACIONES DE FIREBASE AUTH
        if let _ = userInfo["com.google.firebase.auth"] {
            print("🔥 Notificación de Firebase Auth (reCAPTCHA), ignorando...")
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        
        let state = UIApplication.shared.applicationState
        print("📱 Estado de la app: \(state == .background ? "background" : state == .active ? "foreground" : "inactive")")
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}
