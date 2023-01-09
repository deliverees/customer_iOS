//
//  SettingsPageViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class SettingsPageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var navigaitonTitleLbl: UILabel!
    @IBOutlet weak var baseContentView: UIView!
    
    @IBOutlet weak var settingsTable: UITableView!
    var imageArray = [String]()
    var nameArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding Image name
        imageArray.append("key")
        imageArray.append("Info_orange")
        imageArray.append("login_username")
        //imageArray.append("Language")
        imageArray.append("Payment_settings")
        imageArray.append("Terms")
        imageArray.append("Notification")
        
        //adding Lable Name
        nameArray.append(LanguageDictonary.value(forKey: "changepassword") as! String)
        nameArray.append(LanguageDictonary.value(forKey: "about") as! String)
        nameArray.append(LanguageDictonary.value(forKey: "profile") as! String)
        //nameArray.append("Language")
        nameArray.append(LanguageDictonary.value(forKey: "paymentsettings") as! String)
        nameArray.append(LanguageDictonary.value(forKey: "termasconditions") as! String)
        nameArray.append("Promotional Notification")
        
//        baseContentView.layer.cornerRadius  = 10.0
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigaitonTitleLbl.text = LanguageDictonary.value(forKey: "settings") as? String
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count-1
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 5{
//            return 0
//        }
//        return 50
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTBCell") as? SettingsTBCell
        cell?.selectionStyle = .none
        cell?.rightImg.image = UIImage(named: imageArray[indexPath.row])
        cell?.nameLbl.text = nameArray[indexPath.row]
        if indexPath.row == 5{
            cell?.rightArrow.isHidden = true
            cell?.switchControl.isHidden = false
            cell?.orange_BG.isHidden = false
            cell?.orange_BG.layer.cornerRadius = 5.0
            cell?.orange_BG.clipsToBounds = true
            cell?.orange_BG.image = UIImage(named: "orange_BG")
        }else{
            cell?.rightArrow.isHidden = false
            cell?.switchControl.isHidden = true
            cell?.orange_BG.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSettingsPageViewController") as! PaymentSettingsPageViewController
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 0 {
            let PopMapVC = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordViewController") as? changePasswordViewController
            PopMapVC?.modalPresentationStyle = .overFullScreen
            PopMapVC?.modalTransitionStyle = .crossDissolve
            self.present(PopMapVC!, animated: true, completion: nil)
            //MIBlurPopup.show(PopMapVC!, on: self);

        }else if indexPath.row == 1 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutPageViewController") as! AboutPageViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }else if indexPath.row == 2 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profilepageComesFrom = "settings"
            self.present(nextViewController, animated:true, completion:nil)
            
        }else if indexPath.row == 4 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }
    }
}
