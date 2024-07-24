//
//  AddressViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CoreLocation
import DropDown
import SCLAlertView

class AddressViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var alter_codeBtn: UIButton!
    @IBOutlet weak var mobile_codeBtn: UIButton!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    
    @IBOutlet weak var customLocation: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var firstNameLine: UIView!
    @IBOutlet weak var lastNameLine: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var emailLine: UIView!
    
    @IBOutlet weak var mobileNumberTxt: UITextField!
    
    @IBOutlet weak var mobileLine: UIView!
    
    @IBOutlet weak var alternateNumTxt: UITextField!
    
    @IBOutlet weak var alterLine: UIView!
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addressLine: UIView!
    
    @IBOutlet weak var addressLine2: UITextView!
    @IBOutlet weak var AddressTextView: UITextView!


    
    var navigationType = String()
    var resultDict = NSMutableDictionary()
    
    //dropDown
    let countryCodeDropDown = DropDown()
    let AltercountryCodeDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstNameTxt.placeholder = LanguageDictonary.value(forKey: "firstname") as? String
         self.lastNameTxt.placeholder = LanguageDictonary.value(forKey: "lastname") as? String
         self.mobileNumberTxt.placeholder = LanguageDictonary.value(forKey: "mobilenumber") as? String
        self.emailTxt.placeholder = LanguageDictonary.value(forKey: "emailaddress") as? String
        self.alternateNumTxt.text = LanguageDictonary.value(forKey: "alternativenumber") as? String
        self.saveBtn.setTitle(LanguageDictonary.value(forKey: "save") as? String, for: .normal)
        
        
        self.hideAllLines()
        self.getData()
        self.baseContentView = self.setCornorShadowEffects(sender: self.baseContentView)
        saveBtn.layer.cornerRadius = 2 //20.0
        saveBtn.clipsToBounds = true
        baseContentView.layer.cornerRadius = 10.0
        ActAsSelectedAddress = ""
        ActAsSelectedLatitude = ""
        ActAsSelectedLongitude = ""
        ActAsSelectedZipCode = ""
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        addressLine2.delegate = self
        addressLine2.text = "Flat No/Landmark"
        addressLine2.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "youraddress") as? String
        self.navigationController?.navigationBar.isHidden = true
        if ActAsSelectedAddress != ""{
            addressLbl.text = ActAsSelectedAddress
            self.AddressTextView.text = ActAsSelectedAddress
        }
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
        MapLocationPageFrom = "address"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK:- API Methods
    func getData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getCustomerAddress(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
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
    
    //MARK:- LOAD UI
    func setData(){
        firstNameTxt.text = (resultDict.object(forKey: "sh_cus_fname")as? String ?? "")
        lastNameTxt.text = (resultDict.object(forKey: "sh_cus_lname")as? String ?? "")
        emailTxt.text = (resultDict.object(forKey: "sh_cus_email")as? String ?? "")
        let numberOne = resultDict.object(forKey: "sh_phone1")as? String ?? ""
        let numberTwo = resultDict.object(forKey: "sh_phone2")as? String ?? ""
        
//        mobileNumberTxt.text = String(numberOne.dropFirst(3))
//        alternateNumTxt.text = String(numberTwo.dropFirst(3))
        
        self.mobile_codeBtn.setTitle((resultDict.object(forKey: "ship_cnty_code")as? String ?? ""), for: .normal)
        self.alter_codeBtn.setTitle((resultDict.object(forKey: "ship_cnty_code")as? String ?? ""), for: .normal)

        mobileNumberTxt.text = resultDict.object(forKey: "ship_ph1_no_only")as? String ?? ""
        alternateNumTxt.text = resultDict.object(forKey: "ship_ph2_no_only")as? String ?? ""
        self.AddressTextView.text = resultDict.object(forKey: "sh_location")as? String ?? ""
        addressLbl.text = (resultDict.object(forKey: "sh_location")as? String ?? "")
        
        if (resultDict.object(forKey: "sh_location1") as? String == "")
        {
            addressLine2.text = "Flat No/Landmark"
            addressLine2.textColor = UIColor.lightGray
        }
        else
        {
            addressLine2.text = (resultDict.object(forKey: "sh_location1")as? String ?? "")
            addressLine2.textColor = UIColor.darkText
        }
        

        
        //self.getAddressFromLatLon(pdblLatitude: resultDict.object(forKey: "sh_latitude")as! String, withLongitude: resultDict.object(forKey: "sh_latitude")as! String)
        if firstNameTxt.text == ""{
            firstNameTxt.text = (login_session.object(forKey: "user_name")as! String)
        }
        if emailTxt.text == ""{
            emailTxt.text = (login_session.object(forKey: "user_email")as! String)
        }
        if mobileNumberTxt.text == ""{
            mobileNumberTxt.text = ((login_session.object(forKey: "user_mobileNo") as? String) ?? "")
        }
        //alloc data to dropdown
        var ccArray = [String]()
        ccArray.append((resultDict.object(forKey: "ship_cnty_code")as? String ?? ""))
        countryCodeDropDown.dataSource = ccArray
        countryCodeDropDown.anchorView = mobile_codeBtn
        countryCodeDropDown.direction = .bottom
        countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: mobile_codeBtn.bounds.height)
        // Action triggered on selection
        countryCodeDropDown.selectionAction = { [weak self] (index, item) in
            self?.mobile_codeBtn.setTitle(item, for: .normal)
        }
        
        
        AltercountryCodeDropDown.dataSource = ccArray
        AltercountryCodeDropDown.anchorView = alter_codeBtn
        AltercountryCodeDropDown.direction = .bottom
        AltercountryCodeDropDown.bottomOffset = CGPoint(x: 0, y: alter_codeBtn.bounds.height)
        // Action triggered on selection
        AltercountryCodeDropDown.selectionAction = { [weak self] (index, item) in
            self?.alter_codeBtn.setTitle(item, for: .normal)
        }
        mobile_codeBtn.addTarget(self, action: #selector(showMobileCCDropDown), for: .touchUpInside)
        alter_codeBtn.addTarget(self, action: #selector(showMobileAlterCCDropDown), for: .touchUpInside)

    }
    
    
    @objc func showMobileCCDropDown(sender:UIButton){
        countryCodeDropDown.show()
    }
    @objc func showMobileAlterCCDropDown(sender:UIButton){
        AltercountryCodeDropDown.show()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if navigationType == "sidebar"{
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideAllLines(){
        firstNameLine.isHidden = true
        lastNameLine.isHidden = true
        emailLine.isHidden = true
        mobileLine.isHidden = true
        alterLine.isHidden = true
    }
    
    @IBAction func alter_codeBtnAction(_ sender: Any)
    {
        
    }
    
    @IBAction func mobile_codeBtnAction(_ sender: Any) {
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        var addressStr = String()
        var latitude = String()
        var longitude = String()
        var zipCode = String()
        if  ActAsSelectedAddress != ""
        {
            addressStr = ActAsSelectedAddress
            latitude = ActAsSelectedLatitude
            longitude = ActAsSelectedLongitude
            zipCode = ActAsSelectedZipCode
        }else{
            addressStr = resultDict.object(forKey: "sh_location")as? String ?? ""
            latitude = resultDict.object(forKey: "sh_latitude")as? String ?? ""
            longitude = resultDict.object(forKey: "sh_longitude")as? String ?? ""
            zipCode = resultDict.object(forKey: "sh_zipcode")as? String ?? ""
        }
        
        if firstNameTxt.text?.count == 0 && firstNameTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenterfirstname") as! String)
        }else if lastNameTxt.text?.count == 0 && lastNameTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenterlastname") as! String)
        }else if emailTxt.text?.count == 0 && emailTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteremailtocontinue") as! String)
        }else if mobileNumberTxt.text?.count == 0 && mobileNumberTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentermobiletocontinue") as! String)
        }else if addressStr == "" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseselectaddress") as! String)
        }else if self.addressLine2.text.count == 0 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "flatlandmark") as! String)
        }else if self.addressLine2.text == "Flat No/Landmark" || self.addressLine2.text == "No. Apt./ Casa / Punto de Referencia" {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "flatlandmark") as! String)
        }

        else{
            self.showLoadingIndicator(senderVC: self)
            let Parse = CommomParsing()
            let mobileNumber = (resultDict.object(forKey: "ship_cnty_code")as? String ?? "") + mobileNumberTxt.text!
            let alterMobileNumber = (resultDict.object(forKey: "ship_cnty_code")as? String ?? "") + alternateNumTxt.text!
            Parse.updateUserShippingAddress(lang: login_session.value(forKey: "Language") as? String ?? "es",sh_cus_fname: firstNameTxt.text! ,sh_cus_lname: lastNameTxt.text!,sh_cus_email: emailTxt.text!,sh_phone1: mobileNumber,sh_phone2: alterMobileNumber,sh_location: addressStr,sh_latitude:latitude ,sh_longitude:longitude, sh_zipcode:zipCode,sh_location1: self.addressLine2.text, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    login_session.setValue(latitude, forKey: "user_latitude")
                    login_session.setValue(longitude, forKey: "user_longitude")

                    isfromShippingAddressPage = true
                    self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 16.0)!,
            kButtonFont: UIFont(name: "TruenoRg", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
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
    
    //TextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.darkText
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "Flat No/Landmark"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideAllLines()
        if(textField == firstNameTxt){
            firstNameLine.isHidden = false
        }else if(textField == lastNameTxt){
            lastNameLine.isHidden = false
        }else if(textField == emailTxt){
            emailLine.isHidden = false
        }else if(textField == mobileNumberTxt){
            mobileLine.isHidden = false
        }else if(textField == alternateNumTxt){
            alterLine.isHidden = false
        }
    }

}
