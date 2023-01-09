//
//  FoodDetailsPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SCLAlertView
import SWRevealViewController


@available(iOS 11.0, *)
class FoodDetailsPage: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    
    let appColor:UIColor = UIColor(red: 254/255, green: 106/255, blue: 15/255, alpha: 1.0)

    @IBOutlet weak var baseViewBottom: NSLayoutConstraint!
    //@IBOutlet weak var relatedTitleLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var itemsCountLbl: UILabel!
    
    @IBOutlet weak var relatedFoodCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var actAsFoodImg: UIImageView!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var AddCartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var baseScrollBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var slideshow: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var baseScroll: UIScrollView!
    @IBOutlet weak var topsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topinsLblHeight: NSLayoutConstraint!
    @IBOutlet weak var topinsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var extraDescLbl: UILabel!
    @IBOutlet weak var extraTitleLbl: UILabel!
    @IBOutlet weak var itemDescriptionLbl: UILabel!
    @IBOutlet weak var itemTitleLbl: UILabel!
   
    @IBOutlet weak var comboOffersImgView: UIImageView!
    @IBOutlet weak var halalCertifiedImgView: UIImageView!

    
    @IBOutlet weak var FoodImageTop: NSLayoutConstraint!
    
    @IBOutlet weak var baseViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var lastBtnY: NSLayoutConstraint!
    @IBOutlet weak var lastBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var strikeOutPriceLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    
    @IBOutlet weak var discountPriceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var toppingsTitleLbl: UILabel!
    @IBOutlet weak var toppingsTable: UITableView!
    
    @IBOutlet weak var specialInstructionTitleLbl: UILabel!
    
    @IBOutlet weak var offerWidth: NSLayoutConstraint!
    @IBOutlet weak var selectedQuantityLbl: UILabel!
    @IBOutlet weak var notesText: UITextField!
    
    @IBOutlet weak var newCartBtn: UIButton!
    @IBOutlet weak var newCartView: UIView!
    @IBOutlet weak var relatedItemsTitleLbl: UILabel!
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    @IBOutlet weak var basecrollTopHeightConstraints: NSLayoutConstraint!

    //Offer till view
    @IBOutlet weak var offerTillBGView: UIView!
    @IBOutlet weak var offerTillBGHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var offerTillView1: UIView!
    @IBOutlet weak var offerTillView2: UIView!
    @IBOutlet weak var offerTillView3: UIView!
    @IBOutlet weak var offerTillView4: UIView!

    @IBOutlet weak var offerTillCountDownLabel1: UILabel!
    @IBOutlet weak var offerTillCountDownLabel2: UILabel!
    @IBOutlet weak var offerTillCountDownLabel3: UILabel!
    @IBOutlet weak var offerTillCountDownLabel4: UILabel!

    @IBOutlet weak var offerTillLbl: UILabel!
    
    @IBOutlet weak var offerdaysLbl: UILabel!
    
    @IBOutlet weak var offersSecLbl: UILabel!
    @IBOutlet weak var offerminLbl: UILabel!
    @IBOutlet weak var offerHoursLbl: UILabel!
    
    @IBOutlet weak var viewcartLbl: UILabel!
    
    
    var releaseDate: NSDate?
    var countdownTimer = Timer()
    var releaseDateString = String()
    
    var selectedChoiceIdArray  = NSMutableArray()
    var oldChoiceIdArray  = NSMutableArray()
    var resultDict = NSMutableDictionary()
    var resultDict1 = NSMutableDictionary()

    var actualQuantity = Int()
    var finalPrice = Float()
    var toppingsPrice = Float()
    var item_id = String()
    var itemName = String()
    var restaurant_id = String()
    var window: UIWindow?
    var rest_id = String()
    var store_id = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCartBtn.layer.cornerRadius = 22.5
        newCartBtn.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        offerTillView1.layer.cornerRadius = 5.0
        offerTillView1.layer.borderWidth = 2.5
        offerTillView1.layer.borderColor = appColor.cgColor
        
        offerTillView2.layer.cornerRadius = 5.0
        offerTillView2.layer.borderWidth = 2.5
        offerTillView2.layer.borderColor = appColor.cgColor

        offerTillView3.layer.cornerRadius = 5.0
        offerTillView3.layer.borderWidth = 2.5
        offerTillView3.layer.borderColor = appColor.cgColor

        offerTillView4.layer.cornerRadius = 5.0
        offerTillView4.layer.borderWidth = 2.5
        offerTillView4.layer.borderColor = appColor.cgColor
        
        self.notesText.placeholder = LanguageDictonary.value(forKey: "addextras") as? String
        self.newCartBtn.setTitle(LanguageDictonary.value(forKey: "addtocart") as? String, for: .normal)
        self.offerTillLbl.text = LanguageDictonary.value(forKey: "offertill") as? String
        self.offerdaysLbl.text = LanguageDictonary.value(forKey: "days") as? String
        self.offerminLbl.text = LanguageDictonary.value(forKey: "min") as? String
        self.offerHoursLbl.text = LanguageDictonary.value(forKey: "hrs") as? String
        self.offersSecLbl.text = LanguageDictonary.value(forKey: "sec") as? String
        self.specialInstructionTitleLbl.text =  LanguageDictonary.value(forKey: "specialinstruction") as? String
        self.relatedItemsTitleLbl.text = LanguageDictonary.value(forKey: "relatedfood") as? String
        self.viewcartLbl.text = LanguageDictonary.value(forKey: "viewcart") as? String
        self.toppingsTitleLbl.text = LanguageDictonary.value(forKey: "toppings") as? String
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.loadingInitData()
        self.getCartData()

    }
    
    func loadingInitData(){
        navigationTitleLbl.text = itemName
        actualQuantity = 1
        toppingsPrice = 0
        baseScroll.isHidden = true
        self.getData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        countdownTimer.invalidate()
    }
    
    
    func getCartData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getMyCartData(lang: login_session.value(forKey: "Language") as? String ?? "es", onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200
            {
                print (response)
                let mod = MyCartModel(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.MyCartModel = mod
                
                self.resultDict1.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                
                self.store_id = ((((self.resultDict1.object(forKey: "cart_details") as? NSArray)?.object(at: 0) as! NSDictionary).value(forKey: "store_id")) as! NSNumber).stringValue
                
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
               
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    @IBAction func newCartBtnAction(_ sender: Any) {
        
        if self.store_id == ""
        {
            self.showLoadingIndicator(senderVC: self)
            var sendChoiceIds = [Int]()
            if selectedChoiceIdArray.count != 0{
                for choiceId in selectedChoiceIdArray{
                    sendChoiceIds.append(choiceId as! Int)
                }
            }
            
            let Parse = CommomParsing()
            Parse.itemAddToCart(lang: login_session.value(forKey: "Language") as? String ?? "es",item_id: item_id,st_id: restaurant_id,quantity: String(actualQuantity),choices_id: sendChoiceIds,special_notes: notesText.text!, force_update: "", onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    //self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                    let cartCount = ((response.object(forKey: "data")as! NSDictionary).object(forKey: "total_cart_count")as! NSNumber).stringValue
                    login_session.setValue(cartCount, forKey: "userCartCount")
                    login_session.synchronize()
                    self.newCartView.isHidden = true
                    self.AddCartViewHeight.constant = 50
                    self.baseScrollBottomSpace.constant = 50
                    self.getData()
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message") as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
        else
        {
        if self.store_id != restaurant_id
        {
            let refreshAlert = UIAlertController(title: Appname, message: LanguageDictonary.object(forKey: "yourcartstartfresh") as! String, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: LanguageDictonary.object(forKey: "yesfreash") as! String, style: .default, handler: { (action: UIAlertAction!) in
                self.showLoadingIndicator(senderVC: self)
                var sendChoiceIds = [Int]()
                if self.selectedChoiceIdArray.count != 0{
                    for choiceId in self.selectedChoiceIdArray{
                        sendChoiceIds.append(choiceId as! Int)
                    }
                }
                
                let Parse = CommomParsing()
                Parse.itemAddToCart(lang: login_session.value(forKey: "Language") as? String ?? "es",item_id: self.item_id,st_id: self.restaurant_id,quantity: String(self.actualQuantity),choices_id: sendChoiceIds,special_notes: self.notesText.text!, force_update: "", onSuccess: {
                    response in
                    print (response)
                    if response.object(forKey: "code") as! Int == 200{
                        //self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                        let cartCount = ((response.object(forKey: "data")as! NSDictionary).object(forKey: "total_cart_count")as! NSNumber).stringValue
                        login_session.setValue(cartCount, forKey: "userCartCount")
                        login_session.synchronize()
                        self.newCartView.isHidden = true
                        self.AddCartViewHeight.constant = 50
                        self.baseScrollBottomSpace.constant = 50
                        self.getData()
                        UIView.animate(withDuration: 0.5) {
                            self.view.layoutIfNeeded()
                        }
                    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.showFailurePopUp(msgStr: response.object(forKey: "message") as! String)
                    }
                    self.stopLoadingIndicator(senderVC: self)
                }, onFailure: {errorResponse in})            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        else
        {
            self.showLoadingIndicator(senderVC: self)
            var sendChoiceIds = [Int]()
            if selectedChoiceIdArray.count != 0{
                for choiceId in selectedChoiceIdArray{
                    sendChoiceIds.append(choiceId as! Int)
                }
            }
        
            let Parse = CommomParsing()
        Parse.itemAddToCart(lang: login_session.value(forKey: "Language") as? String ?? "es",item_id: item_id,st_id: restaurant_id,quantity: String(actualQuantity),choices_id: sendChoiceIds,special_notes: notesText.text!, force_update: "", onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    //self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                    let cartCount = ((response.object(forKey: "data")as! NSDictionary).object(forKey: "total_cart_count")as! NSNumber).stringValue
                    login_session.setValue(cartCount, forKey: "userCartCount")
                    login_session.synchronize()
                    self.newCartView.isHidden = true
                    self.AddCartViewHeight.constant = 50
                    self.baseScrollBottomSpace.constant = 50
                    self.getData()
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.showFailurePopUp(msgStr: response.object(forKey: "message") as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
        }
    }
    
    
    @IBAction func topInfoBtnAction(_ sender: Any) {
        if (resultDict.object(forKey: "item_reviews")as! NSArray).count == 0 {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "noreviewsfound") as! String)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllReviewViewController") as! AllReviewViewController
            let tempArray = resultDict.object(forKey: "item_reviews")as! NSArray
            nextViewController.reviewArray = tempArray.mutableCopy()as! NSMutableArray
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    func getData(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getItemDetails(lang: login_session.value(forKey: "Language") as? String ?? "es",item_id: item_id,review_page_no: "1" , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let mod = itemDetailModel(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.ItemDetailModel = mod
                self.resultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])

                if ((self.resultDict.object(forKey: "itemt_info") as? NSDictionary)?.value(forKey: "discount_remaining_time") as! Int) != 0
                {
                    self.offerTillBGView.isHidden = false
                  self.offerTillBGHeightConstraints.constant = 88
                    self.basecrollTopHeightConstraints.constant = 86
                    self.releaseDateString = ((self.resultDict.object(forKey: "itemt_info") as? NSDictionary)?.value(forKey: "discount_available_to") as! String)
                    self.startOfferTimer()
                }
                else
                {
                 self.offerTillBGView.isHidden = true
                 self.offerTillBGHeightConstraints.constant = 0
                 self.basecrollTopHeightConstraints.constant = 20

                }
                
                self.loadDataToView()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                print(response.object(forKey: "message") as Any)
            }
            self.stopLoadingIndicator(senderVC: self)
            self.baseScroll.isHidden = false
        }, onFailure: {errorResponse in})
    }
    
    func startOfferTimer()
    {
        //releaseDateString = "2019-09-10 18:00:00"
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        releaseDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        
        offerTillCountDownLabel1.text = "\(diffDateComponents.day ?? 0)"
        offerTillCountDownLabel2.text = "\(diffDateComponents.hour ?? 0)"
        offerTillCountDownLabel3.text = "\(diffDateComponents.minute ?? 0)"
        offerTillCountDownLabel4.text = "\(diffDateComponents.second ?? 0)"
        
       // offerTillCountDownLabel.text = "\(diffDateComponents.day ?? 0) Days, \(diffDateComponents.hour ?? 0) Hrs, \(diffDateComponents.minute ?? 0) Min, \(diffDateComponents.second ?? 0) Sec"
        
        //print("Printing Countdown : ",countdown)
        
        
        
    }
    
    @IBAction func priceBtnAction(_ sender: Any){
        if isfromFavPage || isfromMyReviewPage{
            actAsBaseTabbar.selectedIndex = 0
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }else{
            actAsBaseTabbar.selectedIndex = 0
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func addToCartBtnAction(_ sender: Any) {
       // self.productAddToCart()
    }
    
    func productAddToCart()
    {
        self.showLoadingIndicator(senderVC: self)
        var sendChoiceIds = [Int]()
        var updateStr = String()
        updateStr = ""
        if selectedChoiceIdArray.count != 0{
            for choiceId in selectedChoiceIdArray{
                sendChoiceIds.append(choiceId as! Int)
            }
        }
        
        var newChoiceId = String()
        var oldChoiceId = String()
        newChoiceId = selectedChoiceIdArray.componentsJoined(by: ",")
        oldChoiceId = oldChoiceIdArray.componentsJoined(by: ",")
        var tempQuantity = String()
       updateStr = ""
        tempQuantity = String(actualQuantity)
        
        let Parse = CommomParsing()
        Parse.itemAddToCart(lang: login_session.value(forKey: "Language") as? String ?? "es",item_id: item_id,st_id: restaurant_id,quantity: tempQuantity,choices_id: sendChoiceIds,special_notes: notesText.text!, force_update: updateStr, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                //self.showSuccessPopUp(msgStr: response.object(forKey: "message") as! String)
                let cartCount = ((response.object(forKey: "data")as! NSDictionary).object(forKey: "total_cart_count")as! NSNumber).stringValue
                login_session.setValue(cartCount, forKey: "userCartCount")
                login_session.synchronize()
                self.getData()
               // self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                //self.getData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.showFailurePopUp(msgStr: response.object(forKey: "message") as! String)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 16.0)!,
            kButtonFont: UIFont(name: "TruenoRg", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
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
        let count = login_session.object(forKey: "userCartCount") as! String
//        self.cartBatchLbl.text = count
//        self.cartBatchLbl.isHidden = false
    }
    
    
    
    func OutOfStock(msgStr:String) {
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
              
             }
             
             let icon = UIImage(named:"warning")
             let color = AppLightOrange
             
             _ = alert.showCustom("Warning", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    func showFailurePopUp(msgStr:String){
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
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            nextViewController.navigationType = "present"
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        let icon = UIImage(named:"warning")
        let color = AppLightOrange
        
        _ = alert.showCustom("Warning", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    func  loadDataToView(){
        let itemContent = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemContent as String
        let itemName = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemName
        itemTitleLbl.text = itemName! + " " + "(" + itemContent + ")"
        itemDescriptionLbl.text = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemDesc
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemSpecificatioon.count == 0 {
            FoodImageTop.priority = UILayoutPriority(rawValue: 999)
            extraTitleLbl.isHidden = true
            extraDescLbl.isHidden = true
        }else{
            FoodImageTop.priority = UILayoutPriority(rawValue: 740)
            extraTitleLbl.isHidden = false
            extraDescLbl.isHidden = false
            
            extraTitleLbl.text = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemSpecificatioon[0].specificationTitle
            extraDescLbl.text = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemSpecificatioon[0].specificationDescription
        }
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemIsFavourite == "Favourite" {
            heartBtn.setImage(UIImage.init(imageLiteralResourceName: "liked_heart"), for: .normal)
        }else{
            heartBtn.setImage(UIImage.init(imageLiteralResourceName: "heart"), for: .normal)
        }
        heartBtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        heartBtn.tag = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemId
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemAvailablity == "Available"{
            baseScrollBottomSpace.constant = 20
            AddCartViewHeight.constant = 0
        }else{
            baseScrollBottomSpace.constant = 20
            AddCartViewHeight.constant = 0
        }
        
        
        if ((self.resultDict.object(forKey: "itemt_info") as? NSDictionary)?.value(forKey: "item_is_combo") as! Int) == 0
        {
           self.comboOffersImgView.isHidden = true
        }
        else
        {
            self.comboOffersImgView.isHidden = false
        }
        
        
        if ((self.resultDict.object(forKey: "itemt_info") as? NSDictionary)?.value(forKey: "item_is_halal") as! Int) == 0
        {
            self.halalCertifiedImgView.isHidden = true
        }
        else
        {
            self.halalCertifiedImgView.isHidden = false
        }
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasDiscount == "Yes"{
            let percentage = String(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemDiscountPercent)
            offerLbl.text = "\(percentage)" + "%" + "\noff"
            let price = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemDiscountPrice as String
            let currency = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency as String
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency ?? "") \(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemOriginalPrice ?? "")")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
           // discountPriceLbl.attributedText = attributeString
            
            if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasTax as String == "Yes"
            {
                let tax = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemTax as String
                
                priceLbl.text = "\(currency) \(price)"
                strikeOutPriceLbl.attributedText = attributeString
                 discountPriceLbl.text = "\(" + ") \(tax) \("%")"
            }
            else
            {
                priceLbl.text = "\(currency) \(price)"
                strikeOutPriceLbl.text = ""
                discountPriceLbl.text = ""
            }
            
//            let tax = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemTax as String
//            priceLbl.text = "\(currency) \(price) \(" + ") \(tax)"
            
            
            offerLbl.layer.cornerRadius = 30.0
            offerLbl.clipsToBounds = true
            var CartPrice = resultDict.object(forKey: "cart_amt")as! String
            CartPrice = CartPrice.replacingOccurrences(of: ",", with: "")
            finalPrice = Float(CartPrice)!

            //self.priceBtn.setTitle("\(currency) \(price)", for: .normal)
            if resultDict.object(forKey: "cart_quantity")as! Int != 0 {
                selectedQuantityLbl.text = "\(actualQuantity)"
                let tempQuantity = (resultDict.object(forKey: "cart_quantity")as! Int)
                self.itemsCountLbl.text = "\(tempQuantity) \(LanguageDictonary.value(forKey: "items") as! String) | \(currency)\(CartPrice)"
                baseScrollBottomSpace.constant = 40
                AddCartViewHeight.constant = 50
                if resultDict.object(forKey: "exist_in_cart")as! String == "Yes"{
                    newCartView.isHidden = true
                }else{
                    newCartView.isHidden = false
                }
            }else{
                self.itemsCountLbl.text = "1 \(LanguageDictonary.value(forKey: "items") as! String) | \(currency)\(price)"
                baseScrollBottomSpace.constant = 20
                AddCartViewHeight.constant = 0
                newCartView.isHidden = false
            }
        }else{
            offerWidth.constant = 0
            let price = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemOriginalPrice as String
            let currency = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency as String
            
            if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasTax as String == "Yes"
            {
            let tax = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemTax as String
            
            priceLbl.text = "\(currency) \(price) \(" + ") \(tax) \("%")"
            }
            else
            {
                priceLbl.text = "\(currency) \(price)"
            }
            
           // priceLbl.text = "\(currency) \(price)"
           // self.priceBtn.setTitle("\(currency) \(price)", for: .normal)
            var CartPrice = resultDict.object(forKey: "cart_amt")as! String
            CartPrice = CartPrice.replacingOccurrences(of: ",", with: "")
            finalPrice = Float(CartPrice)!
            discountPriceLbl.isHidden = true
            
            if resultDict.object(forKey: "cart_quantity")as! Int != 0{
                selectedQuantityLbl.text = "\(actualQuantity)"
                let tempQuantity = (resultDict.object(forKey: "cart_quantity")as! Int)
                self.itemsCountLbl.text = "\(tempQuantity) \(LanguageDictonary.value(forKey: "items") as! String) | \(currency)\(CartPrice)"
                baseScrollBottomSpace.constant = 40
                AddCartViewHeight.constant = 50
                newCartView.isHidden = true
                if resultDict.object(forKey: "exist_in_cart")as! String == "Yes"{
                    newCartView.isHidden = true
                }else{
                    newCartView.isHidden = false
                }
            }else{
                self.itemsCountLbl.text = "1 \(LanguageDictonary.value(forKey: "items") as! String) | \(currency)\(price)"
                baseScrollBottomSpace.constant = 20
                AddCartViewHeight.constant = 0
                newCartView.isHidden = false
            }
            
            
        }
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemQuantity == 0{
            quantityLbl.text = LanguageDictonary.object(forKey: "sold") as! String
            quantityLbl.textColor = UIColor.red
        }else{
            quantityLbl.text = String (Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemQuantity as Int) + "\(LanguageDictonary.object(forKey: "itemavailable") as! String)"
            quantityLbl.textColor = AppLightOrange
        }
        

        
        
        
        if Singleton.sharedInstance.ItemDetailModel.data.choices.count != 0{
            topinsLblHeight.constant = 40
            topinsTableHeight.constant = CGFloat(Singleton.sharedInstance.ItemDetailModel.data.choices.count * 30) + 5
            topsViewHeight.constant = topinsTableHeight.constant+40
            toppingsTable.reloadData()
        }else{
            topinsLblHeight.constant = 0
            topinsTableHeight.constant = 0
            topsViewHeight.constant = 0
        }
        relatedCollectionView.reloadData()
        sliderCollectionView.reloadData()
        pageControl.numberOfPages = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemImages.count
        baseView = self.setCornorShadowEffects(sender: baseView)
        baseView.layer.cornerRadius =  10.0
        baseScroll.bringSubviewToFront(baseView)
        if Singleton.sharedInstance.ItemDetailModel.data.relatedItems.count == 0 {
            relatedItemsTitleLbl.isHidden = true
            relatedCollectionView.isHidden = true
            //relatedTitleLblHeight.constant = 0
            //relatedFoodCollectionViewHeight.constant = 0
            baseViewBottom.constant = 10
        }else{
            //relatedTitleLblHeight.constant = 21.0
            //relatedFoodCollectionViewHeight.constant = 250.0
            relatedItemsTitleLbl.isHidden = false
            relatedCollectionView.isHidden = false
            baseViewBottom.constant = 330.33
        }
        
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemImages.count > 1
        {
            startTimer()
        }
    }
    
    @objc func likeBtnTapped(sender:UIButton){
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemAvailablity != "Out of stock"{
        let BtnImg = UIImage(named: "heart")
        if sender.currentImage == BtnImg{
            sender.setImage(UIImage(named: "liked_heart"), for: .normal)
            let pulse1 = CASpringAnimation(keyPath: "transform.scale")
            pulse1.duration = 0.3
            pulse1.fromValue = 1.0
            pulse1.toValue = 1.12
            pulse1.autoreverses = true
            pulse1.repeatCount = 1
            pulse1.initialVelocity = 0.5
            pulse1.damping = 0.8
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.7
            animationGroup.repeatCount = 1
            animationGroup.animations = [pulse1]
            
            sender.layer.add(animationGroup, forKey: "pulse")
        }else{
            sender.setImage(UIImage(named: "heart"), for: .normal)
        }
       
        self.showLoadingIndicator(senderVC: self)
        let product_id  = String(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemId)
        
        let Parse = CommomParsing()
        Parse.addToWishList(lang: login_session.value(forKey: "Language") as? String ?? "es",product_id: product_id, onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200{
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        }else{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "productisoutofstock") as! String)
        }
        
    }
    
    
    @objc func RelatedProductlikeBtnTapped(sender:UIButton){
        if Singleton.sharedInstance.ItemDetailModel.data.relatedItems[sender.tag].itemAvailablity != "Out of stock"{
        let BtnImg = UIImage(named: "heart")
        if sender.currentImage == BtnImg{
            sender.setImage(UIImage(named: "liked_heart"), for: .normal)
            let pulse1 = CASpringAnimation(keyPath: "transform.scale")
            pulse1.duration = 0.6
            pulse1.fromValue = 1.0
            pulse1.toValue = 1.12
            pulse1.autoreverses = true
            pulse1.repeatCount = 1
            pulse1.initialVelocity = 0.5
            pulse1.damping = 0.8
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 1.7
            animationGroup.repeatCount = 1
            animationGroup.animations = [pulse1]
            
            sender.layer.add(animationGroup, forKey: "pulse")
        }else{
            sender.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        self.showLoadingIndicator(senderVC: self)
        let product_id  = String(Singleton.sharedInstance.ItemDetailModel.data.relatedItems[sender.tag].itemId)
        
        let Parse = CommomParsing()
        Parse.addToWishList(lang: login_session.value(forKey: "Language") as? String ?? "es",product_id: product_id, onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200{
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        }else{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "productisoutofstock") as! String)

        }
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any)
    {
        countdownTimer.invalidate()
        if isfromFavPage
        {
          isfromFavPage = false
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }
        else if isfromMyReviewPage
        {
            isfromMyReviewPage = false
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyReviewPage") as! MyReviewPage
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }
        else
        {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func quantityLessBtnAction(_ sender: Any) {
        if actualQuantity != 1 {
            actualQuantity = actualQuantity - 1
            self.productAddToCart()
        }else{
            
        }
        selectedQuantityLbl.text = "\(actualQuantity)"
//        let currency = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency as String
//        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasDiscount == "Yes"{
//            var CartPrice = resultDict.object(forKey: "cart_amt")as! String
//            CartPrice = CartPrice.replacingOccurrences(of: ",", with: "")
//            finalPrice = Float(CartPrice)!
//        }else{
//            var CartPrice = resultDict.object(forKey: "cart_amt")as! String
//            CartPrice = CartPrice.replacingOccurrences(of: ",", with: "")
//            finalPrice = Float(CartPrice)!
//        }
//        UIView.transition(with: priceBtn, duration: 0.5, options: .transitionCrossDissolve, animations: {
////            self.priceBtn.setTitle("\(currency) \(self.finalPrice)", for: .normal)
////            self.addToCartBtn.setTitle("Add \(self.actualQuantity) to cart", for: .normal)
//            if self.actualQuantity == 1{
//              self.itemsCountLbl.text = "\(self.actualQuantity) Item | \(currency) \(self.finalPrice)"
//            }else{
//                self.itemsCountLbl.text = "\(self.actualQuantity) Items | \(currency) \(self.finalPrice)"
//            }
//
//
//        }, completion: nil)
    }
    
    @IBAction func quantityAddBtnAction(_ sender: Any) {
        let avaiableQty = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemQuantity as Int
        if avaiableQty > Int(actualQuantity){
            actualQuantity = actualQuantity + 1
            self.productAddToCart()
        }else{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "productisoutofstock") as! String)
        }
         selectedQuantityLbl.text = "\(actualQuantity)"
//        let currency = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency as String
//
//        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasDiscount == "Yes"{
//            let price = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemDiscountPrice as String
//            finalPrice = Float(price)! * Float(actualQuantity)
//            finalPrice = finalPrice + toppingsPrice
//        }else{
//            let price = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemOriginalPrice as String
//            finalPrice = Float(price)! * Float(actualQuantity)
//            finalPrice = finalPrice + toppingsPrice
//        }
//        UIView.transition(with: priceBtn, duration: 0.5, options: .transitionCrossDissolve, animations: {
////            self.priceBtn.setTitle("\(currency) \(self.finalPrice)", for: .normal)
////            self.addToCartBtn.setTitle("Add \(self.actualQuantity) to cart", for: .normal)
//            self.itemsCountLbl.text = "\(self.actualQuantity) Items | \(currency) \(self.finalPrice)"
//
//        }, completion: nil)
    }
    
    func updateCartQutity(){
        let Parse = CommomParsing()
        let cart_id = resultDict.object(forKey: "cart_id")as! String
        let quantity = String(actualQuantity)
        Parse.updateCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: cart_id,quantity: quantity, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "code")as! String == "" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.showToastAlert(senderVC: self, messageStr: response.value(forKey: "message") as! String)
            }
        }, onFailure: {errorResponse in})
        self.showLoadingIndicator(senderVC: self)
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Singleton.sharedInstance.ItemDetailModel != nil {
            return Singleton.sharedInstance.ItemDetailModel.data.choices.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingTBCell") as? ToppingTBCell
        cell?.selectionStyle = .none
        cell?.toppingsFoodNameLbl.text = Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choiceName
        let currency = Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choiceCurrency as String
        let price = Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choicePrice as String
        let selected_id = Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choiceId
        if selectedChoiceIdArray.contains(selected_id as Any){
            cell?.selectionImg.image = UIImage(imageLiteralResourceName: "selectedCheckBox")
        }else{
             cell?.selectionImg.image = UIImage(imageLiteralResourceName: "checkBox")
        }
        cell?.toppimgsPriceLbl.text = "\(currency)\(price)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected_id = Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choiceId
        let choicePrice = Float(Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choicePrice)
        let currency = Singleton.sharedInstance.ItemDetailModel.data.choices[indexPath.row].choiceCurrency as String
        if selectedChoiceIdArray.contains(selected_id as Any){
            selectedChoiceIdArray.remove(selected_id as Any)
            finalPrice = finalPrice - choicePrice!
            toppingsPrice = toppingsPrice - choicePrice!

        }else{
            selectedChoiceIdArray.add(selected_id as Any)
            finalPrice = finalPrice + choicePrice!
            toppingsPrice = toppingsPrice + choicePrice!
        }
        print(finalPrice)
        toppingsTable.reloadData()
        
        self.checkExistCart()
    }
    
    func checkExistCart(){
        let Parse = CommomParsing()
        Parse.checkExistCart(lang: login_session.value(forKey: "Language") as? String ?? "es", item_id: Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemId, st_id: getRestaurentID, choices_id: selectedChoiceIdArray, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
               if ((response.object(forKey: "data") as! NSDictionary).value(forKey: "quantity") as! Int) == 0
               {
                 self.newCartView.isHidden = false
               }
               else
               {
                 self.newCartView.isHidden = true
               }
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                self.showToastAlert(senderVC: self, messageStr: response.value(forKey: "message") as! String)
            }
        }, onFailure: {errorResponse in})
    }
    
    
    
    //MARK:- ColloectionView Delegate & DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Singleton.sharedInstance.ItemDetailModel != nil {
            if collectionView == relatedCollectionView{
                return Singleton.sharedInstance.ItemDetailModel.data.relatedItems.count
            }else{
               return Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemImages.count
            }
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == relatedCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedItemsCollectionCell", for: indexPath) as! RelatedItemsCollectionCell
            
            cell.addBtn.setTitle(LanguageDictonary.value(forKey: "add") as? String, for: .normal)
            let ImgUrl = URL(string:Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemImage)
            cell.foodImg.kf.setImage(with: ImgUrl)
            if Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemType == "Veg"{
                cell.vegImage.image = UIImage(imageLiteralResourceName: "veg.png")
            }else{
                cell.vegImage.image = UIImage(imageLiteralResourceName: "nonVeg.png")
            }
            
            let currency = Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemCurrency as String
            let itemPrice = Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemOriginalPrice as String
            cell.priceLbl.text = "\(currency)\(itemPrice)"
            cell.descpLbl.text = Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemtDesc as String
            cell.addBtn.layer.cornerRadius = 10.0
            cell.foodNameLbl.text = Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemName as String
            if Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemIsFavourite == "Favourite" {
                cell.likeBtn.setImage(UIImage.init(imageLiteralResourceName: "liked_heart"), for: .normal)
            }else{
                cell.likeBtn.setImage(UIImage.init(imageLiteralResourceName: "heart"), for: .normal)
            }
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(RelatedProductlikeBtnTapped), for: .touchUpInside)
            
            
            if Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemAvailablity == "Out of stock"
            {
             cell.firstOutOfStockBGGrayView.isHidden = false
            }
            else
            {
                cell.firstOutOfStockBGGrayView.isHidden = true
            }
            
            // cornor shadow effects
            cell.layer.cornerRadius = 3.0
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.6
            let containerView = cell.baseView!
            containerView.layer.cornerRadius = 15
            containerView.clipsToBounds = true
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageSliderCell", for: indexPath) as! imageSliderCell
            let ImgUrl = URL(string:Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemImages[indexPath.row])
            if indexPath.row == 0{
                actAsFoodImg.kf.setImage(with: ImgUrl)
            }
            cell.foodImg.kf.setImage(with: ImgUrl)
            return cell
        }
    }
    
    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        
        let timer =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
       
        
        
        
//        let cellSize = view.frame.size
//
//        //get current content Offset of the Collection view
//        let contentOffset = sliderCollectionView.contentOffset
//
//        if sliderCollectionView.contentSize.width <= sliderCollectionView.contentOffset.x + cellSize.width
//        {
//            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
//            sliderCollectionView.scrollRectToVisible(r, animated: true)
//
//        } else {
//            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
//            sliderCollectionView.scrollRectToVisible(r, animated: true);
//        }

        
        if let coll  = sliderCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemImages.count - 1)
                {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)

                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }

            }
        }
    }

    func updateCart(quantity:String){
        let Parse = CommomParsing()
        Parse.updateCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: "",quantity: quantity, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
               // self.getCartData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "code")as! String == "" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.showToastAlert(senderVC: self, messageStr: response.value(forKey: "message") as! String)
            }
        }, onFailure: {errorResponse in})
        self.showLoadingIndicator(senderVC: self)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == relatedCollectionView{
            item_id = String(Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemId as Int)
            itemName = Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].itemName as String
            restaurant_id = String(Singleton.sharedInstance.ItemDetailModel.data.relatedItems[indexPath.row].restaurantId as Int)
            baseScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.loadingInitData()
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (collectionView == sliderCollectionView){
            var size = CGSize()
            size.width = collectionView.frame.size.width
            size.height = 270
            return size
        }else{
            var size = CGSize()
            size.width = 220
            size.height = 201
            return size
        }
        
    }
    
    func flyTocart()
    {
//        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: self.tableViewProduct)
//
//        let indexPath = self.tableViewProduct.indexPathForRow(at: buttonPosition)!
//
//        let cell = tableViewProduct.cellForRow(at: indexPath) as! ProductCell
        
        let imageViewPosition : CGPoint = actAsFoodImg.convert(actAsFoodImg.bounds.origin, to: self.view)
        
        
        let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: actAsFoodImg.frame.size.width, height: actAsFoodImg.frame.size.height))
        
        imgViewTemp.image = actAsFoodImg.image
        
        //animation(tempView: imgViewTemp)
    }
    
   
    
}

extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}

