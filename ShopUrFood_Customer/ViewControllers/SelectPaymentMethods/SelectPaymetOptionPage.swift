//
//  SelectPaymetOptionPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 18/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SCLAlertView
import CCValidator
import AMPopTip

@available(iOS 11.0, *)
class SelectPaymetOptionPage: BaseViewController,UITableViewDelegate,UITableViewDataSource,PayPalPaymentDelegate,SambagMonthYearPickerViewControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var paymentSettingsErrorLbl: UILabel!
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var baseContentView: UIView!
    
    @IBOutlet weak var paymentTable: UITableView!
    @IBOutlet weak var pageTitleLbl: UILabel!
    
    //Coupon offers view
    @IBOutlet weak var couponGrayView: UIView!
    @IBOutlet weak var couponPopupView: UIView!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var couponPopupCloseButton: UIButton!
    
    @IBOutlet weak var peakBGView: UIView!
    @IBOutlet weak var peakClickedPopupview: UIView!
    @IBOutlet weak var peakDescLbl: UILabel!
    @IBOutlet weak var peakChargeLbl: UILabel!
    
    @IBOutlet weak var offersforLbl: UILabel!
    @IBOutlet weak var warningLbl: UILabel!
    
    var selectedPaymetMethod = String()
    var paymentMethodsArray = [String]()
    var walletAvailableBalance = Float()
    var walletCurrency = String()
    var termsConditions = String()
    var useWallet = Bool()
    let popTip = PopTip()
    var direction = PopTipDirection.up
    
    //Coupon Variables
    var useCouponOffer = Bool()
    var selectedCouponPrice = String()
    var selectedCouponID = String()
    var couponisUsed = String()
    
    var couponListArray = NSMutableArray()
    
    var fullAmtPayByWallet = Bool()
    var addressDict = NSMutableDictionary()
    var pickUpType = String()
    var isfromRepeatOrderAPIResponse = Bool()
    
    var customerManagepaypalFlag = Bool()
    var customerManageStripeFlag = Bool()
    var customerNetBankingFlag = Bool()
    
    var userAllowedToPay = Bool()
    var adminManagepaypalFlag = Bool()
    var adminManageStripeFlag = Bool()
    var adminManageCODFlag = Bool()
    var userPaymentDict = NSMutableDictionary()
    
    var paymentResultDict = NSMutableDictionary()
    
    
    //USED FOR OFFERS AND WALLET APPLY
    var selfOrderPickUpforAPI = String()
    
    var deliveryFeeAmountforAPI = String()
    
    var walletAmountforAPI = String()
    var walletUsedStatusForAPI = String()
    
    var couponIDforAPI = String()
    var couponAmountforAPI = String()
    var couponUsedStatusForAPI = String()
    
    
    var finalPayable_amount = String()
    var finalWallet_Amount = String()
    var finalCoupon_Amount = String()
    var finalMessage = String()
    
    @IBOutlet weak var cartGrayView: UIView!
    @IBOutlet weak var cartPaymentPopUpView: UIView!
    @IBOutlet weak var cartOrangelineView: UIView!
    @IBOutlet weak var cartOKButton: UIButton!
    
    var remainingAmountCalc = Float()
    
    //PayPal Variables
    var payPalConfig = PayPalConfiguration()
    //MARK:- PayPal Constants
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "payment") as? String
        
        self.pageTitleLbl.text = LanguageDictonary.value(forKey: "choosehowtopay") as? String
        self.warningLbl.text = LanguageDictonary.value(forKey: "warning") as? String
        self.cartOKButton.setTitle(LanguageDictonary.value(forKey: "continue") as? String, for: .normal)
        self.skipBtn.setTitle(LanguageDictonary.value(forKey: "skip") as? String, for: .normal)
        self.offersforLbl.text = LanguageDictonary.value(forKey: "offerforyou") as? String
        
        
        self.walletUsedStatusForAPI = "0"
        self.couponUsedStatusForAPI = "0"
        self.selfOrderPickUpforAPI = "0"
        self.couponIDforAPI = ""
        self.couponAmountforAPI = "0"
        self.walletAmountforAPI = "0"
        
        userAllowedToPay = false
        self.showLoadingIndicator(senderVC: self)
        paymentMethodsArray.append(LanguageDictonary.value(forKey: "paypal") as! String)
        paymentMethodsArray.append(LanguageDictonary.value(forKey: "stripe") as! String)
        paymentMethodsArray.append(LanguageDictonary.value(forKey: "cod") as! String)
        
        selectedPaymetMethod = ""
        termsConditions = "not agree"
        useWallet = false
        useCouponOffer = false
        fullAmtPayByWallet = false
        isfromRepeatOrderAPIResponse = false
        
        couponGrayView.isHidden = true
        couponPopupView.layer.cornerRadius = 8.0
        couponPopupView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        peakBGView.addGestureRecognizer(tap)
        peakBGView.isUserInteractionEnabled = true
        self.view.addSubview(peakBGView)
        
        peakClickedPopupview.layer.cornerRadius = 8.0
        peakClickedPopupview.layer.masksToBounds = true
        
        remainingAmountCalc = exactToatlAmt
        
        //         if peakHourFeeStatus == "1"
        //         {
        //         self.peakDescLbl.text = peakHour_Info
        //         self.peakChargeLbl.text = "Extra Charges : " + peakCurrency + peakHourFee
        //         }
        
        
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        self.getData()
        
        cartGrayView.isHidden = true
        
        // Do any additional setup after loading the view.
        popTip.font = UIFont(name: "Avenir-Medium", size: 12)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        popTip.actionAnimation = .bounce(8)
        
        popTip.tapHandler = { _ in
            print("tap")
        }
        
        popTip.tapOutsideHandler = { _ in
            print("tap outside")
        }
        
        popTip.swipeOutsideHandler = { _ in
            print("swipe outside")
        }
        
        popTip.dismissHandler = { _ in
            print("dismiss")
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        cartGrayView.addGestureRecognizer(tap1)
        cartGrayView.isUserInteractionEnabled = true
        self.view.addSubview(cartGrayView)
        
        cartPaymentPopUpView.layer.cornerRadius = 8.0
        
        cartOrangelineView.clipsToBounds = true
        cartOrangelineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cartOrangelineView.layer.cornerRadius = 6
        cartOrangelineView.layer.masksToBounds = true
        
        cartOKButton.layer.cornerRadius = 2 //20.0
        skipBtn.layer.cornerRadius = 2 //20.0
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        peakBGView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PaymetData()
    }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer){
        cartGrayView.isHidden = true
    }
    
    
    @objc func peakHoursBtnClicked(sender:UIButton)
    {
        //peakBGView.isHidden = false
        popTip.arrowRadius = 0
        popTip.arrowRadius = 2
        popTip.bubbleColor = UIColor.black
        let tempCard = self.paymentTable.viewWithTag(1001)
        popTip.show(text: "\(peakHour_Info)\("\n")\("Extra Charges : ")\(peakCurrency)\(peakHourFee)", direction: direction, maxWidth: 200, in: tempCard!, from: sender.frame)
        
        //  popTip.show(text: "Animated popover, great for subtle UI tips and onboarding", direction: direction, maxWidth: 200, in: tempCard!, from: sender.frame)
    }
    
    
    @IBAction func cartOKBtnAction(_ sender: Any)
    {
        cartGrayView.isHidden = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSettingsPageViewController") as! PaymentSettingsPageViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
        self.cartGrayView.isHidden = true
        userAllowedToPay = true
        
        if selectedPaymetMethod == "PAYMENT IN CASH" || selectedPaymetMethod == "PAGO EN EFECTIVO" //"Cash On Delivery"
        {
            self.PaymentOnCOD()
        }
        else if selectedPaymetMethod == "PayPal"
        {
            
            self.payByPaypal()
            login_session.setValue("0", forKey: "userCartCount")
        }
        else if selectedPaymetMethod == "STRIPE" || selectedPaymetMethod == "Raya"
        {
            if userAllowedToPay
            {
                let tempCard = self.paymentTable.viewWithTag(111) as? UITextField
                let tempExp = self.paymentTable.viewWithTag(222)as? UITextField
                let tempCvv = self.paymentTable.viewWithTag(333)as? UITextField
                if tempCard?.text == "" || tempCard?.text?.count == 0 {
                    self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "carddetails") as! String)
                }else if tempExp?.text == "" || tempExp?.text?.count == 0 {
                    self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "cardexpired") as! String)
                }else if tempCvv?.text == "" || tempCvv?.text?.count == 0 {
                    self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentercvv") as! String)
                }else{
                    let commonDateStr = tempExp?.text
                    let dateArray = commonDateStr?.components(separatedBy: "-")
                    let expMonth = self.monthConverstion(month: dateArray![0])
                    let expYear = dateArray![1]
                    self.isValidCard(cardNumber: (tempCard?.text)!, ExpMonth: expMonth, ExpYear: expYear, cvv: (tempCvv?.text)!)
                    login_session.setValue("0", forKey: "userCartCount")
                    
                }
            }
            
            
        }
    }
    
    //MARK:- API Methods
    func PaymetData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getCustomerPaymentDetails(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.userPaymentDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                if self.userPaymentDict.object(forKey: "payment_status_err")as! String == ""{
                    self.userAllowedToPay = true
                }else{
                    self.userAllowedToPay = false
                    self.paymentSettingsErrorLbl.text = (self.userPaymentDict.object(forKey: "payment_status_err")as! String)
                }
                
            }
            //            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            //            {
            //                
            //            }
            //            else
            //            {
            //                
            //            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- API Methods
    func getWalletData(){
        let Parse = CommomParsing()
        Parse.myWalletData(lang: login_session.value(forKey: "Language") as? String ?? "es",page_no: "1", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                let walletStringValue = tempDict.object(forKey: "available_balance") as? String ?? "0.0"
                self.walletAvailableBalance = Float(walletStringValue) ?? 0
                self.walletCurrency = tempDict.object(forKey: "currency_code")as! String
                self.paymentTable.reloadData()
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func useWalletAmount()
    {
        if pickUpType == "self"
        {
            self.selfOrderPickUpforAPI = "1"
        }
        else
        {
            self.selfOrderPickUpforAPI = "0"
        }
        
        if useWallet == true
        {
            self.deliveryFeeAmountforAPI = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
            let Parse = CommomParsing()
            Parse.useWalletMethod(lang: login_session.value(forKey: "Language") as? String ?? "es", ord_self_pickup: self.selfOrderPickUpforAPI, use_wallet: self.walletUsedStatusForAPI, wallet_amt: self.walletAvailableBalance, delivery_fee: self.deliveryFeeAmountforAPI, use_coupon: self.couponUsedStatusForAPI, coupon_id: self.couponIDforAPI, coupon_amount: self.couponAmountforAPI, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    self.finalPayable_amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "payable_amount") as? String)!
                    
                    if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String) != nil)
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String)!
                    }
                    else
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? NSNumber)!.stringValue
                    }
                    
                    if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as? String) != nil)
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! String)
                    }
                    else
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! NSNumber).stringValue
                    }
                    
                    self.finalMessage = response.object(forKey: "message") as! String
                    
                    if self.finalMessage == "No need to pay"
                    {
                        self.fullAmtPayByWallet = true
                        self.selectedPaymetMethod = ""
                    }
                    
                    self.paymentTable.reloadData()
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                }
            }, onFailure: {errorResponse in})
        }
        else
        {
            self.deliveryFeeAmountforAPI = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
            let Parse = CommomParsing()
            Parse.useWalletMethod(lang: login_session.value(forKey: "Language") as? String ?? "es", ord_self_pickup: self.selfOrderPickUpforAPI, use_wallet: self.walletUsedStatusForAPI, wallet_amt: self.walletAmountforAPI, delivery_fee: self.deliveryFeeAmountforAPI, use_coupon: self.couponUsedStatusForAPI, coupon_id: self.couponIDforAPI, coupon_amount: self.couponAmountforAPI, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    self.finalPayable_amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "payable_amount") as? String)!
                    
                    if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as? String) != nil)
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! String)
                    }
                    else
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! NSNumber).stringValue
                    }
                    
                    
                    if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String) != nil)
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String)!
                    }
                    else
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? NSNumber)!.stringValue
                    }
                    self.finalMessage = response.object(forKey: "message") as! String
                    
                    if self.finalMessage == "No need to pay"
                    {
                        self.fullAmtPayByWallet = true
                        self.selectedPaymetMethod = ""
                    }
                    
                    self.paymentTable.reloadData()
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                }
            }, onFailure: {errorResponse in})
        }
    }
    
    
    func useOfferAmount()
    {
        if pickUpType == "self"
        {
            self.selfOrderPickUpforAPI = "1"
        }
        else
        {
            self.selfOrderPickUpforAPI = "0"
        }
        
        if useWallet == true
        {
            self.deliveryFeeAmountforAPI = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
            let Parse = CommomParsing()
            Parse.useOfferMethod(lang: login_session.value(forKey: "Language") as? String ?? "es", ord_self_pickup: self.selfOrderPickUpforAPI, use_wallet: self.walletUsedStatusForAPI, wallet_amt: self.walletAvailableBalance, delivery_fee: self.deliveryFeeAmountforAPI, use_coupon: self.couponUsedStatusForAPI, coupon_id: self.couponIDforAPI, coupon_amount: self.couponAmountforAPI, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    self.finalPayable_amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "payable_amount") as? String)!
                    
                    if (response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as! String == "0"
                    {
                        self.finalWallet_Amount = "0"
                    }
                    else if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String) != nil)
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String)!
                    }
                    else if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? Int) != nil)
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? NSNumber)!.stringValue
                    }
                    else
                    {
                        self.finalWallet_Amount = "0"
                    }
                    
                    if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as? String) != nil)
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! String)
                    }
                    else
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! NSNumber).stringValue
                    }
                    
                    self.finalMessage = response.object(forKey: "message") as! String
                    
                    if self.finalMessage == "No need to pay"
                    {
                        self.useCouponOffer = false
                        self.couponGrayView.isHidden = true
                        //self.showToastAlert(senderVC: self, messageStr: "There is no balance amount for apply coupon offers !")
                    }
                    else
                    {
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    }
                    
                    self.paymentTable.reloadData()
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                    if self.finalCoupon_Amount == ""
                    {
                        self.useCouponOffer = false
                    }
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    if self.finalCoupon_Amount == ""
                    {
                        self.useCouponOffer = false
                    }
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else
                {
                    
                }
            }, onFailure: {errorResponse in})
        }
        else
        {
            self.deliveryFeeAmountforAPI = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
            let Parse = CommomParsing()
            Parse.useOfferMethod(lang: login_session.value(forKey: "Language") as? String ?? "es", ord_self_pickup: self.selfOrderPickUpforAPI, use_wallet: self.walletUsedStatusForAPI, wallet_amt: self.walletAmountforAPI, delivery_fee: self.deliveryFeeAmountforAPI, use_coupon: self.couponUsedStatusForAPI, coupon_id: self.couponIDforAPI, coupon_amount: self.couponAmountforAPI, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    self.finalPayable_amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "payable_amount") as? String)!
                    
                    if (response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as! String == "0"
                    {
                        self.finalWallet_Amount = "0"
                    }
                    else if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String) != nil)
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? String)!
                    }
                    else if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? Int) != nil)
                    {
                        self.finalWallet_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_wallet") as? NSNumber)!.stringValue
                    }
                    else
                    {
                        self.finalWallet_Amount = "0"
                    }
                    
                    if (((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as? String) != nil)
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! String)
                    }
                    else
                    {
                        self.finalCoupon_Amount = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "used_offer") as! NSNumber).stringValue
                    }
                    
                    self.finalMessage = response.object(forKey: "message") as! String
                    
                    if self.finalMessage == "No need to pay"
                    {
                        self.useCouponOffer = false
                        self.couponGrayView.isHidden = true
                        //self.showToastAlert(senderVC: self, messageStr: "There is no balance amount for apply coupon offers !")
                    }
                    else
                    {
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    }
                    
                    self.paymentTable.reloadData()
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                    if self.finalCoupon_Amount == ""
                    {
                        self.useCouponOffer = false
                    }
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    if self.finalCoupon_Amount == ""
                    {
                        self.useCouponOffer = false
                    }
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                }
            }, onFailure: {errorResponse in})
        }
    }
    
    func getData()
    {
        let Parse = CommomParsing()
        Parse.getPaymentMethods(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                self.paymentResultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                print("PAYMENT DETAILS RESPONSE : ",self.paymentResultDict)
                if (self.paymentResultDict.object(forKey: "counpon_list") as? NSArray) != nil
                {
                    self.couponListArray.removeAllObjects()
                    self.couponListArray.addObjects(from: (self.paymentResultDict.object(forKey: "counpon_list")as! NSArray) as! [Any])
                    print("couponListArray", self.couponListArray)
                    self.couponTableView.reloadData()
                }
                
                if ((self.paymentResultDict.object(forKey: "payment_methods") as? NSDictionary)?.value(forKey: "paypal") as? NSNumber)?.stringValue == "1"
                {
                    self.adminManagepaypalFlag = true
                    
                }else
                {
                    self.adminManagepaypalFlag = false
                    
                }
                
                if ((self.paymentResultDict.object(forKey: "payment_methods") as? NSDictionary)?.value(forKey: "stripe") as? NSNumber)?.stringValue == "1"
                {
                    self.adminManageStripeFlag = true
                }else
                {
                    self.adminManageStripeFlag = false
                    
                }
                
                if ((self.paymentResultDict.object(forKey: "payment_methods") as? NSDictionary)?.value(forKey: "cod") as? NSNumber)?.stringValue == "1"
                {
                    self.adminManageCODFlag = true
                }else
                {
                    self.adminManageCODFlag = false
                }
                
                self.getWalletData()
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
            }
        }, onFailure: {errorResponse in})
    }
    
    
    
    //MARK:- Back Btn Action
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- PAY Button Action
    @objc func payBtnTapped(sender:UIButton){
        if termsConditions == "not agree"{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseagreetheterms") as! String )
        }else if useWallet && fullAmtPayByWallet {
            self.wallet_COD()
        }else if useCouponOffer && selectedPaymetMethod == ""{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "choosepayment") as! String)
        }
        else if !useWallet && selectedPaymetMethod == ""{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "choosepayment") as! String)
        }
        else {
            // useCouponOffer = false
            if selectedPaymetMethod == "PAYMENT IN CASH" || selectedPaymetMethod == "PAGO EN EFECTIVO" // selectedPaymetMethod == "Cash On Delivery"
            {
                self.PaymentOnCOD()
            }
            else if selectedPaymetMethod == "PayPal"
            {
                if  userAllowedToPay
                {
                    self.cartGrayView.isHidden = true
                    self.payByPaypal()
                    login_session.setValue("0", forKey: "userCartCount")
                }
                else
                {
                    self.cartGrayView.isHidden = false
                }
            }
            else if selectedPaymetMethod == "STRIPE"  || selectedPaymetMethod == "Raya"
            {
                if userAllowedToPay
                {
                    self.cartGrayView.isHidden = true
                    
                    let tempCard = self.paymentTable.viewWithTag(111) as? UITextField
                    let tempExp = self.paymentTable.viewWithTag(222)as? UITextField
                    let tempCvv = self.paymentTable.viewWithTag(333)as? UITextField
                    if tempCard?.text == "" || tempCard?.text?.count == 0 {
                        self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "carddetails") as! String)
                    }else if tempExp?.text == "" || tempExp?.text?.count == 0 {
                        self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "cardexpired") as! String)
                    }else if tempCvv?.text == "" || tempCvv?.text?.count == 0 {
                        self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentercvv") as! String)
                    }else{
                        let commonDateStr = tempExp?.text
                        let dateArray = commonDateStr?.components(separatedBy: "-")
                        let expMonth = self.monthConverstion(month: dateArray![0])
                        let expYear = dateArray![1]
                        self.isValidCard(cardNumber: (tempCard?.text)!, ExpMonth: expMonth, ExpYear: expYear, cvv: (tempCvv?.text)!)
                        login_session.setValue("0", forKey: "userCartCount")
                        
                    }
                }else{
                    self.cartGrayView.isHidden = false
                    
                }
                
            }else{
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "choosepayment") as! String)
            }
        }
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == couponTableView
        {
            return 2
        }
        else
        {
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == couponTableView
        {
            return UITableView.automaticDimension
        }
        else
        {
            if indexPath.section == 0
            {
                if indexPath.row == 1
                {
                    // for use wallet (section = 0, row = 1)
                    if useWallet
                    {
                        if walletAvailableBalance >= exactToatlAmt
                            
                        {
                            return UITableView.automaticDimension
                            
                        }
                        else
                        {
                            if selectedPaymetMethod == paymentMethodsArray[indexPath.row]
                            {
                                return 150
                                
                            }
                            else
                            {
                                if adminManageStripeFlag == true
                                {
                                    return 50
                                }
                                else
                                {
                                    return 0
                                }
                            }
                        }
                    }
                    // for non-using wallet (section = 0, row = 1)
                    else
                    {
                        if selectedPaymetMethod == paymentMethodsArray[indexPath.row]
                        {
                            return 150
                            
                        }
                        else
                        {
                            if adminManageStripeFlag == true
                            {
                                return 50
                            }
                            else
                            {
                                return 0
                            }
                        }
                    }
                }
                else if indexPath.row == 0
                {
                    //use wallet (section = 0, row = 0)
                    if useWallet
                    {
                        if walletAvailableBalance >= exactToatlAmt
                        {
                            return 0
                            
                        }
                        else
                        {
                            
                            if selectedPaymetMethod == "PayPal"
                            {
                                if adminManagepaypalFlag == true
                                {
                                    return 50
                                }
                                else
                                {
                                    return 0
                                }
                            }
                            else
                            {
                                if adminManagepaypalFlag == true
                                {
                                    return 50
                                }
                                else
                                {
                                    return 0
                                }
                                
                            }
                        }
                    }
                    // for non-using wallet(section = 0, row = 0)
                    else
                    {
                        
                        if selectedPaymetMethod == "PayPal"
                        {
                            if adminManagepaypalFlag == true
                            {
                                return 50
                            }
                            else
                            {
                                return 0
                            }
                        }
                        else
                        {
                            if adminManagepaypalFlag == true
                            {
                                return 50
                            }
                            else
                            {
                                return 0
                            }
                            
                        }
                    }
                }
                else
                {
                    //for using wallet (section = 0, row = 2)
                    if useWallet
                    {
                        if walletAvailableBalance >= exactToatlAmt
                        {
                            return UITableView.automaticDimension
                            
                        }else
                        {
                            
                            if  selectedPaymetMethod == "PAYMENT IN CASH" || selectedPaymetMethod == "PAGO EN EFECTIVO" // selectedPaymetMethod == "Cash On Delivery"
                            {
                                if adminManageCODFlag == true
                                {
                                    
                                    return 50
                                }
                                else
                                {
                                    return 0
                                    
                                }
                            }
                            else
                            {
                                if adminManageCODFlag == true
                                {
                                    return 50
                                }
                                else
                                {
                                    return 0
                                }
                                
                            }
                        }
                    }
                    //for non using wallet (section = 0, row = 2)
                    else
                    {
                        
                        if selectedPaymetMethod == "PAYMENT IN CASH" || selectedPaymetMethod == "PAGO EN EFECTIVO" //selectedPaymetMethod == "Cash On Delivery"
                        {
                            if adminManageCODFlag == true
                            {
                                
                                return 50
                            }
                            else
                            {
                                return 0
                                
                            }
                        }
                        else
                        {
                            if adminManageCODFlag == true
                            {
                                return 50
                            }
                            else
                            {
                                return 0
                            }
                            
                        }
                    }
                }
                
            }
            else if indexPath.section == 2 // Terms & Conditions Cell
            {
                return UITableView.automaticDimension
            }
            else if indexPath.section == 3
            {
                if self.useCouponOffer == true
                {
                    if exactCouponAmt <= exactToatlAmt
                    {
                        //changes done here
                        return 60
                    }
                    else
                    {
                        return 60
                    }
                }
                else if useWallet && walletAvailableBalance > 0
                {
                    //Changes done here
                    return 60
                }
                else
                {
                    if couponListArray.count > 0
                    {
                        return 60
                    }
                    else
                    {
                        return 0
                    }
                }
            }
            else if indexPath.section == 1
            {
                if self.useCouponOffer == true
                {
                    if exactCouponAmt <= exactToatlAmt
                    {
                        if walletAvailableBalance > 0
                        {
                            //changes done here
                            return 60
                        }
                        else
                        {
                            return 0
                        }
                    }
                    else
                    {
                        return 60
                    }
                }
                else
                {
                    if walletAvailableBalance > 0
                    {
                        return 60
                    }
                    else
                    {
                        return 0
                    }
                }
                
            }
            else
            {
                return UITableView.automaticDimension
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == couponTableView
        {
            if section == 0
            {
                return 1
            }
            else
            {
                if couponListArray.count > 0
                {
                    return couponListArray.count
                }
                else
                {
                    return 0
                }
            }
        }
        else
        {
            if section == 0
            {
                return 3
            }
            else
            {
                return 1
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == couponTableView
        {
            if indexPath.section == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CouponClearDataCell") as? CouponClearDataCell
                cell?.selectionStyle = .none
                cell?.titleLbl.text = LanguageDictonary.value(forKey: "clearall") as? String
                return cell!
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell") as? CouponTableViewCell
                cell?.selectionStyle = .none
                cell?.applyCouponButton.layer.cornerRadius = 12.5
                cell?.applyCouponButton.layer.masksToBounds = true
                
                cell?.applyCouponButton.setTitle(LanguageDictonary.value(forKey: "apply") as? String, for: .normal)
                cell?.applyCouponButton.tag = indexPath.row
                cell?.applyCouponButton.addTarget(self,action:#selector(couponOfferAppliedBtnTapped(sender:)), for: .touchUpInside)
                
                cell?.CouponHeaderLbl.text = ((self.couponListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "coupon_name") as? String) ?? ""
                cell?.CouponTextLbl.text = ((self.couponListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "coupon_desc") as? String) ?? ""
                cell?.CouponPriceLbl.text = "Price : " + (((self.couponListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "currency") as? String)!) + " " + (((self.couponListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "coupon_price") as? String) ?? "")
                
                return cell!
            }
        }
        else
        {
            if indexPath.section == 0
            {
                if indexPath.row == 1 && selectedPaymetMethod == "STRIPE"
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StripePaymentCell") as? StripePaymentCell
                    cell?.selectionStyle = .none
                    
                    cell?.nameLbl.text =  LanguageDictonary.value(forKey: "stripe") as? String
                    cell?.creditCardNumberTxt.placeholder = LanguageDictonary.value(forKey: "creditcard") as? String
                    cell?.dateTxt.placeholder = LanguageDictonary.value(forKey: "mmyy") as? String
                    cell?.cvvTxt.placeholder = LanguageDictonary.value(forKey: "cvv") as? String
                    
                    
                    cell?.ExpDateBtn.addTarget(self, action: #selector(showMonthAndYear), for: .touchUpInside)
                    cell?.creditCardNumberTxt.keyboardType = .numberPad
                    cell?.cvvTxt.keyboardType = .numberPad
                    cell?.creditCardNumberTxt.tag = 111
                    cell?.dateTxt.tag = 222
                    cell?.cvvTxt.tag = 333
                    if paymentMethodsArray[indexPath.row] == selectedPaymetMethod
                    {
                        cell?.selectionImg.isHidden = false
                        cell?.selectionImg.image = UIImage.init(named: "select_radio")
                    }
                    else
                    {
                        cell?.selectionImg.isHidden = false
                        cell?.selectionImg.image = UIImage.init(named: "unSelectRadio")
                        
                    }
                    
                    return cell!
                }else if indexPath.row == 1 && selectedPaymetMethod == "Raya"
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StripePaymentCell") as? StripePaymentCell
                    cell?.selectionStyle = .none
                    
                    cell?.nameLbl.text =  LanguageDictonary.value(forKey: "stripe") as? String
                    cell?.creditCardNumberTxt.placeholder = LanguageDictonary.value(forKey: "creditcard") as? String
                    cell?.dateTxt.placeholder = LanguageDictonary.value(forKey: "mmyy") as? String
                    cell?.cvvTxt.placeholder = LanguageDictonary.value(forKey: "cvv") as? String
                    
                    
                    cell?.ExpDateBtn.addTarget(self, action: #selector(showMonthAndYear), for: .touchUpInside)
                    cell?.creditCardNumberTxt.keyboardType = .numberPad
                    cell?.cvvTxt.keyboardType = .numberPad
                    cell?.creditCardNumberTxt.tag = 111
                    cell?.dateTxt.tag = 222
                    cell?.cvvTxt.tag = 333
                    if paymentMethodsArray[indexPath.row] == selectedPaymetMethod
                    {
                        cell?.selectionImg.isHidden = false
                        cell?.selectionImg.image = UIImage.init(named: "select_radio")
                    }
                    else
                    {
                        cell?.selectionImg.isHidden = false
                        cell?.selectionImg.image = UIImage.init(named: "unSelectRadio")
                        
                    }
                    
                    return cell!
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as? PaymentMethodCell
                    cell?.selectionStyle = .none
                    
                    if paymentMethodsArray[indexPath.row] == selectedPaymetMethod
                    {
                        cell?.selectionImg.isHidden = false
                        cell?.selectionImg.image = UIImage.init(named: "select_radio")
                    }
                    else
                    {
                        cell?.selectionImg.isHidden = false
                        cell?.selectionImg.image = UIImage.init(named: "unSelectRadio")
                        
                    }
                    cell?.nameLbl.text = paymentMethodsArray[indexPath.row]
                    return cell!
                }
            }else if(indexPath.section == 2){
                let cell = tableView.dequeueReusableCell(withIdentifier: "paymentTermsConditionsCell") as? paymentTermsConditionsCell
                cell?.nameLbl.text = LanguageDictonary.value(forKey: "byclickingtermsconditions") as? String
                
                
                if termsConditions == "agree"{
                    cell?.selectionImg.image = UIImage(named: "selectedCheckBox")
                }else{
                    cell?.selectionImg.image = UIImage(named: "checkBox")
                }
                cell?.selectionStyle = .none
                return cell!
            }
            else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentWalletCell") as? PaymentWalletCell
                cell?.selectionStyle = .none
                cell?.baseView.layer.cornerRadius = 5.0
                cell?.baseView.clipsToBounds = true
                cell?.baseView.backgroundColor = AppTranspertantOrange
                if useWallet{
                    cell?.selectionImg.image = UIImage(named: "big_select_check")
                }else{
                    cell?.selectionImg.image = UIImage(named: "big_check")
                }
                cell?.walletAmtLbl.text = String(format: "\(LanguageDictonary.value(forKey: "usewallet") as! String) %@ %.2f", walletCurrency,walletAvailableBalance)
                
                return cell!
            }
            else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyCouponCell") as? ApplyCouponCell
                cell?.selectionStyle = .none
                cell?.applyCouponButton.tag = indexPath.row
                cell?.applyCouponLbl.text = LanguageDictonary.value(forKey: "applyoffer") as? String
                cell?.applyCouponButton.addTarget(self,action:#selector(applyCouponSectionClicked(sender:)), for: .touchUpInside)
                return cell!
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartTotalWithCouponWalletCell") as? CartTotalWithCouponWalletCell
                cell?.selectionStyle = .none
                
                cell?.couponLbl.text = LanguageDictonary.value(forKey: "offerused") as? String
                cell?.walletLbl.text = LanguageDictonary.value(forKey: "walletused") as? String
                cell?.subTotalLbl.text = LanguageDictonary.value(forKey: "subtotal") as? String
                cell?.taxLbl.text = LanguageDictonary.value(forKey: "tax") as? String
                cell?.deliveryLbl.text = LanguageDictonary.value(forKey: "deliveryfee") as? String
                cell?.totalLbl.text = LanguageDictonary.value(forKey: "total") as? String
                cell?.managementFeeLbl.text = Localization.value(for: "managementFee")
                cell?.checkOutBtn.setTitle(LanguageDictonary.value(forKey: "pay") as? String, for: .normal)
                
                let deliveryFee = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
                let totalAmount = Singleton.sharedInstance.MyCartModel.data.totalCartAmount ?? "0.00"
                // let currency = Singleton.sharedInstance.MyCartModel.data.currencyCode as String
                let grandTax = Singleton.sharedInstance.MyCartModel.data.cartTaxTotal as String
                let currency = Singleton.sharedInstance.MyCartModel.data.currencyCode as String
                let totalPayAmount = self.finalPayable_amount.isEmpty ? totalAmount : self.finalPayable_amount
                if let managementFee = Singleton.sharedInstance.MyCartModel.data.managementFee {
                    cell?.managementFeeAmtLbl.text = String(format: "%@ %@", walletCurrency, managementFee)
                }
                cell?.taxValueLbl.text = currency + grandTax
                cell?.subTotalAmtLbl.text = payingSubTotal
                cell?.walletAmtLbl.text = String(format: "- %@ %@",walletCurrency, self.finalWallet_Amount)
                cell?.couponAmtLbl.text = String(format: "- %@ %@",walletCurrency, self.finalCoupon_Amount)
                cell?.totalValueLbl.text = String (format: "%@ %@", walletCurrency, totalPayAmount)
                cell?.deliveryAmtlbl.text = walletCurrency + " " + deliveryFee
                cell?.walletLbl.superview?.isHidden = !useWallet
                cell?.couponLbl.superview?.isHidden = !useCouponOffer
                cell?.taxValueLbl.superview?.isHidden = grandTax == "0.00" || grandTax.isEmpty
                cell?.deliveryAmtlbl.superview?.isHidden = deliveryFee == "0.00" || deliveryFee.isEmpty
                if pickUpType == "self"
                {
                    cell?.deliveryAmtlbl.text = "0.00"
                    
                }
                
                cell?.peakHoursFeeBtn.isHidden = peakHourFeeStatus == "0"
                if self.finalMessage == "No need to pay"
                {
                    cell?.checkOutBtn.setTitle(LanguageDictonary.value(forKey: "pay") as? String, for: .normal)
                }
                else
                {
                    let btnTitleStr = String(format: "\(LanguageDictonary.value(forKey: "pay") as! String) %@ %@", walletCurrency, totalPayAmount)
                    cell?.checkOutBtn.setTitle(btnTitleStr, for: .normal)
                }
                
                cell?.checkOutBtn.addTarget(self, action: #selector(payBtnTapped), for: .touchUpInside)
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == couponTableView
        {
            if indexPath.section == 0
            {
                self.useCouponOffer = false
                self.couponUsedStatusForAPI = "0"
                self.couponAmountforAPI = "0"
                self.couponIDforAPI = ""
                self.useOfferAmount()
                self.couponGrayView.isHidden = true
            }
            
            print("selectedCouponPrice Index", indexPath.row)
        }
        else
        {
            
            if indexPath.section == 0 {
                if !fullAmtPayByWallet{
                    selectedPaymetMethod = paymentMethodsArray[indexPath.row]
                }
            }else if indexPath.section == 1{
                if termsConditions == "agree"
                {
                    if useWallet
                    {
                        self.walletUsedStatusForAPI = "0"
                        self.walletAmountforAPI = ""
                        useWallet = false
                        fullAmtPayByWallet = false
                        self.useWalletAmount()
                    }
                    else
                    {
                        self.walletUsedStatusForAPI = "1"
                        useWallet = true
                        self.useWalletAmount()
                    }
                }else{
                    self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseagreetheterms") as! String)
                }
                
            }else if indexPath.section == 2{
                if termsConditions == "agree"{
                    termsConditions = "not agree"
                }else{
                    termsConditions = "agree"
                }
            }
            paymentTable.reloadData()
        }
    }
    
    @objc func applyCouponSectionClicked(sender:UIButton)
    {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        
        if termsConditions == "agree"
        {
            
            //            if self.finalMessage == "No need to pay"
            //            {
            //                self.couponGrayView.isHidden = true
            //                self.showToastAlert(senderVC: self, messageStr: "There is no balance amount for apply coupon offers !")
            //            }
            //            else
            //            {
            self.couponGrayView.isHidden = false
            //}
            
            //            if useWallet
            //            {
            //                if remainingAmountCalc == 0.00
            //                {
            //                self.couponGrayView.isHidden = true
            //                self.showToastAlert(senderVC: self, messageStr: "There is no balance amount for apply coupon offers !")
            //                }
            //                else
            //                {
            //                 self.couponGrayView.isHidden = false
            //                }
            //            }
            //            else
            //            {
            //                self.couponGrayView.isHidden = false
            //            }
            
        }
        else
        {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseagreetheterms") as! String)
        }
        
    }
    
    @objc func couponOfferAppliedBtnTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        
        print("selectedCouponPrice Index", buttonRow)
        
        self.selectedCouponPrice = ((self.couponListArray.object(at: buttonRow) as! NSDictionary).value(forKey: "coupon_price") as? String)!
        print(self.selectedCouponPrice)
        self.selectedCouponID = (((self.couponListArray.object(at: buttonRow) as! NSDictionary).value(forKey: "coupon_id") as? NSNumber)!.stringValue)
        
        self.useCouponOffer = true
        self.couponUsedStatusForAPI = "1"
        self.couponAmountforAPI = self.selectedCouponPrice
        self.couponIDforAPI = self.selectedCouponID
        self.couponGrayView.isHidden = true
        self.useOfferAmount()
        
        let floatCouponAmnt = selectedCouponPrice.replacingOccurrences(of: ",", with: "")
        exactCouponAmt = Float(floatCouponAmnt)!
        print("exactCouponAmt",exactCouponAmt)
        //
        //        if useWallet
        //        {
        //            if exactCouponAmt <= remainingAmountCalc
        //            {
        //                self.couponGrayView.isHidden = true
        //                self.useCouponOffer = true
        //            }
        //            else
        //            {
        //                self.showToastAlert(senderVC: self, messageStr: "\("Sorry! This offer is available for purchasing over")\(" ")\(self.walletCurrency)\(exactCouponAmt)")
        //                self.couponGrayView.isHidden = false
        //                self.useCouponOffer = false
        //            }
        //        }
        //        else
        //        {
        //        if exactCouponAmt <= exactToatlAmt
        //        {
        //        self.couponGrayView.isHidden = true
        //        self.useCouponOffer = true
        //        }
        //        else
        //        {
        //            self.showToastAlert(senderVC: self, messageStr: "\("Sorry! This offer is available for purchasing over")\(" ")\(self.walletCurrency)\(exactCouponAmt)")
        //            self.couponGrayView.isHidden = false
        //            self.useCouponOffer = false
        //        }
        //        }
        //        self.paymentTable.reloadData()
    }
    
    @IBAction func couponPopupCloseBtnAction(_ sender: Any)
    {
        self.couponGrayView.isHidden = true
    }
    
    @objc func showMonthAndYear(){
        let vc = SambagMonthYearPickerViewController()
        vc.theme = .light
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    //MARK:- PAYMENT TYPES
    func PaymentOnCOD()
    {
        self.showLoadingIndicator(senderVC: self)
        var self_pickupStr = String()
        var firstName = String()
        var lastName = String()
        var emailStr = String()
        var mobileNumber = String()
        var mobileNo2 = String()
        var address = String()
        var landmark = String()
        var latStr = String()
        var longStr = String()
        var walletStr = String()
        var walletAmtStr = String()
        if pickUpType == "self"{
            self_pickupStr = "1"
            firstName = ""
            lastName = ""
            emailStr = ""
            mobileNumber = ""
            mobileNo2 = ""
            address = ""
            latStr = ""
            longStr = ""
            landmark = ""
        }else{
            self_pickupStr = "0"
            firstName = addressDict.object(forKey: "sh_cus_fname") as? String ?? ""
            lastName = addressDict.object(forKey: "sh_cus_lname") as? String ?? ""
            emailStr = addressDict.object(forKey: "sh_cus_email") as? String ?? ""
            mobileNumber = addressDict.object(forKey: "sh_phone1") as? String ?? ""
            mobileNo2 = addressDict.object(forKey: "sh_phone2") as? String ?? ""
            address = addressDict.object(forKey: "sh_location") as? String ?? ""
            landmark = addressDict.object(forKey: "sh_location1") as? String ?? ""
            latStr = addressDict.object(forKey: "sh_latitude") as? String ?? ""
            longStr = addressDict.object(forKey: "sh_longitude") as? String ?? ""
        }
        if useWallet{
            walletStr = "1"
            walletAmtStr = self.finalWallet_Amount
            
            //            if exactToatlAmt < walletAvailableBalance{
            //                walletAmtStr = String(format: "%.2f", exactToatlAmt)
            //            }else{
            //                walletAmtStr = String(format: "%.2f", walletAvailableBalance)
            //            }
        }else{
            walletStr = "0"
            walletAmtStr = ""
        }
        
        if useCouponOffer == true
        {
            self.couponisUsed = "1"
        }
        else
        {
            self.couponisUsed = "0"
            self.selectedCouponID = ""
            self.selectedCouponPrice = ""
        }
        
        let Parse = CommomParsing()
        
        Parse.cod_paymet(lang: login_session.value(forKey: "Language") as? String ?? "es",ord_self_pickup: self_pickupStr,cus_name: firstName,cus_last_name: lastName,cus_email: emailStr,cus_phone1: mobileNumber,cus_phone2: mobileNo2,cus_address: address,cus_address1:landmark,cus_lat: latStr,cus_long: longStr,use_wallet: walletStr,wallet_amt: walletAmtStr,use_coupon: self.couponisUsed, coupon_id: selectedCouponID, coupon_amount: selectedCouponPrice, onSuccess:
                            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                login_session.setValue("0", forKey: "userCartCount")
                self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                isfromPaymentSucessPage = true
                if self.useCouponOffer == true
                {
                    self.useCouponOffer = false
                }
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message") as? String ?? "Error")
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    func wallet_COD()
    {
        self.showLoadingIndicator(senderVC: self)
        var self_pickupStr = String()
        var firstName = String()
        var lastName = String()
        var emailStr = String()
        var mobileNumber = String()
        var mobileNo2 = String()
        var address = String()
        var landmark = String()
        var latStr = String()
        var longStr = String()
        var walletStr = String()
        var walletAmtStr = String()
        if pickUpType == "self"{
            self_pickupStr = "1"
            firstName = ""
            lastName = ""
            emailStr = ""
            mobileNumber = ""
            mobileNo2 = ""
            address = ""
            latStr = ""
            longStr = ""
            landmark = ""
            
        }else{
            self_pickupStr = "0"
            firstName = addressDict.object(forKey: "sh_cus_fname") as! String
            lastName = addressDict.object(forKey: "sh_cus_lname") as! String
            emailStr = addressDict.object(forKey: "sh_cus_email") as! String
            mobileNumber = addressDict.object(forKey: "sh_phone1") as! String
            mobileNo2 = addressDict.object(forKey: "sh_phone2") as! String
            address = addressDict.object(forKey: "sh_location") as! String
            landmark = addressDict.object(forKey: "sh_location1") as! String
            latStr = addressDict.object(forKey: "sh_latitude") as! String
            longStr = addressDict.object(forKey: "sh_longitude") as! String
            
        }
        if useWallet{
            walletStr = "1"
            walletAmtStr = self.finalWallet_Amount
            
            //            if exactToatlAmt < walletAvailableBalance
            //            {
            //                walletAmtStr = String(format: "%.2f", exactToatlAmt)
            //            }
            //            else if exactToatlAmt == walletAvailableBalance
            //            {
            //                walletAmtStr = String(format: "%.2f", exactToatlAmt)
            //            }
            //            else
            //            {
            //                walletAmtStr = String(format: "%.2f", walletAvailableBalance)
            //            }
        }else{
            walletStr = "0"
            walletAmtStr = ""
        }
        
        if useCouponOffer == true
        {
            self.couponisUsed = "1"
        }
        else
        {
            self.couponisUsed = "0"
            self.selectedCouponID = ""
            self.selectedCouponPrice = ""
        }
        
        let Parse = CommomParsing()
        Parse.wallet_payment(lang: login_session.value(forKey: "Language") as? String ?? "es",ord_self_pickup: self_pickupStr,cus_name: firstName,cus_last_name: lastName,cus_email: emailStr,cus_phone1: mobileNumber,cus_phone2: mobileNo2,cus_address: address,cus_address1: landmark,cus_lat: latStr,cus_long: longStr,use_wallet: walletStr,wallet_amt: walletAmtStr,use_coupon: self.couponisUsed, coupon_id: selectedCouponID, coupon_amount: selectedCouponPrice, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                isfromPaymentSucessPage = true
                login_session.setValue("0", forKey: "userCartCount")
                if self.useCouponOffer == true
                {
                    self.useCouponOffer = false
                }
                
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    //MARK:- PayPal Payment methods
    func payByPaypal()
    {
        self.payPalOldConfigure()
        let totalArray = payingPayPalTotalAmt.components(separatedBy: " ")
        var totalStr = totalArray[1]
        totalStr = totalStr.replacingOccurrences(of: ",", with: "")
        let amount = NSDecimalNumber(string: "\(totalStr)")
        let paymentDetails = PayPalPaymentDetails(subtotal: amount, withShipping: 0.00, withTax: 0.00)
        let payment = PayPalPayment(amount: amount, currencyCode: "USD", shortDescription: Appname, intent: .sale)
        
        payment.paymentDetails = paymentDetails
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        
    }
    
    // MARK: Paypal Old Configure
    func payPalOldConfigure() {
        //successView.isHidden = true
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "ShopUrFood_Customer"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        // Setting the payPalShippingAddressOption property is optional.
        // See PayPalConfiguration.h for details.
        //payPalConfig.payPalShippingAddressOption = .none;
        //print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    
    // MARK:  PayPalPaymentDelegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            //print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            let paymentDict = completedPayment.confirmation as NSDictionary
            let responseDict = NSMutableDictionary()
            responseDict.addEntries(from: paymentDict.object(forKey: "response") as! [AnyHashable : Any])
            //            let transaction_Id = responseDict.object(forKey: "id")as! String
            //            print(paymentDict.value(forKeyPath: "response.id") as Any)
            var transaction_id = String()
            let timestamp = Date().currentTimeMillis()
            transaction_id = String("PAY-\(timestamp ?? 0)")
            self.paypalTransactionIdSendToAPI(trans_id: transaction_id)
        })
    }
    
    
    // MARK:  PayPal transaction Id send to API
    func paypalTransactionIdSendToAPI(trans_id:String){
        
        self.showLoadingIndicator(senderVC: self)
        var self_pickupStr = String()
        var firstName = String()
        var lastName = String()
        var emailStr = String()
        var mobileNumber = String()
        var mobileNo2 = String()
        var address = String()
        var landmark = String()
        var latStr = String()
        var longStr = String()
        var walletStr = String()
        var walletAmtStr = String()
        if pickUpType == "self"{
            self_pickupStr = "1"
            firstName = ""
            lastName = ""
            emailStr = ""
            mobileNumber = ""
            mobileNo2 = ""
            address = ""
            latStr = ""
            longStr = ""
            landmark = ""
        }else{
            self_pickupStr = "0"
            firstName = addressDict.object(forKey: "sh_cus_fname") as! String
            lastName = addressDict.object(forKey: "sh_cus_lname") as! String
            emailStr = addressDict.object(forKey: "sh_cus_email") as! String
            mobileNumber = addressDict.object(forKey: "sh_phone1") as! String
            mobileNo2 = addressDict.object(forKey: "sh_phone2") as! String
            address = addressDict.object(forKey: "sh_location") as! String
            landmark = addressDict.object(forKey: "sh_location1") as! String
            latStr = addressDict.object(forKey: "sh_latitude") as! String
            longStr = addressDict.object(forKey: "sh_longitude") as! String
            
        }
        if useWallet{
            walletStr = "1"
            walletAmtStr = self.finalWallet_Amount
            
            //            if exactToatlAmt < walletAvailableBalance{
            //                walletAmtStr = String(format: "%.2f", exactToatlAmt)
            //            }else{
            //                walletAmtStr = String(format: "%.2f", walletAvailableBalance)
            //            }
        }else{
            walletStr = "0"
            walletAmtStr = ""
        }
        
        if useCouponOffer == true
        {
            self.couponisUsed = "1"
        }
        else
        {
            self.couponisUsed = "0"
            self.selectedCouponID = ""
            self.selectedCouponPrice = ""
        }
        
        let Parse = CommomParsing()
        Parse.PayPal_payment(lang: login_session.value(forKey: "Language") as? String ?? "es",ord_self_pickup: self_pickupStr,cus_name: firstName,cus_last_name: lastName,cus_email: emailStr,cus_phone1: mobileNumber,cus_phone2: mobileNo2,cus_address: address,cus_address1: landmark,cus_lat: latStr,cus_long: longStr,use_wallet: walletStr,wallet_amt: walletAmtStr,transaction_id: trans_id,use_coupon: self.couponisUsed, coupon_id: selectedCouponID, coupon_amount: selectedCouponPrice, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                isfromPaymentSucessPage = true
                if self.useCouponOffer == true
                {
                    self.useCouponOffer = false
                }
                
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }
    
    
    // MARK: isValidCard
    func isValidCard(cardNumber:String,ExpMonth:String,ExpYear:String,cvv:String) {
        let isvalid = CCValidator.validate(creditCardNumber: cardNumber)
        let month = ExpMonth
        let year = ExpYear
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let currentyear =  components.year
        let currentmonth = components.month
        if isvalid == false  {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "carddetails") as! String)
        } else if (cvv.count) < 3 || (cvv.count) > 4 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "pleaseentercvv") as! String)
        } else if year < String(currentyear!) {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "usevalidcarddetails") as! String)
        } else if year == String(currentyear!)
        {
            if Int(month)! < Int(currentmonth!)
            {
                self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "usevalidcarddetails") as! String)
            }
            else
            {
                self.payByStripe(card_no: cardNumber, ccExpiryMonth: ExpMonth, ccExpiryYear: ExpYear, cvvNumber: cvv)
            }
        }
        else {
            self.payByStripe(card_no: cardNumber, ccExpiryMonth: ExpMonth, ccExpiryYear: ExpYear, cvvNumber: cvv)
        }
    }
    
    func payByStripe(card_no:String,ccExpiryMonth:String,ccExpiryYear:String,cvvNumber:String)
    {
        self.showLoadingIndicator(senderVC: self)
        var self_pickupStr = String()
        var firstName = String()
        var lastName = String()
        var emailStr = String()
        var mobileNumber = String()
        var mobileNo2 = String()
        var address = String()
        var landmark = String()
        var latStr = String()
        var longStr = String()
        var walletStr = String()
        var walletAmtStr = String()
        if pickUpType == "self"{
            self_pickupStr = "1"
            firstName = ""
            lastName = ""
            emailStr = ""
            mobileNumber = ""
            mobileNo2 = ""
            address = ""
            latStr = ""
            longStr = ""
            landmark = ""
        }else{
            self_pickupStr = "0"
            firstName = addressDict.object(forKey: "sh_cus_fname") as! String
            lastName = addressDict.object(forKey: "sh_cus_lname") as! String
            emailStr = addressDict.object(forKey: "sh_cus_email") as! String
            mobileNumber = addressDict.object(forKey: "sh_phone1") as! String
            mobileNo2 = addressDict.object(forKey: "sh_phone2") as! String
            address = addressDict.object(forKey: "sh_location") as! String
            landmark = addressDict.object(forKey: "sh_location1") as! String
            latStr = addressDict.object(forKey: "sh_latitude") as! String
            longStr = addressDict.object(forKey: "sh_longitude") as! String
            
        }
        if useWallet{
            walletStr = "1"
            walletAmtStr = self.finalWallet_Amount
            
            //            if exactToatlAmt < walletAvailableBalance{
            //                walletAmtStr = String(format: "%.2f", exactToatlAmt)
            //            }else{
            //                walletAmtStr = String(format: "%.2f", walletAvailableBalance)
            //            }
        }else{
            walletStr = "0"
            walletAmtStr = ""
        }
        
        if useCouponOffer == true
        {
            self.couponisUsed = "1"
        }
        else
        {
            self.couponisUsed = "0"
            self.selectedCouponID = ""
            self.selectedCouponPrice = ""
        }
        let Parse = CommomParsing()
        Parse.payByStripe(lang: login_session.value(forKey: "Language") as? String ?? "es",ord_self_pickup: self_pickupStr,cus_name: firstName,cus_last_name: lastName,cus_email: emailStr,cus_phone1: mobileNumber,cus_phone2: mobileNo2,cus_address: address,cus_address1: landmark,cus_lat: latStr,cus_long: longStr,use_wallet: walletStr,wallet_amt: walletAmtStr, card_no: card_no,ccExpiryMonth: ccExpiryMonth,ccExpiryYear: ccExpiryYear,cvvNumber: cvvNumber,use_coupon: self.couponisUsed, coupon_id: selectedCouponID, coupon_amount: selectedCouponPrice,onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                isfromPaymentSucessPage = true
                if self.useCouponOffer == true
                {
                    self.useCouponOffer = false
                }
                
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }
    
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Ok") {
            newOneOrderUpdated = "true"
            login_session.setValue("0", forKey: "userCartCount")
            login_session.synchronize()
            actAsBaseTabbar.tabBar.items?[0].badgeValue = nil
            actAsBaseTabbar.selectedIndex = 3
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom(LanguageDictonary.object(forKey: "success") as! String, subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    
    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        print(result)
        if let theLabel = self.paymentTable.viewWithTag(222) as? UITextField {
            theLabel.text =  "\(result)"
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func monthConverstion(month:String) -> String {
        var convertedMonth = String()
        switch month {
        case "JAN":
            convertedMonth = "1"
        case "FEB":
            convertedMonth = "2"
        case "MAR":
            convertedMonth = "3"
        case "APR":
            convertedMonth = "4"
        case "MAY":
            convertedMonth = "5"
        case "JUN":
            convertedMonth = "6"
        case "JUL":
            convertedMonth = "7"
        case "AUG":
            convertedMonth = "8"
        case "SEP":
            convertedMonth = "9"
        case "OCT":
            convertedMonth = "10"
        case "NOV":
            convertedMonth = "11"
        case "DEC":
            convertedMonth = "12"
        default:
            print("no match")
        }
        return convertedMonth
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 16
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
extension Date {
    func currentTimeMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
