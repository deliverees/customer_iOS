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
//import FirebaseInstanceID
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
      
        
        let soundURL = Bundle.main.url(forResource: "marimba_arpegio", withExtension: "aiff")
        do
        {
            self.player = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch
        {
            print("No sound found by URL")
        }
        if self.player.isPlaying
        {
            self.playerStop()
           
            
        }
        
        
        // Init FaceBook login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Init Google
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        //GMSServices.provideAPIKey("AIzaSyDnQ9-Asl8DIP8HL9RwFhGhPuD7BqVN73Y")
        //GMSPlacesClient.provideAPIKey("AIzaSyCaHVuFqUzjP2ZPokJNg8HuLak_BkHIS7Q")
//        GMSServices.provideAPIKey("AIzaSyDI3KfTjweOu_rjMSgzZpV3kq_GCxwPLvI")
//        GMSPlacesClient.provideAPIKey("AIzaSyDI3KfTjweOu_rjMSgzZpV3kq_GCxwPLvI")
        
        GMSServices.provideAPIKey("AIzaSyBg5e4lx9fS1voiwnPjJ8YkjISFt7-sbfU")
        GMSPlacesClient.provideAPIKey("AIzaSyBg5e4lx9fS1voiwnPjJ8YkjISFt7-sbfU")
        GoogleApi.shared.initialiseWithKey("AIzaSyBg5e4lx9fS1voiwnPjJ8YkjISFt7-sbfU")

        
        IQKeyboardManager.shared().isEnabled = true
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .selected)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        //UITabBarItem.appearance().setTitleTextAttributes(NSAttributedString.Key.foregroundColor: UIColor.gray, for:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .selected)
        
        // [START register_for_notifications]
        DispatchQueue.main.async {
            // Init Paypal
            PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AVomx52Gh-UDWy2BSntGqIVSwi5dnc9t6vCdMRyohM_C2Llk6xep2L22sRm9nLAVt-zG5i9zwF8NC1ft"])
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            UIApplication.shared.registerForRemoteNotifications()
            
            
            
            application.registerForRemoteNotifications()
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted) {
                    UIApplication.shared.registerForRemoteNotifications()
                } else{
                    print("Notification permissions not granted")
                }
            })
            FirebaseApp.configure()
            Messaging.messaging().delegate = self
              //Messaging.messaging().shouldEstablishDirectChannel = true
           
            if let token = Messaging.messaging().fcmToken {
                print("FCM token: \(token )")
                self.ConnectToFCM()
            }
              self.languageUpdate()
            self.ConnectToFCM()
            self.checkRootView()
          
            Fabric.sharedSDK().debug = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                                   name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
            
            application.applicationIconBadgeNumber = 0
        }
        
        return true
    }
    
    @objc func tokenRefreshNotificaiton(_ notification: Foundation.Notification) {
        /*InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                let refreshedToken  = "\(result.token)"
                UserDefaults.standard.set(refreshedToken, forKey: "fcmToken")
            }
        }*/
        ConnectToFCM()
    }
    
    func play()
    {
        // var player = AVAudioPlayer()
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
    
    
    
    
    
//    func languageUpdate()
//    {
//        if let path = Bundle.main.path(forResource: "English", ofType: "json") {
//            do {
//                let fileUrl = URL(fileURLWithPath: path)
//                let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
//                let dict = convertToDictionary(text: myJSON)! as NSDictionary
//                print("JSONLoad : \(dict)")
//
//            }
//            catch {print("Error")}
//        }
//    }
//
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
    func ConnectToFCM() {
        /*InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                let token = "\(result.token)"
                print("DCS: " + token)
                UserDefaults.standard.set(token, forKey: "fcmToken")
            }
        }*/
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            UserDefaults.standard.set(token, forKey: "fcmToken")
        }
        //Messaging.messaging().shouldEstablishDirectChannel = true
    }
    func ManualLogoutOption(){
        let domain = Bundle.main.bundleIdentifier!
        login_session.persistentDomain(forName: domain)
        login_session.synchronize()
        print(login_session)
        for key in login_session.dictionaryRepresentation().keys{
            login_session.removeObject(forKey: key.description)
        }
        login_session.synchronize()
        self.checkRootView()
    }
   
    
    func checkRootView()
    {
        if login_session.object(forKey: "user_id") == nil{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            if login_session.object(forKey: "user_longitude") != nil{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "RevealRootView") as! SWRevealViewController
                tabBarSelectedIndex = 2
                self.window?.rootViewController = mainViewController
                self.window?.makeKeyAndVisible()
            }else{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LocationOptionPage")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
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
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

  

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    
    
    //MARK: FCM Token Refreshed
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        // FCM token updated, update it on Backend Server
    }
    
    /*func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage)")
        print("remoteMessage: \(remoteMessage.appData)")
        print("remoteMessage: \(remoteMessage)")
        
        let pushDict:NSDictionary = remoteMessage.appData as NSDictionary
        print(pushDict)
        //let titleStr : String = pushDict.value(forKey: "title") as! String
        //let bodyStr : String = pushDict.value(forKey: "body") as! String
        let titleStr : String = (pushDict.value(forKey: "notification") as AnyObject).value(forKey: "title") as! String
        let bodyStr : String = (pushDict.value(forKey: "notification") as AnyObject).value(forKey: "body") as! String
        print(titleStr)
        print(bodyStr)
    }
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage)")
        print("remoteMessage: \(remoteMessage.appData)")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        print(fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        print(dataDict)
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }*/
    //MARK: UNUserNotificationCenterDelegate Method
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(notification.request.content.userInfo)")
        let userInfo = notification.request.content.userInfo
        print(userInfo)

        print("NOTIFY ALERT FOREGROUND : ",(userInfo["aps"] as! NSDictionary).value(forKey: "alert") as Any)
          let alertStr = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String
       // let alertStr1 = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as? String

        print("Final foreground: ", alertStr as Any)
        let ReceivedTypeID = userInfo[gcmTypeId] as! String
        print(ReceivedTypeID)

      
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        self.play()
//        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
//            let userInfo1 = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
//            if userInfo1 != nil {
//                // Perform action here
//                print("Custom: \(userInfo1)")
//            }
//        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let sw = storyboard.instantiateViewController(withIdentifier: "RevealViewController") as! SWRevealViewController
//        self.window?.rootViewController = sw
//        let destinationController = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController let navigationController = UINavigationController(rootViewController: destinationController) sw.pushFrontViewController(navigationController, animated: true)

        
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard:UIStoryboard
//        storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextViewController = storyboard.instantiateViewController(withIdentifier: "DummyViewController") as! DummyViewController
//       // nextViewController.isfromNotificationClick = true
//        self.window?.rootViewController = nextViewController
//        self.window?.makeKeyAndVisible()
        
        if ReceivedTypeID == "0"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
            nextViewController.isfromNotificationClick = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        else if ReceivedTypeID == "5"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            nextViewController.isfromSideBarOrNotifyPage = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
       else if ReceivedTypeID == "3"
        {
            let Orderid = userInfo[gcmOrderId] as! String
            print(Orderid)
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
          //  nextViewController.orderId = userInfo[gcmOrderIDKey] as! String
            nextViewController.isfromNotificationClick = true
            nextViewController.navigationTypeStr = "present"
            nextViewController.orderId = Orderid
            nextViewController.orderisRejected = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        else if ReceivedTypeID == "8"
        {
            let Orderid = userInfo[gcmOrderId] as! String
            print(Orderid)
            let StoreId = userInfo[gcmStoreId] as! String
            print(StoreId)
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            nextViewController.order_id = Orderid
            nextViewController.store_id = StoreId
            nextViewController.navigationTypeStr = "Notification"
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()

        }
        
        completionHandler([.alert, .badge, .sound])
    }
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         UIApplication.shared.applicationIconBadgeNumber += 1
        print("User Info = \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }

        print("NOTIFY ALERT CLICKED FROM NOTIFICATION : ",(userInfo["aps"] as! NSDictionary).value(forKey: "alert") as Any)
        let ReceivedTypeID = userInfo[gcmTypeId] as! String
        print(ReceivedTypeID)

        self.play()
        let alertStr = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String
        //let alertStr1 = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as? String
        print("Final background : ", alertStr as Any)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
       if ReceivedTypeID == "0"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
            nextViewController.isfromNotificationClick = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        else if ReceivedTypeID == "5"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            nextViewController.isfromSideBarOrNotifyPage = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }

        if ReceivedTypeID == "3"
        {
            let Orderid = userInfo[gcmOrderId] as! String
            print(Orderid)
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
          //  nextViewController.orderId = userInfo[gcmOrderIDKey] as! String
             nextViewController.orderId = Orderid
            nextViewController.isfromNotificationClick = true
            nextViewController.navigationTypeStr = "present"
            nextViewController.orderisRejected = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        else if ReceivedTypeID == "8"
        {
            let Orderid = userInfo[gcmOrderId] as! String
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
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()

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
        //        // If you are receiving a notification message while your app is in the background,
        //        // this callback will not be fired till the user taps on the notification launching the application.
        //        // TODO: Handle data of notification
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        //        // Print full message.
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
        //        // If you are receiving a notification message while your app is in the background,
        //        // this callback will not be fired till the user taps on the notification launching the application.
        //        // TODO: Handle data of notification
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        //        // Print full message.
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






