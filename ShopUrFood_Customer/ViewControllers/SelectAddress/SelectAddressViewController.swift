//
//  SelectAddressViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CoreLocation

@available(iOS 11.0, *)
class SelectAddressViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var sameShippingBtn: UIButton!
    @IBOutlet weak var pickUpYesBtn: UIButton!
    @IBOutlet weak var pickUpNoBtn: UIButton!
    @IBOutlet weak var pickUpYesImageView: UIImageView!
    @IBOutlet weak var pickUpNoImageView: UIImageView!
    @IBOutlet weak var pickUpNotAvailableLbl: UILabel!
    @IBOutlet weak var selfPickUpTitleLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var firstNameLine: UIView!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var lastNameLine: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var mobileNoCountryCodeBtn: UIButton!
    @IBOutlet weak var alternateNumberTxt: UITextField!
    @IBOutlet weak var alterNoCountryCodeBtn: UIButton!
    @IBOutlet weak var customerAddressTxt: UITextField!
    @IBOutlet weak var customerAddressTxtView2: UITextView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var alterLine: UIView!
    @IBOutlet weak var mobileLine: UIView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var selfPickupView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var restaurantLocationLbl: UILabel!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var skipAndContinueBtn: UIButton!
    
    var resultDict = NSMutableDictionary()
    var sameShippingFlag = Bool()
    var selfPickupStatus = String()
    var storeName = String()
    var storeLocation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "shippingsddress") as? String
        self.pickUpNotAvailableLbl.text = LanguageDictonary.value(forKey: "notavailable") as? String
        self.selfPickUpTitleLbl.text =  LanguageDictonary.value(forKey: "chooseyouroption") as? String
        self.pickUpNoBtn.setTitle(LanguageDictonary.value(forKey: "delivery") as? String, for: .normal)
        self.pickUpYesBtn.setTitle(LanguageDictonary.value(forKey: "selfpickup") as? String, for: .normal)
        self.sameShippingBtn.setTitle(LanguageDictonary.value(forKey: "selfpickup") as? String, for: .normal)
        self.mobileNumberTxt.placeholder = LanguageDictonary.value(forKey: "mobilenumber") as? String
        self.customerAddressTxt.placeholder = LanguageDictonary.value(forKey: "flatlandmark") as? String
        self.lastNameTxt.placeholder = LanguageDictonary.value(forKey: "lastname") as? String
        self.alternateNumberTxt.placeholder = LanguageDictonary.value(forKey: "alternativenumber") as? String
        self.firstNameTxt.placeholder = LanguageDictonary.value(forKey: "firstname") as? String
        self.emailTxt.placeholder = LanguageDictonary.value(forKey: "emailaddress") as? String
        self.continueBtn.setTitle(LanguageDictonary.value(forKey: "continue") as? String, for: .normal)
        self.skipAndContinueBtn.setTitle(LanguageDictonary.value(forKey: "skipcontinue") as? String, for: .normal)
        
        
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        continueBtn.layer.cornerRadius = 2 //20.0
        skipAndContinueBtn.layer.cornerRadius = 2 //20.0
        self.getData()
        sameShippingFlag = true
        restaurantNameLbl.text = "  " + storeName
        restaurantLocationLbl.text = storeLocation
        pickUpView.layer.cornerRadius = 5.0
        pickUpView = self.setCornorShadowEffects(sender: pickUpView)
    }
    
    private var newLocation: ChangeAddressDTO?
    @IBAction private func tapEditAddress(sender: Any?) {
        MapLocationPageFrom = "select-address"
        var coordinate: CLLocationCoordinate2D?
        if let newLocation {
            coordinate = .init(latitude: newLocation.latitude,
                               longitude: newLocation.longitude)
        }
        AppRouter.shared.presentMapLocation(from: self, userLocation: coordinate) { [weak self] newAddress in
            self?.newLocation = newAddress
            self?.customerAddressTxtView2.text = newAddress.addressString
            self?.customerAddressTxt.text = newAddress.addressAdditional
        }
    }
    
    private func presentEditAddressAlert() {
        let alert = UIAlertController(title: Localization.value(for: "select_address_edit_address_alert_title"),
                                      message: Localization.value(for: "select_address_edit_address_alert_message"),
                                      preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Modificar",
                                       style: .cancel) { _ in
            alert.dismiss(animated: false)
            self.showLoadingIndicator(senderVC: self)
            self.tapEditAddress(sender: nil)
            self.stopLoadingIndicator(senderVC: self)
        }
        
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default)
        
        alert.addAction(editAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentEditAddressAlert()
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
                self.selfPickupStatus = (self.resultDict.object(forKey: "self_pickup_status")as! NSNumber).stringValue
                
                self.pickUpYesBtn.isHidden = false
                self.pickUpNoBtn.isHidden = false
                self.pickUpYesImageView.isHidden = false
                self.pickUpNoImageView.isHidden = false
                self.pickUpNotAvailableLbl.isHidden = true
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
        
        mobileNumberTxt.text = resultDict.object(forKey: "ship_ph1_no_only")as? String ?? ""
        alternateNumberTxt.text = resultDict.object(forKey: "ship_ph2_no_only")as? String ?? ""
        mobileNoCountryCodeBtn.setTitle(resultDict.object(forKey: "ship_cnty_code")as? String ?? "", for: .normal)
        alterNoCountryCodeBtn.setTitle(resultDict.object(forKey: "ship_cnty_code")as? String ?? "", for: .normal)
        
        let additionalAddressString = resultDict.value(forKey: "sh_location1") as? String ?? ""
        let addressString = resultDict.value(forKey: "sh_location") as? String ?? ""
        let zipCode = resultDict.value(forKey: "sh_zipcode") as? String
        customerAddressTxtView2.text = addressString
        if let longitudeString = resultDict.value(forKey: "sh_longitude") as? String,
           let latitudeSstring = resultDict.value(forKey: "sh_latitude") as? String,
           let longitude = Double(longitudeString),
           let latitude = Double(latitudeSstring) {
            newLocation = .init(latitude: latitude,
                                longitude: longitude,
                                addressString: addressString,
                                addressAdditional: additionalAddressString,
                                zipCode: zipCode)
        }
        customerAddressTxtView2.textColor = UIColor.darkText
        customerAddressTxtView2.isUserInteractionEnabled = false
        
        customerAddressTxt.text = additionalAddressString
        
        if firstNameTxt.text == ""{
            firstNameTxt.text = (login_session.object(forKey: "user_name")as! String)
        }
        if emailTxt.text == ""{
            emailTxt.text = (login_session.object(forKey: "user_email")as! String)
        }
        if mobileNumberTxt.text == ""{
            mobileNumberTxt.text = ((login_session.object(forKey: "user_mobileNo") as? String) ?? "")
        }
        
    }
    
    func setEmptyData()
    {
        firstNameTxt.text = ""
        lastNameTxt.text = ""
        emailTxt.text = ""
        mobileNumberTxt.text = ""
        alternateNumberTxt.text = ""
        
        
        firstNameTxt.isUserInteractionEnabled = true
        lastNameTxt.isUserInteractionEnabled = true
        emailTxt.isUserInteractionEnabled = true
        mobileNumberTxt.isUserInteractionEnabled = true
        alternateNumberTxt.isUserInteractionEnabled = true
        customerAddressTxt.isUserInteractionEnabled = true
        customerAddressTxtView2.isUserInteractionEnabled = false
        mobileNumberTxt.keyboardType = .numberPad
        alternateNumberTxt.keyboardType = .numberPad
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                print(addressString)
                self.customerAddressTxtView2.text  = addressString
            }
        })
        
    }
    
    //MARK:- Button Actions
    @IBAction func skipAndContinueBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
        nextViewController.pickUpType = "self"
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        if let newLocation {
            Task { @MainActor in
                showLoadingIndicator(senderVC: self)
                do {
                    try await verifyNewLocation(newLocation)
                    stopLoadingIndicator(senderVC: self)
                    continueToPaymentOption()
                } catch {
                    stopLoadingIndicator(senderVC: self)
                    showTokenExpiredPopUp(msgStr: error.localizedDescription)
                }
            }
        } else {
            continueToPaymentOption()
        }
    }
    
    private func verifyNewLocation(_ address: ChangeAddressDTO) async throws {
        try await Task {
            guard let storeId = Singleton.sharedInstance.MyCartModel.data.cartDetails.first?.storeId else {
                throw "Invalid Store selected"
            }
            
            let usecase = CheckShippingAddressUseCase()
            let response = try await usecase.execute(.init(user_lat: address.latitude,
                                            user_long: address.longitude,
                                            store_id: storeId))
            guard response.status == .valid else {
                throw response.message
            }
        }.value
    }
    
    @IBAction func alterCodeBtnAction(_ sender: Any) {
    }
    @IBAction func mobileCodeBtnAction(_ sender: Any) {
    }
    
    private func continueToPaymentOption() {
        if sameShippingFlag {
            if firstNameTxt.text == "" || firstNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenterfirstname") as! String)
            }else if lastNameTxt.text == "" || lastNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenterlastname") as! String)
            }else if emailTxt.text == "" || emailTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteremailtocontinue") as! String)
            }else if mobileNumberTxt.text == "" || mobileNumberTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentermobiletocontinue") as! String)
            }else if customerAddressTxt.text == "" || customerAddressTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "flatlandmark") as! String)
            }else{
                resultDict.setValue(firstNameTxt.text, forKey: "sh_cus_fname")
                resultDict.setValue(lastNameTxt.text, forKey: "sh_cus_lname")
                resultDict.setValue(emailTxt.text, forKey: "sh_cus_email")
                resultDict.setValue("\(mobileNoCountryCodeBtn.titleLabel?.text ?? "")\(mobileNumberTxt.text ?? "")", forKey: "sh_phone1")
                resultDict.setValue("\(alterNoCountryCodeBtn.titleLabel?.text ?? "")\(alternateNumberTxt.text ?? "")", forKey: "sh_phone2")
                resultDict.setValue(customerAddressTxt.text, forKey: "sh_location1")
                resultDict.setValue(customerAddressTxtView2.text, forKey: "sh_location")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
                nextViewController.addressDict = resultDict
                nextViewController.pickUpType = "delivery"
                self.present(nextViewController, animated:true, completion:nil)
            }
        }else{
            if firstNameTxt.text == "" || firstNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr:  LanguageDictonary.value(forKey: "pleaseenterfirstname") as! String)
            }else if lastNameTxt.text == "" || lastNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenterlastname") as! String)
            }else if emailTxt.text == "" || emailTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseenteremailtocontinue") as! String)
            }else if mobileNumberTxt.text == "" || mobileNumberTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentermobiletocontinue") as! String)
            }else if customerAddressTxt.text == "" || customerAddressTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "flatlandmark") as! String)
            }
            else{
                let addressDict = NSMutableDictionary()
                addressDict.setValue(firstNameTxt.text, forKey: "sh_cus_fname")
                addressDict.setValue(lastNameTxt.text, forKey: "sh_cus_lname")
                addressDict.setValue(emailTxt.text, forKey: "sh_cus_email")
                addressDict.setValue("\(mobileNoCountryCodeBtn.titleLabel?.text ?? "")\(mobileNumberTxt.text ?? "")", forKey: "sh_phone1")
                addressDict.setValue("\(alterNoCountryCodeBtn.titleLabel?.text ?? "")\(alternateNumberTxt.text ?? "")", forKey: "sh_phone2")
                let landmarkStr = resultDict.object(forKey: "sh_location1")as! String
                let locationStr = resultDict.object(forKey: "sh_location")as! String
                let latitude = resultDict.object(forKey: "sh_latitude")as! String
                let longitute = resultDict.object(forKey: "sh_longitude")as! String
                addressDict.setValue(landmarkStr, forKey: "sh_location1")
                addressDict.setValue(locationStr, forKey: "sh_location")
                addressDict.setValue(latitude, forKey: "sh_latitude")
                addressDict.setValue(longitute, forKey: "sh_longitude")
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
                nextViewController.addressDict = addressDict
                nextViewController.pickUpType = "delivery"
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
    }
    
    @IBAction func sameShippingBtnAction(_ sender: Any) {
        if sameShippingFlag{
            sameShippingFlag = false
            self.setEmptyData()
            sameShippingBtn.setImage(UIImage(named: "checkBox"), for: .normal)
        }else{
            sameShippingFlag = true
            self.setData()
            self.hideLines()
            sameShippingBtn.setImage(UIImage(named: "selectedCheckBox"), for: .normal)
        }
    }
    @IBAction func pickUpYesBtnAction(_ sender: Any) {
        pickUpYesImageView.image = UIImage(named: "self_pickup-orange")
        pickUpNoImageView.image = UIImage(named: "delivery_man-grey")
        selfPickupView.isHidden = false
    }
    
    @IBAction func pickUpNoBtnAction(_ sender: Any) {
        pickUpYesImageView.image = UIImage(named: "self_pickup-grey")
        pickUpNoImageView.image = UIImage(named: "delivery_man")
        selfPickupView.isHidden = true
    }
    
    
    //MARK:- TextFiled delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideLines()
        if textField == firstNameTxt{
            firstNameLine.isHidden = false
        }else if textField == lastNameTxt{
            lastNameLine.isHidden = false
        }else if textField == emailTxt{
            emailLine.isHidden = false
        }else if textField == mobileNumberTxt{
            mobileLine.isHidden = false
        }else if textField == alternateNumberTxt{
            alterLine.isHidden = false
        }
    }
    
    func hideLines(){
        self.firstNameLine.isHidden = true
        self.lastNameLine.isHidden = true
        self.emailLine.isHidden = true
        self.mobileLine.isHidden = true
        self.alterLine.isHidden = true
        
    }
    
}
