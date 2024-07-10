//
//  SideBarViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SWRevealViewController

@available(iOS 11.0, *)
class SideBarViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var sideTable: UITableView!
    @IBOutlet weak var bgImgView: UIImageView!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var nameArray = [String]()
    var imageArray = [String]()
    var iPhoneUDIDString = String()
    var window: UIWindow?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideTable.delegate = self
        self.sideTable.dataSource = self
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        
        let favStr = LanguageDictonary.object(forKey: "favourites") as! String
        let orderstr = LanguageDictonary.object(forKey: "orderhistory") as! String
        let yourAddStr = LanguageDictonary.object(forKey: "youraddress") as! String
        let myReviewStr = LanguageDictonary.object(forKey: "myreviews") as! String
        let myRewardStr = LanguageDictonary.object(forKey: "myrewards") as! String
        let offerStr = LanguageDictonary.object(forKey: "myoffers") as! String
        let walletStr = LanguageDictonary.object(forKey: "mywallet") as! String
        let referFriendStr = LanguageDictonary.object(forKey: "referfriend") as! String
        let helpStr = LanguageDictonary.object(forKey: "help") as! String
        let languageStr = LanguageDictonary.object(forKey: "language") as! String
        let signoutStr = LanguageDictonary.object(forKey: "signout") as! String
        let homeStr = LanguageDictonary.object(forKey: "home") as! String
        let deleteaccount = LanguageDictonary.object(forKey: "deleteaccount") as! String
        let settingsStr = LanguageDictonary.object(forKey: "settings") as! String
        
        //nameArray = [favStr,orderstr,yourAddStr,myReviewStr,myRewardStr,offerStr,walletStr,referFriendStr,helpStr,languageStr,signoutStr]
        nameArray = [homeStr,orderstr,offerStr,walletStr,settingsStr,helpStr,deleteaccount,signoutStr]
        
        //        nameArray.append("Favourites")
        //        nameArray.append("Order History")
        //        nameArray.append("Your Address")
        //        nameArray.append("My Reviews")
        //        nameArray.append("My Rewards")
        //        nameArray.append("My Offers")
        //        nameArray.append("My Wallet")
        //        nameArray.append("Refer Friend")
        //        nameArray.append("Help")
        //        nameArray.append("Language")
        //        nameArray.append("Sign Out")
        
        imageArray.append("ic_home_red")
        imageArray.append("ic_order_red")
        //imageArray.append("Side_location")
        //imageArray.append("side_review")
        //imageArray.append("rewards1")
        imageArray.append("OfferPercent1")
        imageArray.append("ic_wallet_red")
        //imageArray.append("side_ReferFriend_icon")
        imageArray.append("ic_settings_red")
        imageArray.append("ic_help_red")
        imageArray.append("ic_delete")
        //imageArray.append("Image")
        imageArray.append("ic_signout_red")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfileData()
    }
    
    //MARK:- Calling API methods
    func getProfileData()
    {
        let Parse = CommomParsing()
        Parse.userProfileInfo(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            if (response.value(forKey: "code")as! Int == 200){
                let mod = CustomerProfile(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.CustomerProfileModel = mod
                let user_name = Singleton.sharedInstance.CustomerProfileModel.data.userName
                login_session.setValue(user_name, forKey: "user_name")
                login_session.synchronize()
                
                self.sideTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            
        }, onFailure: {errorResponse in})
    }
    
    
    
    @objc func orderBtnTapped()
    {
        let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryPage") as! OrderHistoryPage
        let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
        self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
    }
    
    //MARK:- TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 180
        }else if indexPath.row == 1{
            return 65
        }else if indexPath.row == 11{
            return 110
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarTopCell") as? sideBarTopCell
            cell?.selectionStyle = .none
            //add blur Effects
            cell?.userImgView.layer.cornerRadius = 35.0
            cell?.userImgView.clipsToBounds = true
            //blurEffectView.frame = (cell?.bgImgView!.bounds)!
            
            //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            //cell?.bgImgView?.addSubview(blurEffectView)
            
            if Singleton.sharedInstance.CustomerProfileModel != nil{
                let userImg = URL(string: Singleton.sharedInstance.CustomerProfileModel.data.userAvatar)
                cell?.bgImgView.kf.setImage(with: userImg)
                //cell?.bgImgView.kf.setImage(with: userImg, placeholder: UIImage(named: "Profile_placeholder"), options: nil, progressBlock: nil, completionHandler: ())
                
                cell?.userImgView.kf.setImage(with: userImg)
                cell?.userNameLbl.text = Singleton.sharedInstance.CustomerProfileModel.data.userName
                cell?.userEmailLbl.text = Singleton.sharedInstance.CustomerProfileModel.data.userEmail
                
                //cell?.settingsBtn.addTarget(self, action: #selector(settingsBtnTapped), for: .touchUpInside)
            }
            return cell!
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarMidCell") as? SideBarMidCell
            cell?.selectionStyle = .none
            cell?.favLbl.text = nameArray[indexPath.row-1]
            cell?.fav_Icon.image  = UIImage(named: "\(imageArray[indexPath.row-1])")
            cell?.fav_dotImg.layer.cornerRadius = 4.0
            
            return cell!
        }else if indexPath.row == 11{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarBottomCell") as? SideBarBottomCell
            cell?.selectionStyle = .none
            cell?.nameLbl.text = nameArray[indexPath.row-1]
            cell?.iconImg.image  = UIImage(named: "\(imageArray[indexPath.row-1])")
            cell?.dotImg.layer.cornerRadius = 4.0
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarTileCell") as? SideBarTileCell
            cell?.selectionStyle = .none
            cell?.nameLbl.text = nameArray[indexPath.row-1]
            cell?.iconImg.image  = UIImage(named: "\(imageArray[indexPath.row-1])")
            cell?.dotImg.layer.cornerRadius = 4.0
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profilepageComesFrom = "sideBar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 1 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
             let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
             NotificationVC.navigationType = "sidebar"
             self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
            actAsBaseTabbar.selectedIndex = 2 //tabBarSelectedIndex
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }else if indexPath.row == 2 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryPage") as! OrderHistoryPage
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 3 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
             NotificationVC.navigationType = "sidebar"
             
             let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
             self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
            
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            NotificationVC.navigationType = "sidebar"
            NotificationVC.isfromNotificationClick = false
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 4 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyReviewPage") as! MyReviewPage
             let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
             NotificationVC.navigationType = "sidebar"
             self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
            
            if login_session.object(forKey: "user_longitude") != nil{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                tabBarSelectedIndex = 4
                mainViewController.isfromSideBarOrNotifyPage = true
                self.window?.rootViewController = mainViewController
                self.window?.makeKeyAndVisible()
            } else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SelectLocationPage")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        else if indexPath.row == 5 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyRewardsViewController") as! MyRewardsViewController
             let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
             NotificationVC.navigationType = "sidebar"
             self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
            
            settingsBtnTapped()
        }else if indexPath.row == 6 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
             let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
             NotificationVC.navigationType = "sidebar"
             NotificationVC.isfromNotificationClick = false
             self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
            
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "HelpPageViewController") as! HelpPageViewController
            NotificationVC.navigaionType = "sidebar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 7 {
            let url = URL(string: "https://delivereesapp.com/compliance")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                //If you want handle the completion block than
                UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
            self.logOut()
        }else if indexPath.row == 8 {
            /*if login_session.object(forKey: "user_longitude") != nil{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                tabBarSelectedIndex = 4
                mainViewController.isfromSideBarOrNotifyPage = true
                self.window?.rootViewController = mainViewController
                self.window?.makeKeyAndVisible()
            }else{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SelectLocationPage")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }*/
            self.logOut()
        }
        else if indexPath.row == 8 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "ReferFriendsPageViewController") as! ReferFriendsPageViewController
            NotificationVC.navigationType = "sidebar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
        }else if indexPath.row == 9 {
            /*let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "HelpPageViewController") as! HelpPageViewController
            NotificationVC.navigaionType = "sidebar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)*/
        }else if indexPath.row == 10 {
            
            /*let nav = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as? LanguageViewController
            nav?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(nav!, animated: true, completion: nil)*/
            
        }else if indexPath.row == 11 {
            //self.logOut()
        }
    }
    func logOut()
    {
        
        let lang = login_session.value(forKey: "Language") as? String ?? "es"
        
        self.showLoadingIndicator(senderVC: self)
        let tokenStr = login_session.object(forKey: "fcmToken")as? String ?? ""
        let Parse = CommomParsing()
        Parse.userLogout(lang: login_session.value(forKey: "Language") as? String ?? "es",token: tokenStr, ios_device_id: iPhoneUDIDString,type:device_type, onSuccess: {
            response in
            if (response.value(forKey: "code")as! Int == 200){
                // Logout successful
            }
            // Logout not successful but we must remove user session
            let domain = Bundle.main.bundleIdentifier!
            login_session.persistentDomain(forName: domain)
            login_session.synchronize()
            print(login_session)
            for key in login_session.dictionaryRepresentation().keys{
                login_session.removeObject(forKey: key.description)
            }
            login_session.synchronize()
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.checkRootView()
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
        login_session.setValue(lang, forKey: "Language")
    }
    
    @objc func settingsBtnTapped()
    {
        let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "SettingsPageViewController") as! SettingsPageViewController
        let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
        self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
    }
    
    
    
    
}
