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
    @IBOutlet private weak var offerTillBGView: UIView!
    @IBOutlet private weak var offerTillBGHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet private weak var offerTillView1: UIView!
    @IBOutlet private weak var offerTillView2: UIView!
    @IBOutlet private weak var offerTillView3: UIView!
    @IBOutlet private weak var offerTillView4: UIView!
    
    @IBOutlet private weak var offerTillCountDownLabel1: UILabel!
    @IBOutlet private weak var offerTillCountDownLabel2: UILabel!
    @IBOutlet private weak var offerTillCountDownLabel3: UILabel!
    @IBOutlet private weak var offerTillCountDownLabel4: UILabel!
    
    @IBOutlet private weak var offerTillLbl: UILabel!
    
    @IBOutlet private weak var offerdaysLbl: UILabel!
    
    @IBOutlet private weak var offersSecLbl: UILabel!
    @IBOutlet private weak var offerminLbl: UILabel!
    @IBOutlet private weak var offerHoursLbl: UILabel!
    
    @IBOutlet weak var viewcartLbl: UILabel!
    
    
    private var releaseDate: NSDate?
    private var countdownTimer = Timer()
    private var releaseDateString = String()
    
    private var selectedChoiceIdArray  = Set<Int>()
    private var selectedChoiceTwoArray = Set<Int>()
    private var selectedChoiceThreeArray = Set<Int>()
    private var oldChoiceIdArray  = NSMutableArray()
    private var resultDict = NSMutableDictionary()
    private var resultDict1 = NSMutableDictionary()

    private var actualQuantity = Int()
    private var finalPrice = Float()
    private var itemPrice = Float()
    private var toppingsPrice = Float()
    var item_id = String()
    var itemName = String()
    var restaurant_id = String()
    private var window: UIWindow?
    var rest_id = String()
    private var store_id = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCartBtn.layer.cornerRadius = 2  //22.5
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
        self.toppingsTable.isScrollEnabled = false
        self.toppingsTable.sectionHeaderHeight = UITableView.automaticDimension
        self.toppingsTable.estimatedSectionHeaderHeight = 50
        self.toppingsTable.sectionFooterHeight = 0
        self.toppingsTable.separatorStyle = .none
        self.toppingsTable.tableFooterView = UIView()
        self.toppingsTable.estimatedSectionFooterHeight = 0
        contentSizeObservation = toppingsTable.observe(\.contentSize) { [weak self] tableView, _ in
            self?.topinsTableHeight.constant = tableView.contentSize.height
        }
    }
    
    var contentSizeObservation: NSKeyValueObservation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadingInitData()
        self.getCartData()
    }
    
    func loadingInitData() {
        navigationTitleLbl.text = itemName
        actualQuantity = 1
        toppingsPrice = 0
        baseScroll.isHidden = true
        self.getData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        countdownTimer.invalidate()
    }
    
    deinit {
        contentSizeObservation?.invalidate()
        contentSizeObservation = nil
        timer?.invalidate()
        timer = nil
    }
    
    func getCartData() {
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
    
    private func continueAddToCart() {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.itemAddToCart(lang: login_session.value(forKey: "Language") as? String ?? "es",
                            item_id: item_id,
                            st_id: restaurant_id,
                            quantity: String(actualQuantity),
                            choices_id: Array(selectedChoiceIdArray),
                            choicesTwo_id: Array(selectedChoiceTwoArray),
                            choicesThree_id: Array(selectedChoiceThreeArray),
                            special_notes: notesText.text!, force_update: "", onSuccess: {
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
    
    @IBAction func newCartBtnAction(_ sender: Any) {
        
        if !store_id.isEmpty && store_id != restaurant_id {
            let refreshAlert = UIAlertController(title: Appname,
                                                 message: Localization.value(for: "yourcartstartfresh"),
                                                 preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: Localization.value(for: "yesfreash"),
                                                 style: .default, handler: { _ in
                self.continueAddToCart()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        } else {
            continueAddToCart()
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
    
    func getData() {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getItemDetails(lang: login_session.value(forKey: "Language") as? String ?? "es",item_id: item_id,review_page_no: "1" , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200 {
                let mod = itemDetailModel(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.ItemDetailModel = mod
                self.resultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                
                if ((self.resultDict.object(forKey: "itemt_info") as? NSDictionary)?.value(forKey: "discount_remaining_time") as! Int) != 0 {
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
        continueAddToCart()
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: .truenoBold(size: 20),
            kTextFont: .truenoRegular(size: 16),
            kButtonFont: .truenoRegular(size: 16),
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
    }
    
    
    
    func OutOfStock(msgStr:String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: .truenoBold(size: 20),
            kTextFont: .truenoRegular(size: 14),
            kButtonFont: .truenoBold(size: 16),
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
            kTitleFont: .truenoBold(size: 20),
            kTextFont: .truenoRegular(size: 14),
            kButtonFont: .truenoBold(size: 16),
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
        var price = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasDiscount == "Yes"
        ? Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemDiscountPrice as String
        : Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemOriginalPrice as String
        if let priceFloat = Float(price) {
            itemPrice = priceFloat
        } else {
            assertionFailure("Price is not a float, why?")
        }
        let currency = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency as String
        offerWidth.constant = 0
        discountPriceLbl.isHidden = true
        updateTotalPrice()
        
        var CartPrice = resultDict.object(forKey: "cart_amt")as! String
        CartPrice = CartPrice.replacingOccurrences(of: ",", with: "")
        finalPrice = Float(CartPrice)!
        
        if resultDict.object(forKey: "cart_quantity")as! Int != 0 {
            selectedQuantityLbl.text = "\(actualQuantity)"
            let tempQuantity = (resultDict.object(forKey: "cart_quantity")as! Int)
            self.itemsCountLbl.text = "\(tempQuantity) \(LanguageDictonary.value(forKey: "items") as! String) | \(currency)\(CartPrice)"
            baseScrollBottomSpace.constant = 40
            AddCartViewHeight.constant = 50
                
            if resultDict.object(forKey: "exist_in_cart")as! String == "Yes"{
                newCartView.isHidden = true
            } else {
                newCartView.isHidden = false
            }
        } else {
            self.itemsCountLbl.text = "1 \(LanguageDictonary.value(forKey: "items") as! String) | \(currency)\(price)"
            baseScrollBottomSpace.constant = 20
            AddCartViewHeight.constant = 0
            newCartView.isHidden = false
        }
        
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemQuantity == 0{
            quantityLbl.text = Localization.value(for: "sold")
            quantityLbl.textColor = UIColor.red
        }else{
            quantityLbl.text = Localization.value(for:"itemavailable")
            quantityLbl.textColor = AppLightOrange
        }
        
        if Singleton.sharedInstance.ItemDetailModel.data.sectionedChoices.isEmpty {
            topinsTableHeight.constant = 0
        }
        
        toppingsTable.reloadData()
        relatedCollectionView.reloadData()
        sliderCollectionView.reloadData()
        pageControl.numberOfPages = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemImages.count
        baseView = self.setCornorShadowEffects(sender: baseView)
        baseView.layer.cornerRadius =  10.0
        baseScroll.bringSubviewToFront(baseView)
        if Singleton.sharedInstance.ItemDetailModel.data.relatedItems.count == 0 {
            relatedItemsTitleLbl.isHidden = true
            relatedCollectionView.isHidden = true
            baseViewBottom.constant = 10
        }else {
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
            continueAddToCart()
        }
        selectedQuantityLbl.text = "\(actualQuantity)"
    }
    
    @IBAction func quantityAddBtnAction(_ sender: Any) {
        let avaiableQty = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemQuantity as Int
        if avaiableQty > Int(actualQuantity){
            actualQuantity = actualQuantity + 1
            continueAddToCart()
        }else {
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "productisoutofstock") as! String)
        }
        selectedQuantityLbl.text = "\(actualQuantity)"
    }
    
    private var currentItemDetailModel: itemDetailModel? {
        Singleton.sharedInstance.ItemDetailModel
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        currentItemDetailModel?.data.sectionedChoices.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItemDetailModel?.data.sectionedChoices[section].count ?? 0
    }
    
    private var choicesSectioned: [Set<Int>] {
        [selectedChoiceIdArray, selectedChoiceTwoArray, selectedChoiceThreeArray]
    }
    
    private func isChoiceSelected(for section: Int, id: Int) -> Bool {
        choicesSectioned[section].contains(id)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingTBCell") as? ToppingTBCell
        cell?.selectionStyle = .none
        guard let choice: Choice = currentItemDetailModel?.data.choice(for: indexPath.section, row: indexPath.row) else {
            return cell!
        }
        cell?.toppingsFoodNameLbl.text = choice.choiceName
        let currency = choice.choiceCurrency as String
        let price = choice.choicePrice as String
        let selected_id = choice.choiceId!
        if isChoiceSelected(for: indexPath.section, id: selected_id) {
            cell?.selectionImg.image = UIImage(imageLiteralResourceName: "selectedCheckBox")
        } else {
            cell?.selectionImg.image = UIImage(imageLiteralResourceName: "checkBox")
        }
        cell?.toppimgsPriceLbl.text = "\(currency)\(price)"
        return cell!
    }
    
    private func removeChoice(for section: Int, id: Int) {
        switch section {
        case 0:
            if !Singleton.sharedInstance.ItemDetailModel.data.choices.isEmpty {
                selectedChoiceIdArray.remove(id)
            } else if !Singleton.sharedInstance.ItemDetailModel.data.choicesTwo.isEmpty {
                selectedChoiceTwoArray.remove(id)
            } else if !Singleton.sharedInstance.ItemDetailModel.data.choicesThree.isEmpty {
                selectedChoiceThreeArray.remove(id)
            }
        case 1:
            if !Singleton.sharedInstance.ItemDetailModel.data.choicesTwo.isEmpty {
                selectedChoiceTwoArray.remove(id)
            } else if !Singleton.sharedInstance.ItemDetailModel.data.choicesThree.isEmpty {
                selectedChoiceThreeArray.remove(id)
            }
        case 2:
            if !Singleton.sharedInstance.ItemDetailModel.data.choicesThree.isEmpty {
                selectedChoiceThreeArray.remove(id)
            }
        default: break
        }
    }
    
    private func addChoice(for section: Int, id: Int) {
        switch section {
        case 0:
            if !Singleton.sharedInstance.ItemDetailModel.data.choices.isEmpty {
                selectedChoiceIdArray.insert(id)
            } else if !Singleton.sharedInstance.ItemDetailModel.data.choicesTwo.isEmpty {
                selectedChoiceTwoArray.insert(id)
            } else if !Singleton.sharedInstance.ItemDetailModel.data.choicesThree.isEmpty {
                selectedChoiceThreeArray.insert(id)
            }
        case 1:
            if !Singleton.sharedInstance.ItemDetailModel.data.choicesTwo.isEmpty {
                selectedChoiceTwoArray.insert(id)
            } else if !Singleton.sharedInstance.ItemDetailModel.data.choicesThree.isEmpty {
                selectedChoiceThreeArray.insert(id)
            }
        case 2:
            if !Singleton.sharedInstance.ItemDetailModel.data.choicesThree.isEmpty {
                selectedChoiceThreeArray.insert(id)
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let choice = currentItemDetailModel?.data.sectionedChoices[section].first else {
            return nil
        }
        let header = UIView()
        header.backgroundColor = UIColor.groupTableViewBackground
        let label = UILabel()
        label.text = choice.choiceTitle
        label.textColor = UIColor.black
        label.font = UIFont.truenoRegular(size: 18)
        header.addSubview(label)
        header.frame = CGRect()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalToConstant: tableView.frame.width - 20)
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedChoice = currentItemDetailModel?.data.choice(for: indexPath.section, row: indexPath.row) else {
            return
        }
        let selected_id = selectedChoice.choiceId!
        let choicePrice = Float(selectedChoice.choicePrice)!
        let currency = selectedChoice.choiceCurrency! as String
        if isChoiceSelected(for: indexPath.section, id: selected_id) {
            removeChoice(for: indexPath.section, id: selected_id)
            finalPrice = finalPrice - choicePrice
            toppingsPrice = toppingsPrice - choicePrice
            
        }else{
            addChoice(for: indexPath.section, id: selected_id)
            finalPrice = finalPrice + choicePrice
            toppingsPrice = toppingsPrice + choicePrice
        }
        toppingsTable.reloadData()
        self.checkExistCart()
    }
    
    private func updateTotalPrice() {
        let currency = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency as String
        let priceFloat = itemPrice + toppingsPrice
        let price = String(format: "%.2f", priceFloat)
        if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasDiscount == "Yes"{
            let percentage = String(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemDiscountPercent)
            offerLbl.text = "\(percentage)" + "%" + "\noff"
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemCurrency ?? "") \(Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemOriginalPrice ?? "")")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            
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
            
            offerLbl.layer.cornerRadius = 30.0
            offerLbl.clipsToBounds = true
        } else if Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemHasTax as String == "Yes" {
            let tax = Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemTax as String
            
            priceLbl.text = "\(currency) \(price) \(" + ") \(tax) \("%")"
        } else {
            priceLbl.text = "\(currency) \(price)"
        }
    }
    
    func checkExistCart(){
        let Parse = CommomParsing()
        Parse.checkExistCart(lang: login_session.value(forKey: "Language") as? String ?? "es",
                             item_id: Singleton.sharedInstance.ItemDetailModel.data.itemtInfo.itemId,
                             st_id: getRestaurentID,
                             choices_id: Array(selectedChoiceIdArray),
                             choicesTwo_id: Array(selectedChoiceTwoArray),
                             choicesThree_id: Array(selectedChoiceThreeArray),
                             onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                if let qty = ((response.object(forKey: "data") as? NSDictionary)?.value(forKey: "quantity") as? Int),
                   qty > 0
                {
                    self.newCartView.isHidden = true
                }
                else
                {
                    self.newCartView.isHidden = false
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
            cell.addBtn.layer.borderWidth = 2
            cell.addBtn.layer.borderColor = UIColor.red.cgColor
            cell.addBtn.layer.backgroundColor = UIColor.white.cgColor
            cell.addBtn.setTitleColor(UIColor.red, for: .normal)
            
            let image3 = UIImage(named: "add")
            
            cell.addBtn.setImage(image3, for: .normal)
            cell.addBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
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
    var timer: Timer?
    func startTimer() {
        timer =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
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

