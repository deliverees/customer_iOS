//
//  LanguageViewController.swift
//  ShopUrFood_Customer
//
//  Created by saravanan2 on 03/10/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import MIBlurPopup


class LanguageViewController: UIViewController {

    @IBOutlet weak var closeBut: UIButton!
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var submitBut: UIButton!
    @IBOutlet weak var englishImg: UIImageView!
    @IBOutlet weak var spanishImg: UIImageView!
    @IBOutlet weak var languageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.languageLbl.text = LanguageDictonary.value(forKey: "language") as? String
        self.submitBut.setTitle(LanguageDictonary.object(forKey: "submit") as? String, for: .normal)
        
          modalPresentationCapturesStatusBarAppearance = true
        self.closeBut.layer.cornerRadius = 20
        self.closeBut.layer.masksToBounds = true
        self.submitBut.layer.cornerRadius = 5
         self.submitBut.layer.masksToBounds = true
        self.totalView.layer.cornerRadius = 5.0
        self.totalView.layer.masksToBounds = false
        self.totalView.layer.shadowColor = UIColor.lightGray.cgColor
        self.totalView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.totalView.layer.shadowOpacity = 0.6
        
         if login_session.value(forKey: "Language") == nil {
            
        }else if login_session.value(forKey: "Language") as! String == "en" {
               self.englishImg.image = UIImage(named: "select_radio")
             }else{
              self.spanishImg.image = UIImage(named: "select_radio")
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitAct(_ sender: UIButton) {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.languageUpdate()
       
        appDelegate?.checkRootView()
    }
    @IBAction func english_Act(_ sender: UIButton) {
        self.spanishImg.image = UIImage(named: "unSelectRadio")
        self.englishImg.image = UIImage(named: "select_radio")
         login_session.setValue("en", forKey: "Language")
    }
    
    @IBAction func apanishAct(_ sender: UIButton) {
        self.spanishImg.image = UIImage(named: "select_radio")
        self.englishImg.image = UIImage(named: "unSelectRadio")
         login_session.setValue("es", forKey: "Language")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
