
//
//  AppDelegate.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import SWRevealViewController
import Firebase
import IQKeyboardManager
import UserNotifications
import FirebaseMessaging
import Fabric
import AVFoundation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let gcmOrderIDKey = "gcm.notification.transaction_id"
    let gcmTypeId = "type_id"
    let gcmOrderId = "order_id"
    let gcmStoreId = "store_id"
    var player = AVAudioPlayer()
    var IsMuted:Bool = false
    var delegateTimer:Timer? = nil {
        willSet {
            delegateTimer?.invalidate()
        }
    }
    
    private func playsoundifneeded() {
        DispatchQueue.main.async {
            if let soundURL = Bundle.main.url(forResource: "marimba_arpegio", withExtension: "aiff") {
                do
                {
                    self.player = try AVAudioPlayer(contentsOf: soundURL)
                }
                catch
                {
                    print("No sound found by URL")
                }
                if self.player.isPlaying
                {
                    self.playerStop()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if isRunningTests {
            return true
        }
        //        playsoundifneeded()
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .selected)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .selected)
        
        // Init FaceBook login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Init Google
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID

        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        GoogleApi.shared.initialiseWithKey(googleMapsApiKey)
        // Init Paypal
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AVomx52Gh-UDWy2BSntGqIVSwi5dnc9t6vCdMRyohM_C2Llk6xep2L22sRm9nLAVt-zG5i9zwF8NC1ft"])
        UNUserNotificationCenter.current().delegate = self
        IQKeyboardManager.shared().isEnabled = true
                
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            self.ConnectToFCM()
        }
        
#if DEBUG
        Fabric.sharedSDK().debug = true
#endif
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                               name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        self.languageUpdate()
        self.ConnectToFCM()
        AppRouter.shared.initialize()
        
        
        return true
    }
    
    @objc func tokenRefreshNotificaiton(_ notification: Foundation.Notification) {
        ConnectToFCM()
    }
    
    func play()
    {
        IsMuted = false
        let soundURL = Bundle.main.url(forResource: "marimba_arpegio", withExtension: "aiff")
        do
        {
            player = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch
        {
            print("No sound found by URL")
        }
        player.numberOfLoops = 50
        self.player.play()
        print("PLAY CALLED")
        
    }
    func startDelegateTimer() {
        if delegateTimer == nil {
            delegateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(playerStop), userInfo: nil, repeats: true)
        }
    }
    @objc func playerStop()
    {
        self.player.stop()
    }
    
    func languageUpdate()
    {
        if login_session.value(forKey: "Language") == nil {
            UserDefaults.standard.setValue(1, forKey: "SelectedLang")
            login_session.setValue("es", forKey: "Language")
            if let path = Bundle.main.path(forResource: "spanish", ofType: "json") {
                do {
                    let fileUrl = URL(fileURLWithPath: path)
                    let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                    let dict = convertToDictionary(text: myJSON)! as NSDictionary
                    LanguageDictonary.addEntries(from: dict as! [AnyHashable : Any])
                    print("JSONLoad : \(dict)")
                    localeIdendifier = NSLocale(localeIdentifier: "es")
                    localeIdendifierStr = "es"
                }
                catch {print("Error")}
            }
        }else if login_session.value(forKey: "Language") as! String == "en" {
            UserDefaults.standard.setValue(0, forKey: "SelectedLang")
            login_session.setValue("en", forKey: "Language")
            if let path = Bundle.main.path(forResource: "English", ofType: "json") {
                do {
                    let fileUrl = URL(fileURLWithPath: path)
                    let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                    let dict = convertToDictionary(text: myJSON)! as NSDictionary
                    LanguageDictonary.addEntries(from: dict as! [AnyHashable : Any])
                    print("JSONLoad : \(dict)")
                    localeIdendifier = NSLocale(localeIdentifier: "en_US")
                    localeIdendifierStr = "en_US"
                }
                catch {print("Error")}
            }
        }else{
            UserDefaults.standard.setValue(1, forKey: "SelectedLang")
            login_session.setValue("es", forKey: "Language")
            if let path = Bundle.main.path(forResource: "spanish", ofType: "json") {
                do {
                    let fileUrl = URL(fileURLWithPath: path)
                    let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                    let dict = convertToDictionary(text: myJSON)! as NSDictionary
                    LanguageDictonary.addEntries(from: dict as! [AnyHashable : Any])
                    print("JSONLoad : \(dict)")
                    
                }
                catch {print("Error")}
            }
        }
        
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func ConnectToFCM() {
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            UserDefaults.standard.set(token, forKey: "fcmToken")
        }
    }
    
    func ManualLogoutOption(){
        let domain = Bundle.main.bundleIdentifier!
        login_session.persistentDomain(forName: domain)
        login_session.synchronize()
        print(login_session)
        for key in login_session.dictionaryRepresentation().keys {
            login_session.removeObject(forKey: key)
        }
        login_session.synchronize()
        AppRouter.shared.presentLogin()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation))
        {
            return true
        }else if(GIDSignIn.sharedInstance().handle(url as URL?,
                                                   sourceApplication: sourceApplication, annotation:annotation)){
            return true
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    //MARK: FCM Token Refreshed
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        // FCM token updated, update it on Backend Server
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        if let fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        }
    }
    //MARK: UNUserNotificationCenterDelegate Method
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // TODO: Try to update whatever needs to be updated
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        print("User Info = \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print("NOTIFY ALERT CLICKED FROM NOTIFICATION : ",(userInfo["aps"] as? NSDictionary)?.value(forKey: "alert") as Any)
        let ReceivedTypeID = userInfo[gcmTypeId] as! String
        print(ReceivedTypeID)
        
        self.play()
        let alertStr = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String
        print("Final background : ", alertStr as Any)
                
        if ReceivedTypeID == "0"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
            nextViewController.isfromNotificationClick = true
            AppRouter.shared.presentInRoot(vc: nextViewController)
        }
        else if ReceivedTypeID == "5"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            nextViewController.isfromSideBarOrNotifyPage = true
            AppRouter.shared.presentInRoot(vc: nextViewController)
        }
        
        if let Orderid = userInfo[gcmOrderId] as? String, ReceivedTypeID == "3"
        {
            print(Orderid)
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
            nextViewController.orderId = Orderid
            nextViewController.isfromNotificationClick = true
            nextViewController.navigationTypeStr = "present"
            nextViewController.orderisRejected = true
            AppRouter.shared.presentInRoot(vc: nextViewController)
        }
        else if let Orderid = userInfo[gcmOrderId] as? String, ReceivedTypeID == "8"
        {
            print(Orderid)
            let StoreId = userInfo[gcmStoreId] as! String
            print(StoreId)
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            nextViewController.order_id = Orderid //String(describing: userInfo[gcmOrderIDKey] as AnyObject)
            nextViewController.store_id = StoreId
            //            nextViewController.orderisRejected = true
            nextViewController.navigationTypeStr = "Notification"
            AppRouter.shared.presentInRoot(vc: nextViewController)
            
        }
        
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("background")
        }
        else if state == .active {
            print("foreground")
        }
        else if state == .inactive {
            print("not active")
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("background")
        }
        else if state == .active {
            print("foreground")
        }
        else if state == .inactive {
            print("not active")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("background")
        }
        else if state == .active {
            print("foreground")
        }
        else if state == .inactive {
            print("not active")
        }
        print(userInfo)
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}






