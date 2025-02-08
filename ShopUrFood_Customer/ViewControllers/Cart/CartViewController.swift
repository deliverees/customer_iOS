//
//  CartViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Alamofire
import DateTimePicker
import SCLAlertView
import Popover
import AMPopTip
import QuartzCore


@available(iOS 11.0, *)
class CartViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,DateTimePickerDelegate,delegateForChoiceRemoveFromCart {
    
    
    @IBOutlet weak var transpertantView: UIView!
    @IBOutlet weak var popUpViewItemsBtn: UIButton!
    @IBOutlet weak var popUpUpdateBtn: UIButton!
    @IBOutlet weak var extrasTable: UITableView!
    @IBOutlet weak var popUpNotesTxt: UITextField!
    @IBOutlet weak var popUpItemPriceLbl: UILabel!
    @IBOutlet weak var popUpCloseBtn: UIButton!
    @IBOutlet weak var popUpItemName: UILabel!
    @IBOutlet weak var extrasTableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var emptyCartBtn: UIButton!
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var emptyCartView: UIView!
    @IBOutlet weak var navigationPriceLbl: UILabel!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var taxTitleLbl: UILabel!
    @IBOutlet weak var taxValueLbl: UILabel!
    
    @IBOutlet weak var iamemptyLbl: UILabel!
    
    @IBOutlet weak var specialInstructionLbl: UILabel!
    @IBOutlet weak var itemAmountLbl: UILabel!
    @IBOutlet weak var cartEmptyLbl: UILabel!
    //PROMOTIONAL OFFERS VIEW
    @IBOutlet weak var promotionalOfferBGView: UIView!
    @IBOutlet weak var promotionalOfferPopupView: UIView!
    @IBOutlet weak var promotionalOfferTxtLbl: UILabel!
    @IBOutlet weak var promotionalHeaderTxtLbl: UILabel!
    @IBOutlet weak var promotionalOfferOkayButton: UIButton!
    
    @IBOutlet weak var peakBGView: UIView!
    @IBOutlet weak var peakClickedPopupview: UIView!
    @IBOutlet weak var peakDescLbl: UILabel!
    @IBOutlet weak var peakChargeLbl: UILabel!
    
    var resultDict = NSMutableDictionary()
    var EditExtrasSection = Int()
    var EditExtrasRow = Int()
    var selectedCartChoiceArray = NSMutableArray()
    
    let popTip = PopTip()
    var direction = PopTipDirection.up
    var peakClickedPopupviewFrame = UIView()
    var removePreorderArray = NSMutableArray()
    
    @IBOutlet weak var topNavigationView: UIView!
    
    @IBOutlet weak var popUpViewItemsWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var popUpUpdateCartWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var menuBtn: UIButton!
    
    var paypalFlag = Bool()
    var StripeFlag = Bool()
    var NetBankingFlag = Bool()
    var paymentResultDict = NSMutableDictionary()
    var popupPointsShow = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iamemptyLbl.text = LanguageDictonary.value(forKey: "iamempty") as? String
        self.cartEmptyLbl.text = LanguageDictonary.value(forKey: "yourcartempty") as? String
        self.emptyCartBtn.setTitle(LanguageDictonary.value(forKey: "addsomefood") as? String, for: .normal)
        self.itemAmountLbl.text = LanguageDictonary.value(forKey: "itemamount") as? String
        self.specialInstructionLbl.text = LanguageDictonary.value(forKey: "specialinstruction") as? String
        self.popUpUpdateBtn.setTitle(LanguageDictonary.value(forKey: "updatecart") as? String, for: .normal)
        self.popUpViewItemsBtn.setTitle(LanguageDictonary.value(forKey: "viewitem") as? String, for: .normal)
        self.promotionalOfferOkayButton.setTitle(LanguageDictonary.value(forKey: "okaygotit") as? String, for: .normal)
        
        // add shadow effect to scroll
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        
        emptyCartView = self.setCornorShadowEffects(sender: emptyCartView)
        emptyCartView.layer.cornerRadius = 5.0
        cartTable.estimatedRowHeight = 105
        cartTable.rowHeight = UITableView.automaticDimension
        
        if revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width-80
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        emptyCartBtn.clipsToBounds = true
        
        emptyCartBtn.layer.borderWidth = 2
        emptyCartBtn.layer.borderColor = UIColor.red.cgColor
        emptyCartBtn.setTitleColor(UIColor.red, for: .normal)
        emptyCartBtn.layer.backgroundColor = UIColor.white.cgColor
        
        popTip.font = UIFont(name: "Avenir-Medium", size: 12)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip.bubbleColor = UIColor.black
        
        /*
         Other customization:
         */
        //    popTip.borderWidth = 2
        //    popTip.borderColor = UIColor.blue
        //    popTip.shadowOpacity = 0.4
        //    popTip.shadowRadius = 3
        //    popTip.shadowOffset = CGSize(width: 1, height: 1)
        //    popTip.shadowColor = .black
        
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
        
        
        // Do any additional setup after loading the view.
        let rectShape1 = CAShapeLayer()
        rectShape1.bounds = promotionalOfferPopupView.frame
        rectShape1.position = promotionalOfferPopupView.center
        rectShape1.path = UIBezierPath(roundedRect: promotionalOfferPopupView.bounds, byRoundingCorners: [UIRectCorner.topLeft , UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 20, height: 20)).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.frame = promotionalOfferPopupView.bounds
        maskLayer.path = rectShape1.path
        
        // Set the newly created shape layer as the mask for the image view's layer
        promotionalOfferPopupView.layer.mask = maskLayer
        
    }
    
    @IBAction func menuBtnAction(_ sender: Any) {
        revealViewController()?.revealToggle(animated: true)
    }
    
    @IBAction func promotionOfferOkBtnTapped(_ sender: Any)
    {
        promotionalOfferBGView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "yourcart") as? String
        popupPointsShow = true
        self.emptyCartView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.getCartData()
    }
    
    //MARK:- Side Menu Button Action
    
    @IBAction func EmptyCartBtnAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    
    //MARK:- API Calling Functions
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
                
                self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                
                peakHourFee = (self.resultDict.object(forKey: "peakHourFee") as! String)
                peakHourFeeStatus = (self.resultDict.object(forKey: "peakHourFeeStatus") as! String)
                peakHour_Info = (self.resultDict.object(forKey: "peakHour_Info") as! String)
                peakCurrency = (self.resultDict.object(forKey: "currency_code") as! String)
                
                if self.popupPointsShow == true
                {
                    self.popupPointsShow = false
                    
                    if (self.resultDict.object(forKey: "loyalty_info") as! String) != ""
                    {
                        self.promotionalOfferBGView.isHidden = false
                        self.promotionalOfferTxtLbl.text = (self.resultDict.object(forKey: "loyalty_info") as! String)
                    }
                    else
                    {
                        self.promotionalOfferBGView.isHidden = true
                    }
                }
                
                
                let currency = Singleton.sharedInstance.MyCartModel.data.currencyCode as String
                let grandTotal = Singleton.sharedInstance.MyCartModel.data.totalCartAmount as String
                self.navigationPriceLbl.text = LanguageDictonary.value(forKey: "pay") as! String + " " + currency + grandTotal
                self.navigationPriceLbl.isHidden = false
                self.cartTable.isHidden = false
                self.emptyCartView.isHidden = true
                self.baseContentView.isHidden = false
                
                let cartCount = ((response.object(forKey: "data")as! NSDictionary).object(forKey: "total_cart_count")as! NSNumber).stringValue
                login_session.setValue(cartCount, forKey: "userCartCount")
                login_session.synchronize()
                let batchCartCount = login_session.object(forKey: "userCartCount")as! String
                if (batchCartCount == "0"){
                    actAsBaseTabbar.tabBar.items?[0].badgeValue = nil
                }else{
                    actAsBaseTabbar.tabBar.items?[0].badgeValue = batchCartCount
                    actAsBaseTabbar.tabBar.items?[0].badgeColor = AppDarkOrange
                }
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.baseContentView.isHidden = true
                self.cartTable.isHidden = true
                self.navigationPriceLbl.isHidden = true
                self.emptyCartView.isHidden = false
                Singleton.sharedInstance.MyCartModel = nil
                login_session.setValue("0", forKey: "userCartCount")
                actAsBaseTabbar.tabBar.items?[0].badgeValue = nil
                login_session.synchronize()
            }
            DispatchQueue.main.async {
                self.extrasTable.reloadData()
                self.cartTable.reloadData()
                self.stopLoadingIndicator(senderVC: self)
            }
        }, onFailure: {errorResponse in
            self.showTokenExpiredPopUp(msgStr: errorResponse?.localizedDescription ?? "")
        })
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if Singleton.sharedInstance.MyCartModel != nil{
            if tableView == extrasTable{
                return 1
            }
            return Singleton.sharedInstance.MyCartModel.data.cartDetails.count + 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Singleton.sharedInstance.MyCartModel.data.cartDetails.count{
            return 1
        }else{
            if tableView == extrasTable{
                return Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices.count + 1
            }
            return Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == extrasTable{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartChoicesTitleCell") as? CartChoicesTitleCell
                cell?.selectionStyle = .none
                cell?.choicelbl.text = LanguageDictonary.value(forKey: "choice") as? String
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartChoicesCell") as? CartChoicesCell
                cell?.selectionStyle = .none
                let nameStr = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices[indexPath.row-1].choiceName
                cell?.toppingNameLbl.text = nameStr
                let currency = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices[indexPath.row-1].choiceCurrency
                let price = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices[indexPath.row-1].choicePrice
                cell?.toppingPriceLbl.text = "\(currency ?? "")\(price ?? "")"
                if selectedCartChoiceArray.count != 0 {
                    let tempArray = selectedCartChoiceArray.value(forKey: "choice_name")as! NSArray
                    if tempArray.contains(nameStr as Any){
                        cell?.selectionImg.image = UIImage(named: "selectedCheckBox")
                    }else{
                        cell?.selectionImg.image = UIImage(named: "checkBox")
                    }
                }else{
                    cell?.selectionImg.image = UIImage(named: "checkBox")
                }
                
                return cell!
            }
        }else {
            if indexPath.section == Singleton.sharedInstance.MyCartModel.data.cartDetails.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell") as? CartTotalCell
                cell?.selectionStyle = .none
                
                cell?.subTotalLbl.text = LanguageDictonary.value(forKey: "subtotal") as? String
                cell?.taxLbl.text = LanguageDictonary.value(forKey: "tax") as? String
                cell?.deliveryFeeLbl.text = LanguageDictonary.value(forKey: "deliveryfee") as? String
                cell?.totalLbl.text = LanguageDictonary.value(forKey: "total") as? String
                cell?.checkOutBtn.setTitle(LanguageDictonary.value(forKey: "checkout") as? String, for: .normal)
                cell?.managementFeeLbl.text = Localization.value(for: "managementFee")
                
                cell?.checkOutBtn.layer.borderWidth = 2
                cell?.checkOutBtn.layer.borderColor = UIColor.red.cgColor
                
                let currency = Singleton.sharedInstance.MyCartModel.data.currencyCode as String
                let subTotal = Singleton.sharedInstance.MyCartModel.data.cartSubTotal as String
                let deliveryFee = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
                let grandTotal = Singleton.sharedInstance.MyCartModel.data.totalCartAmount as String
                let taxTotal = Singleton.sharedInstance.MyCartModel.data.cartTaxTotal as String
                
                cell?.subTotalValueLbl.text = currency + " " + subTotal
                cell?.deliveryFeeValueLbl.text = currency + " " + deliveryFee
                cell?.totalValueLbl.text = currency + " " + grandTotal
                cell?.taxValueLbl.text = currency + " " + taxTotal
                cell?.taxLbl.superview?.isHidden = taxTotal == "0.00" || taxTotal.isEmpty
                cell?.deliveryFeeValueLbl.superview?.isHidden = deliveryFee == "0.00" || deliveryFee.isEmpty
                if let managementFee = Singleton.sharedInstance.MyCartModel.data.managementFee {
                    cell?.managementFeeAmtLbl.text = currency + " " + managementFee
                }
                cell?.totalView.tag = 1001
                
                peakClickedPopupviewFrame.frame = cell!.frame
                
                if peakHourFeeStatus == "0"
                {
                    cell?.peakHoursFeeBtn.isHidden = true
                }
                else
                {
                    cell?.peakHoursFeeBtn.isHidden = false
                    cell?.peakHoursFeeBtn.tag = indexPath.row
                }
                cell?.peakHoursFeeBtn.addTarget(self,action:#selector(peakHoursBtnClicked(sender:)), for: .touchUpInside)
                
                cell?.checkOutBtn.addTarget(self, action: #selector(checkOutBtnTapped), for: .touchUpInside)
                
                return cell!
            }else{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CartHeaderCell") as? CartHeaderCell
                    cell?.selectionStyle = .none
                    cell?.restaurantNameLbl.text = Singleton.sharedInstance.MyCartModel.data.cartDetails[indexPath.section].storeName
                    if Singleton.sharedInstance.MyCartModel.data.cartDetails[indexPath.section].preOrderStatus == "Available"{
                        cell?.preOrderBtn.isHidden = false
                        cell?.preOrderImg.isHidden = false
                        cell?.preOrderLbl.isHidden = false
                        cell?.preOrderBtn.tag = indexPath.section
                        cell?.preOrderBtn.addTarget(self, action: #selector(DateAndTimePickerTapped), for: .touchUpInside)
                        
                        cell?.closePreOrderBtn.addTarget(self, action: #selector(removePreOrderButtonTapped), for: .touchUpInside)
                        
                        if Singleton.sharedInstance.MyCartModel.data.cartDetails[indexPath.section].addedItemDetails[0].cartPreOrder != ""
                        {
                            if Singleton.sharedInstance.MyCartModel.data.cartDetails[indexPath.section].addedItemDetails[0].cartPreOrder == "0000-00-00 00:00:00"
                            {
                                cell?.preOrderLbl.text = LanguageDictonary.value(forKey: "preorder") as? String
                                cell?.closePreOrderButtonWidth.constant = 0
                                cell?.closePreOrderBtn.isHidden = true
                            }
                            else
                            {
                                let dateStr = self.changeToHoursFormat(getDate: Singleton.sharedInstance.MyCartModel.data.cartDetails[indexPath.section].addedItemDetails[0].cartPreOrder)
                                cell?.preOrderLbl.text = dateStr
                                cell?.closePreOrderButtonWidth.constant = 28
                                cell?.closePreOrderBtn.isHidden = false
                            }
                        }
                        else
                        {
                            cell?.preOrderLbl.text = LanguageDictonary.value(forKey: "preorder") as? String
                            cell?.closePreOrderButtonWidth.constant = 0
                            cell?.closePreOrderBtn.isHidden = true
                        }
                    }else
                    {
                        cell?.preOrderBtn.isHidden = true
                        cell?.preOrderImg.isHidden = true
                        cell?.preOrderLbl.isHidden = true
                    }
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell") as? CartItemCell
                    cell?.selectionStyle = .none
                    cell?.configData(index: indexPath.row-1, section: indexPath.section)
                    cell?.plusBtn.addTarget(self, action: #selector(QuantityPlusBtnTapped), for: .touchUpInside)
                    let tempIndex = indexPath.row - 1
                    cell!.plusBtn.tag = (indexPath.section*100)+tempIndex
                    cell?.lessBtn.tag = (indexPath.section*100)+tempIndex
                    cell?.lessBtn.addTarget(self, action: #selector(lessBtnTapped), for: .touchUpInside)
                    cell?.removeFromCartBtn.tag = (indexPath.section*100)+tempIndex
                    cell?.removeFromCartBtn.addTarget(self, action: #selector(removeFromCartBtnTapped), for: .touchUpInside)
                    cell?.foodImg.tag = (indexPath.section*100)+tempIndex
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                    cell?.foodImg.isUserInteractionEnabled = true
                    cell?.foodImg.addGestureRecognizer(tapGestureRecognizer)
                    cell?.delegate = self
                    return cell!
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == extrasTable{
            let selectedName = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices[indexPath.row-1].choiceName
            let selectedId = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices[indexPath.row-1].choiceId
            if selectedCartChoiceArray.count != 0{
                let tempArray = selectedCartChoiceArray.value(forKey: "choice_name")as! NSArray
                if tempArray.contains(selectedName as Any){
                    let particularIndex = tempArray.index(of: selectedName as Any)
                    selectedCartChoiceArray.removeObject(at: particularIndex)
                }else{
                    let tempDict = NSMutableDictionary()
                    tempDict.setValue(selectedName, forKey: "choice_name")
                    tempDict.setValue(selectedId, forKey: "choice_id")
                    selectedCartChoiceArray.add(tempDict)
                }
            }else{
                let tempDict = NSMutableDictionary()
                tempDict.setValue(selectedName, forKey: "choice_name")
                tempDict.setValue(selectedId, forKey: "choice_id")
                selectedCartChoiceArray.add(tempDict)
            }
            extrasTable.reloadData()
        }else{
            if indexPath.section == Singleton.sharedInstance.MyCartModel.data.cartDetails.count{
                
            }else{
                if indexPath.row != 0{
                    EditExtrasSection = indexPath.section
                    EditExtrasRow = indexPath.row-1
                    self.showToppingsView()
                }
            }
        }
        
    }
    
    //Mark:- Food Image tapped Action
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        EditExtrasSection = tappedImage.tag / 100
        EditExtrasRow = tappedImage.tag % 100
        self.showToppingsView()
        
        
    }
    func showToppingsView(){
        popUpCloseBtn.addTarget(self, action: #selector(popCloseBtnAction), for: .touchUpInside)
        transpertantView.backgroundColor = BlackTranspertantColor
        transpertantView.isHidden = false
        popUpItemName.text = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].productName
        let currency = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].cartCurrency as String
        let total = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].cartUnitPrice as String
        popUpItemPriceLbl.text = currency + total
        
        let taxTotal = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].cartTax as String
        taxValueLbl.text = currency + taxTotal
        
        
        let Notes = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].cartSplRequest
        popUpNotesTxt.text = Notes
        let toppingCount = Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].itemChoices.count
        selectedCartChoiceArray.removeAllObjects()
        if toppingCount == 0 {
            extrasTableviewHeight.constant = 0
        }else{
            if toppingCount <= 3
            {
                extrasTableviewHeight.constant = CGFloat(toppingCount*60)
            }
            else
            {
                extrasTableviewHeight.constant = 180
            }
            let tempCart_details = resultDict.object(forKey: "cart_details")as! NSArray
            let cartDetailsArray = tempCart_details.mutableCopy() as! NSMutableArray
            let itemDict = NSMutableDictionary()
            itemDict.addEntries(from: cartDetailsArray.object(at: EditExtrasSection) as! [AnyHashable : Any])
            let tempAddedArray = itemDict.object(forKey: "added_item_details")as! NSArray
            let addedItemArray = tempAddedArray.mutableCopy() as! NSMutableArray
            let cartChoiceDict = NSMutableDictionary()
            cartChoiceDict.addEntries(from: (addedItemArray.object(at: EditExtrasRow)as! NSDictionary) as! [AnyHashable : Any])
            selectedCartChoiceArray.addObjects(from: (cartChoiceDict.object(forKey: "cart_choices")as! NSArray) as! [Any])
        }
        extrasTable.reloadData()
        popUpUpdateBtn.layer.cornerRadius = 17.5
        popUpViewItemsBtn.layer.cornerRadius = 17.5
    }
    
    @objc func popCloseBtnAction(){
        transpertantView.isHidden = true
        
    }
    
    
    //MARK:- checkOut Button Actions
    
    @objc func peakHoursBtnClicked(sender:UIButton)
    {
        popTip.arrowRadius = 0
        popTip.arrowRadius = 2
        //popTip.bubbleColor = UIColor(red: 0.31, green: 0.57, blue: 0.87, alpha: 1)
        let tempCard = self.cartTable.viewWithTag(1001)
        // popTip.show(text: "Peak hours delivery fee will be applicable\nExtra Charges : $0.0", direction: direction, maxWidth: 200, in: tempCard!, from: sender.frame)
        popTip.show(text: "\(peakHour_Info)\("\n")\("Extra Charges : ")\(peakCurrency)\(peakHourFee)", direction: direction, maxWidth: 200, in: tempCard!, from: sender.frame)
        
        //direction = direction.cycleDirection()
    }
    
    
    @objc func checkOutBtnTapped(sender:UIButton)
    {
        // set the Alert
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
        var msgStr = String()
        
        if (resultDict.object(forKey: "minimum_order_error")as! NSArray).count != 0 {
            let tempArray = (resultDict.object(forKey: "minimum_order_error") as! [String])
            msgStr = tempArray[0]
            _ = alert.showCustom("Message", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
        }else if (resultDict.object(forKey: "pre_order_error")as! NSArray).count != 0 {
            let tempArray = (resultDict.object(forKey: "pre_order_error") as! [String])
            msgStr = tempArray[0]
            _ = alert.showCustom("Message", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
        }else if (resultDict.object(forKey: "quantity_error")as! NSArray).count != 0 {
            let tempArray = (resultDict.object(forKey: "quantity_error") as! [String])
            msgStr = tempArray[0]
            _ = alert.showCustom("Message", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
        }else{
            let store_locationDict = NSMutableDictionary()
            var storeArray = NSMutableArray()
            storeArray = (resultDict.object(forKey: "store_locations")as! NSArray).mutableCopy() as! NSMutableArray
            store_locationDict.addEntries(from: (storeArray.object(at: 0)as! NSDictionary) as! [AnyHashable : Any])
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectAddressViewController") as! SelectAddressViewController
            nextViewController.storeName = store_locationDict.object(forKey: "store_name")as! String
            nextViewController.storeLocation = store_locationDict.object(forKey: "store_location")as! String
            let currency = Singleton.sharedInstance.MyCartModel.data.currencyCode as String
            let subTotal = Singleton.sharedInstance.MyCartModel.data.cartSubTotal as String
            let deliveryFee = Singleton.sharedInstance.MyCartModel.data.deliveryFee as String
            let grandTotal = Singleton.sharedInstance.MyCartModel.data.totalCartAmount as String
            let paypalTotal = resultDict.object(forKey: "total_cart_amount_usd")as! String
            let floatSubTotal = subTotal.replacingOccurrences(of: ",", with: "")
            let floatTotal = grandTotal.replacingOccurrences(of: ",", with: "")
            let floatDelivery = deliveryFee.replacingOccurrences(of: ",", with: "")
            exactSubTotalAmt = Float(floatSubTotal)!
            exactToatlAmt = Float(floatTotal)!
            exactDeliveryAmt = Float(floatDelivery)!
            payingSubTotal = currency + " " + subTotal
            payingDesliveryFee = currency + " " + deliveryFee
            payingTotalAmt = currency + " " + grandTotal
            payingPayPalTotalAmt = currency + " " + paypalTotal
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    
    //MARK:- Qunatity Button Actions
    @objc func QuantityPlusBtnTapped(sender:UIButton){
        let section = sender.tag / 100
        let row = sender.tag % 100
        let availableQuantity = Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[row].availableStock as Int
        var selectedQuantity = Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[row].cartQuantity as Int
        if availableQuantity > selectedQuantity
        {
            selectedQuantity = selectedQuantity + 1
            let cartId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[row].cartId)
            let sendQuantity = String(selectedQuantity)
            self.updateCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: cartId, quantity: sendQuantity)
        }else{
            self.showToastAlert(senderVC: self, messageStr: LanguageDictonary.value(forKey: "productisoutofstock") as! String)
        }
    }
    
    
    @objc func lessBtnTapped(sender:UIButton){
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        var selectedQuantity = Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[row].cartQuantity as Int
        if selectedQuantity > 1
        {
            selectedQuantity = selectedQuantity - 1
            let cartId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[row].cartId)
            let sendQuantity = String(selectedQuantity)
            self.updateCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: cartId, quantity: sendQuantity)
        }else{
            //self.showToastAlert(senderVC: self, messageStr: "Out of stock")
        }
    }
    
    
    func ConvertTojson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    @objc func removeFromCartBtnTapped(sender:UIButton)
    {
        self.showLoadingIndicator(senderVC: self)
        let section = sender.tag / 100
        let row = sender.tag % 100
        let cartId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[row].cartId)
        let Parse = CommomParsing()
        Parse.removeFromCart(lang: login_session.value(forKey: "Language") as? String ?? "es",cart_id: cartId, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                print (response)
                self.getCartData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                print(response.object(forKey: "message") as Any)
            }
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- Cart Updates
    func updateCart(lang:String,cart_id:String,quantity:String){
        let Parse = CommomParsing()
        Parse.updateCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: cart_id,quantity: quantity, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.getCartData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "code")as! String == "" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.showToastAlert(senderVC: self, messageStr: response.value(forKey: "message") as! String)
            }
        }, onFailure: {errorResponse in})
        self.showLoadingIndicator(senderVC: self)
        
    }
    
    
    
    //MARK:- PreOrder Picker
    @objc func DateAndTimePickerTapped(sender:UIButton)
    {
        let Index = sender.tag
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 0)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 10)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.is12HourFormat = true
        picker.includesMonth = true // if true the month shows at bottom of date cell
        picker.highlightColor = AppLightOrange
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = (LanguageDictonary.value(forKey: "pre-order") as? String)!
        //picker.dateTitleLabel.text = "Deliverees"
        
        picker.doneBackgroundColor = AppLightOrange
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd HH:mm"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let dateStr = formatter.string(from: date)
            print(dateStr)
            self.setOrderAsPreOrder(selectedIndex: Index,OrderedDate: dateStr)
        }
        picker.delegate = self
        picker.show()
    }
    
    @objc func removePreOrderButtonTapped(sender:UIButton)
    {
        let Index = sender.tag
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        let store_Id = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[Index].storeId)
        Parse.removePreOrder(lang: login_session.value(forKey: "Language") as? String ?? "es",store_id: store_Id, onSuccess: {
            response in
            print ("myOfferData :",response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.getCartData()
                return
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
    }
    
    //MARK:- 24 hours format change to 12 hours format
    func changeToHoursFormat(getDate:String) -> String
    {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm z"
        //        let dateFrom = dateFormatter.date(from: getDate)
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        // set locale to reliable US_POSIX
        //        let dateStr = dateFormatter.string(from: dateFrom!)
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let datecomponents = dateFormatter.date(from: getDate)
        let dateStr = dateFormatter.string(from: datecomponents!)
        return dateStr
    }
    
    //MARK:- Set Order as preOrder
    func setOrderAsPreOrder(selectedIndex:Int,OrderedDate:String)
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        let store_Id = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[selectedIndex].storeId)
        Parse.setPreOrder(lang: login_session.value(forKey: "Language") as? String ?? "es",store_id:store_Id,pre_order_date: OrderedDate , onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200
            {
                self.getCartData()
                return
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
            }
            self.stopLoadingIndicator(senderVC: self)
            
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- Delegate Method For when the Choice remove
    func showBGLoader() {
        self.showLoadingIndicator(senderVC: self)
    }
    
    func hideBGLoader() {
        self.stopLoadingIndicator(senderVC: self)
    }
    
    func reloadCartData() {
        self.getCartData()
    }
    
    @IBAction func popUpUpdateBtnAction(_ sender: UIButton) {
        transpertantView.isHidden = true
        self.showLoadingIndicator(senderVC: self)
        let cartId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].cartId)
        let productId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[EditExtrasSection].addedItemDetails[EditExtrasRow].productId)
        var choiceId = [Int]()
        if selectedCartChoiceArray.count != 0{
            let tempIds = selectedCartChoiceArray.value(forKey: "choice_id")as! NSArray
            for choice in tempIds{
                choiceId.append(choice as! Int)
            }
        }
        
        let Parse = CommomParsing()
        Parse.updateCartWithChoice(lang: login_session.value(forKey: "Language") as? String ?? "es",cart_id: cartId,product_id: productId,choice_id: choiceId,special_request:popUpNotesTxt.text!, onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200{
                self.getCartData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }
    
    @IBAction func popUpViewItemsBtnAction(_ sender: Any) {
    }
    
}

extension PopTipDirection {
    func cycleDirection() -> PopTipDirection {
        switch self {
        case .up:
            return .right
        case .right:
            return .down
        case .down:
            return .left
        case .left:
            return .up
        case .none:
            return .none
        case .auto:
            return .none
        case .autoHorizontal:
            return .none
        case .autoVertical:
            return .none
        }
    }
}
