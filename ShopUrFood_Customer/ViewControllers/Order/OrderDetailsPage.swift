//
//  OrderDetailsPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 04/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import BottomPopup
import SWRevealViewController
import AVFoundation


class OrderDetailsPage: BaseViewController,UITableViewDelegate,UITableViewDataSource,BottomPopupDelegate {
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var noOrdersFoundLbl: UILabel!
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    var showIndex = Int()
    var resultDict = NSMutableDictionary()
    var orderId = String()
    var pendingArray = NSMutableArray()
    var fulfiledArray = NSMutableArray()
    var cancelledArray = NSMutableArray()
    var finalArray = NSMutableArray()
    var navigationTypeStr = String()
    var orderDateString = String()
    var orderisRejected = Bool()
    var isfromNotificationClick = Bool()
    var window: UIWindow?

    var order_amount:String = ""
    var grand_tax:String = ""
    var grand_total:String = ""
    var delivery_fee:String = ""
    var currencyStr:String = ""
    var wallet_amount:String = ""
    var offerUsed_amount:String = ""
    var cancelled_amount:String = ""

    
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var messageNameLbl: UILabel!
    @IBOutlet weak var subTitleNameLbl: UILabel!
    @IBOutlet weak var blackTransprantView: UIView!
    
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBAction func closeBtnAction(_ sender: Any)
    {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // showIndex = 0
        self.showLoadingIndicator(senderVC: self)
        self.orderDetailsAPICall()
        orderTable.delegate = self
        orderTable.dataSource = self
        CommonOrderStatusUpdateStr = ""
        
//        baseContentView.layer.cornerRadius = 5.0
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        blackTransprantView.backgroundColor  = BlackTranspertantColor
        self.noOrdersFoundLbl.text = LanguageDictonary.value(forKey: "norecordsfound") as? String
        self.segmentedControl.insertSegment(withTitle: LanguageDictonary.value(forKey: "pending") as? String, image: nil, at: 0)
        self.segmentedControl.insertSegment(withTitle: LanguageDictonary.value(forKey: "fulfilled") as? String, image: nil, at: 1)
        self.segmentedControl.insertSegment(withTitle: LanguageDictonary.value(forKey: "cancelled") as? String, image: nil, at: 2)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "trackorder") as? String
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        let soundURL = Bundle.main.url(forResource: "marimba_arpegio", withExtension: "aiff")
        do
        {
            appDelegate!.player = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch
        {
            print("No sound found by URL")
        }
        if appDelegate!.player.isPlaying
        {
            appDelegate!.playerStop()
            
            
        }
    }
    
    @IBAction func popUpCloseBtnTapped(_ sender: Any) {
        self.blackTransprantView.isHidden = true
    }
    func orderDetailsAPICall(){
        self.pendingArray.removeAllObjects()
        self.fulfiledArray.removeAllObjects()
        self.cancelledArray.removeAllObjects()
        self.finalArray.removeAllObjects()
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getOrderDetails(lang: login_session.value(forKey: "Language") as? String ?? "es",page_no: "1",order_id:orderId , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.currencyStr = self.resultDict.object(forKey: "currency") as! String
                self.order_amount = self.resultDict.object(forKey: "grand_sub_total") as! String
                self.delivery_fee = self.resultDict.object(forKey: "delivery_fee") as! String
                self.wallet_amount = self.resultDict.object(forKey: "wallet_used") as! String
                self.offerUsed_amount = self.resultDict.object(forKey: "offer_used") as! String
                self.grand_tax = self.resultDict.object(forKey: "grand_tax_total") as! String
                self.cancelled_amount = self.resultDict.object(forKey: "cancelled_item_amount") as! String
                self.grand_total = self.resultDict.object(forKey: "grand_total") as! String

                
                self.pendingArray.addObjects(from: (self.resultDict.object(forKey: "pending_details")as! NSArray) as! [Any])
                self.cancelledArray.addObjects(from: (self.resultDict.object(forKey: "cancelled_details")as! NSArray) as! [Any])
                self.fulfiledArray.addObjects(from: (self.resultDict.object(forKey: "fulfilled_details")as! NSArray) as! [Any])
                
                if self.orderisRejected == false
                {
                if self.pendingArray.count > 0
                {
                    self.showIndex = 0
                }
                else if self.fulfiledArray.count > 0
                {
                    self.showIndex = 1
                }
                else
                {
                    self.showIndex = 2
                }
                }
                else
                {
                    self.showIndex = 2
                }
                if self.showIndex == 0{
                    self.finalArray.addObjects(from: self.pendingArray as! [Any])
                }else if self.showIndex == 1 {
                    self.finalArray.addObjects(from: self.fulfiledArray as! [Any])
                }else{
                    self.finalArray.addObjects(from: self.cancelledArray as! [Any])
                }
                self.orderTable.reloadData()
                
                self.setSegmentData()

                if self.finalArray.count == 0 {
                    self.noOrdersFoundLbl.isHidden = false
                }else{
                    self.noOrdersFoundLbl.isHidden = true
                }
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if isfromNotificationClick == true
        {
            isfromNotificationClick = false
            
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
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SelectLocationPage")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        else
        {
        if navigationTypeStr == "present"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        }
    }
    
    func setSegmentData(){
        segmentedControl.segmentStyle = .textOnly
        DispatchQueue.main.async {
            self.segmentedControl.removeSegment(at: 0)
            self.segmentedControl.insertSegment(withTitle: "\("\(LanguageDictonary.value(forKey: "pending") as! String) (")\(self.pendingArray.count)\(")")", image: nil, at: 0)
            self.segmentedControl.removeSegment(at: 1)
            self.segmentedControl.insertSegment(withTitle: "\("\(LanguageDictonary.value(forKey: "fulfilled") as! String) (")\(self.fulfiledArray.count)\(")")", image: nil, at: 1)
            self.segmentedControl.removeSegment(at: 2)
            self.segmentedControl.insertSegment(withTitle: "\("\(LanguageDictonary.value(forKey: "cancelled") as! String) (")\(self.cancelledArray.count)\(")")", image: nil, at: 2)

//        if self.pendingArray.count == 0
//        {
//            self.segmentedControl.insertSegment(withTitle:"Pending", image: nil, at: 0)
//        }
//        else
//        {
//        self.segmentedControl.insertSegment(withTitle: "\("Pending (")\(self.pendingArray.count)\(")")", image: nil, at: 0)
//        }
//
//        if self.fulfiledArray.count == 0
//        {
//         self.segmentedControl.insertSegment(withTitle: "Fulfilled", image: nil, at: 1)
//        }
//        else
//        {
//        self.segmentedControl.insertSegment(withTitle: "\("Fulfilled (")\(self.fulfiledArray.count)\(")")", image: nil, at: 1)
//        }
//
//        if self.cancelledArray.count == 0
//        {
//        self.segmentedControl.insertSegment(withTitle: "Cancelled", image: nil, at: 2)
//        }
//        else
//        {
//        self.segmentedControl.insertSegment(withTitle: "\("Cancelled (")\(self.cancelledArray.count)\(")")", image: nil, at: 2)
//        }
        
        self.segmentedControl.underlineSelected = true
        self.segmentedControl.tintColor = AppDarkOrange
        self.segmentedControl.selectedSegmentContentColor = UIColor.black
            
            if self.orderisRejected == true
            {
                self.orderisRejected = false
                self.showIndex = 2
                self.segmentedControl.selectedSegmentIndex = 2
                
            }
            else
            {
            if self.pendingArray.count > 0
            {
                self.showIndex = 0
                self.segmentedControl.selectedSegmentIndex = 0
            }
            else if self.fulfiledArray.count > 0
            {
                self.showIndex = 1
                self.segmentedControl.selectedSegmentIndex = 1
            }
            else
            {
                self.showIndex = 2
                self.segmentedControl.selectedSegmentIndex = 2
            }
            }
        self.segmentedControl.fixedSegmentWidth = true
        self.segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        }
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        showIndex = sender.selectedSegmentIndex
        finalArray.removeAllObjects()
        if showIndex == 0 {
            finalArray.addObjects(from: pendingArray as! [Any])
        }else if showIndex == 1  {
            finalArray.addObjects(from: fulfiledArray as! [Any])
        }else if showIndex == 2 {
            finalArray.addObjects(from: cancelledArray as! [Any])
        }
        if finalArray.count == 0{
            noOrdersFoundLbl.isHidden = false
        }else{
            noOrdersFoundLbl.isHidden = true
        }
        orderTable.reloadData()
    }
    
    
    @objc func cancelOrderBtnTapped(sender:UIButton)
    {
        let orderId = ((finalArray.object(at: sender.tag) as! NSDictionary).object(forKey: "order_id")as! NSNumber).stringValue
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "CancelOrderPage") as? CancelOrderPage else { return }
        popupVC.height = 242
        popupVC.topCornerRadius = 30.0
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = true
        popupVC.OrderId = orderId
        popupVC.popupDelegate = self
        popupVC.dataDict.addEntries(from: (finalArray.object(at: sender.tag)as! NSDictionary) as! [AnyHashable : Any])
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func postItemReview(sender:UIButton)
    {
        let productId = ((finalArray.object(at: sender.tag) as! NSDictionary).object(forKey: "item_id")as! NSNumber).stringValue
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "ItemReviewPage") as? ItemReviewPage else { return }
        popupVC.height = 351
        popupVC.topCornerRadius = 30.0
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = true
        popupVC.product_id = productId
        popupVC.reviewType = "item"
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @objc func postStoreReview(sender:UIButton)
    {
        let store_id = ((finalArray.object(at: sender.tag) as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "ItemReviewPage") as? ItemReviewPage else { return }
        popupVC.height = 351
        popupVC.topCornerRadius = 30.0
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = true
        popupVC.store_id = store_id
        popupVC.reviewType = "store"
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
        var OldStore_id = String()
        var newStore_id = String()
        if indexPath.row != 0 {
            OldStore_id = String((finalArray.object(at: indexPath.row-1)as! NSDictionary).object(forKey: "restaurant_id")as! Int)
            newStore_id = String((finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! Int)
        }
        if indexPath.row == 0 || OldStore_id != newStore_id{
            return 160
        }else{
            return 120
            
            }
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if section == 0
         {
        if finalArray.count == 0
        {
            return 0
        }
        else
        {
            return finalArray.count
        }
        }
         else
         {
            if finalArray.count == 0
            {
                return 0
            }
            else
            {
                return 1
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
        var OldStore_id = String()
        var newStore_id = String()
        if indexPath.row != 0 {
            OldStore_id = String((finalArray.object(at: indexPath.row-1)as! NSDictionary).object(forKey: "restaurant_id")as! Int)
            newStore_id = String((finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! Int)
        }
        if indexPath.row == 0 || OldStore_id != newStore_id
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTitleCell") as? OrderDetailsTitleCell
            cell?.selectionStyle = .none
            cell?.trackBtn.setTitle(LanguageDictonary.value(forKey: "track") as? String, for: .normal)
            cell?.order_Cancel.setTitle(LanguageDictonary.value(forKey: "cancel") as? String, for: .normal)
            cell?.titleLbl.text  = ((finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String)
            cell?.status_titleLbl.text = LanguageDictonary.value(forKey: "status") as? String
            cell?.addStoreReviewBtn.setTitle(LanguageDictonary.value(forKey: "Addreview") as? String, for: .normal)
            cell?.trackBtn.layer.cornerRadius = 15.0
            cell?.trackBtn.clipsToBounds = true
            if showIndex == 1 {
                cell?.trackBtn.isHidden = true
                cell?.infoBtn.isHidden = true
                if ((finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "already_order_reviewed")as! String) == "No"{
                    cell?.addStoreReviewBtn.isHidden = false
                cell?.addStoreReviewBtn.addTarget(self, action: #selector(postStoreReview), for: .touchUpInside)
                }else{
                    cell?.addStoreReviewBtn.isHidden = true
                }
            }else if showIndex == 2{
                cell?.trackBtn.isHidden = true
                cell?.infoBtn.isHidden = true
                cell?.addStoreReviewBtn.isHidden = true

            }else{
                cell?.trackBtn.isHidden = false
                cell?.infoBtn.isHidden = false
                cell?.addStoreReviewBtn.isHidden = true
            }
            cell?.trackBtn.tag = indexPath.row
            cell?.infoBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell?.infoBtn.tag = indexPath.row
            cell?.infoBtn.addTarget(self, action: #selector(showCancellationPopUp), for: .touchUpInside)

            cell?.trackBtn.addTarget(self,action:#selector(trackBtnBtnClicked(sender:)), for: .touchUpInside)
            
            
            
            let foodImg = URL(string: (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "item_image") as! String)
            cell?.orderedFoodImg.kf.setImage(with: foodImg)
            cell?.nameLbl.text = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "item_name")as! String)
            let currency = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "item_currency")as! String)
            let price = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "item_amount")as! String)
            cell?.priceLbl.text = "\(currency)\(price)"
            cell?.statusValueLbl.text = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_status")as! String)
            cell?.orderedFoodImg.layer.cornerRadius = 10.0
            cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
            cell?.baseView.layer.borderWidth = 0.2
            cell?.baseView.layer.cornerRadius = 10.0
            cell?.baseView.layer.borderColor = UIColor.lightGray.cgColor
            cell?.order_Cancel.layer.cornerRadius = 5.0

            cell?.order_close.tag = indexPath.row
            cell?.order_close.isHidden = false
            
            cell?.order_Cancel.tag = indexPath.row
            cell?.order_Cancel.isHidden = false

            
            if showIndex == 0 {
                
                let orderDateStringPasser = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "pre_order_date") as? String
                
               /*
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                
                cell?.order_close.isHidden = true
                cell?.order_Cancel.isHidden = false
                //cell?.order_close.setImage(UIImage(named: "order_close"), for: .normal)

                if let date = dateFormatterGet.date(from: orderDateStringPasser!)
                {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                    
                }
                else
                {
                    print("There was an error decoding the string")
                }
                */
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                 dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                
                if let date = dateFormatterGet.date(from: orderDateStringPasser!) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }
 
                let dateStr = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "pre_order_date")as? String ?? (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_date")as? String
                
                if orderDateString == ""
                {
                    cell?.dateLbl.isHidden = true

                cell?.dateValueLbl.isHidden = true
                }
                else
                {
                    cell?.dateLbl.isHidden = false
                    //cell?.dateLbl.text = "Pre-Order Date"
                    cell?.dateLbl.text = LanguageDictonary.value(forKey: "preordereddate") as? String
                    cell?.dateValueLbl.isHidden = false
                    cell?.dateValueLbl.text = orderDateString
                }
                if ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "cancel_status")as! String) == "Can cancel"
                {
                   
                    cell?.order_Cancel.removeTarget(nil, action: nil, for: .allEvents)
                    cell?.order_Cancel.tag = indexPath.row
                    cell?.order_Cancel.addTarget(self,action:#selector(cancelOrderBtnTapped(sender:)), for: .touchUpInside)
                    cell?.order_Cancel.isHidden = false
                }
                else
                {
                    cell?.order_Cancel.isHidden = true
                    cell?.order_Cancel.isUserInteractionEnabled = false
                }
            }else if showIndex == 1 {
                
                cell?.order_close.isHidden = false
                cell?.order_Cancel.isHidden = true
                
                if (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "already_item_reviewed")as! String == "No"{
                    cell?.order_close.setImage(UIImage(named: "Add_review"), for: .normal)
                    cell?.order_close.addTarget(self,action:#selector(postItemReview), for: .touchUpInside)
                }else{
                    cell?.order_close.isHidden = true
                }
                
                let orderDateStringPasser = ((finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "delivered_date") as? String)!
                /*
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                if let date = dateFormatterGet.date(from: orderDateStringPasser!) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                }
                else {
                    print("There was an error decoding the string")
                }
                */
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                 dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                if let date = dateFormatterGet.date(from: orderDateStringPasser) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }

                let dateStr = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "delivered_date")as! String
                if orderDateString == ""
                {
                    cell?.dateValueLbl.isHidden = true
                    cell?.dateLbl.isHidden = true
                }
                else
                {
                    cell?.dateLbl.isHidden = false
                    //cell?.dateLbl.text = "Delivered Date"
                    cell?.dateLbl.text = LanguageDictonary.value(forKey: "delivereddate") as? String
                    cell?.dateValueLbl.isHidden = false
                    cell?.dateValueLbl.text = orderDateString
                }
            }else if showIndex == 2 {
                cell?.order_close.isHidden = false
                cell?.order_Cancel.isHidden = true

                cell?.order_close.setImage(UIImage(named: "gray_info"), for: .normal)
                cell?.order_close.removeTarget(nil, action: nil, for: .allEvents)
                cell?.order_close.tag = indexPath.row
                cell?.order_close.addTarget(self, action: #selector(showCancelReasonPopUp), for: .touchUpInside)
                
                let orderDateStringPasser = ((finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "cancelled_date") as? String)!
                
                /*
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                if let date = dateFormatterGet.date(from: orderDateStringPasser!) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                }
                else {
                    print("There was an error decoding the string")
                }*/
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                if let date = dateFormatterGet.date(from: orderDateStringPasser) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }

                
                let dateStr = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "cancelled_date")as? String
                if orderDateString == ""
                {
                    cell?.dateValueLbl.isHidden = true
                    cell?.dateLbl.isHidden = true
                }
                else
                {
                    cell?.dateLbl.isHidden = false
                    //cell?.dateLbl.text = "Cancelled Date"
                    cell?.dateLbl.text = LanguageDictonary.value(forKey: "cancelleddate") as? String
                    cell?.dateValueLbl.isHidden = false
                    cell?.dateValueLbl.text = orderDateString
                }
                if (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_type")as! String != "COD"{
                    cell?.statusValueLbl.text = "VIEW"
                }
            }
            
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTBCell") as? OrderDetailsTBCell
            cell?.selectionStyle = .none
            cell?.order_Cancel.setTitle(LanguageDictonary.value(forKey: "cancel") as? String, for: .normal)
            let foodImg = URL(string: (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "item_image") as! String)
            cell?.orderedFoodImg.kf.setImage(with: foodImg)
            cell?.nameLbl.text = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "item_name")as! String)
            let currency = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "item_currency")as! String)
            let price = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "item_amount")as! String)
            cell?.priceLbl.text = "\(currency)\(price)"
            cell?.statusValueLbl.text = ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_status")as! String)
            cell?.orderedFoodImg.layer.cornerRadius = 10.0
            cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
            cell?.baseView.layer.borderWidth = 0.2
            cell?.baseView.layer.cornerRadius = 10.0
            cell?.baseView.layer.borderColor = UIColor.lightGray.cgColor
            cell?.order_Cancel.layer.cornerRadius = 5.0
            
            cell?.order_close.tag = indexPath.row - 1
            cell?.order_close.isHidden = false

            cell?.order_Cancel.tag = indexPath.row - 1
            cell?.order_Cancel.isHidden = false

            
            if showIndex == 0 {
               
                cell?.order_Cancel.isHidden = false
                cell?.order_close.isHidden = true
                
                let orderDateStringPasser = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "pre_order_date") as? String
                
                /*
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                
                if let date = dateFormatterGet.date(from: orderDateStringPasser!)
                {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                }
                else
                {
                    print("There was an error decoding the string")
                }*/
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                 dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                if let date = dateFormatterGet.date(from: orderDateStringPasser!) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }

                let dateStr = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "pre_order_date")as? String ?? (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_date")as? String
                if orderDateString == ""
                {
                    cell?.dateValueLbl.isHidden = true
                    cell?.dateLbl.isHidden = true
                    
                }
                else
                {
                    cell?.dateLbl.isHidden = false
                    //cell?.dateLbl.text = "Pre-Order Date"
                    cell?.dateLbl.text = LanguageDictonary.value(forKey: "preordereddate") as? String
                    cell?.dateValueLbl.isHidden = false
                    cell?.dateValueLbl.text = orderDateString
                }
               // cell?.order_close.setImage(UIImage(named: "order_close"), for: .normal)

                if ((finalArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "cancel_status")as! String) == "Can cancel"{
                    cell?.order_Cancel.isHidden = false
                    cell?.order_Cancel.removeTarget(nil, action: nil, for: .allEvents)
                    cell?.order_Cancel.tag = indexPath.row
 cell?.order_Cancel.addTarget(self,action:#selector(cancelOrderBtnTapped(sender:)), for: .touchUpInside)

                }else{
                    cell?.order_Cancel.isHidden = true
                    cell?.order_Cancel.isUserInteractionEnabled = false

                }
            }else if showIndex == 1 {
                
                cell?.order_Cancel.isHidden = true
                cell?.order_close.isHidden = false

                
                if (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "already_item_reviewed")as! String == "No"{
                    cell?.order_close.setImage(UIImage(named: "Add_review"), for: .normal)
                    cell?.order_close.removeTarget(nil, action: nil, for: .allEvents)
                    cell?.order_close.tag = indexPath.row
                    cell?.order_close.addTarget(self,action:#selector(postItemReview), for: .touchUpInside)
                }else{
                    cell?.order_close.isHidden = true
                    cell?.order_close.isUserInteractionEnabled = false

                }
                
                let orderDateStringPasser = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "delivered_date") as? String
                
                /*
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                
                if let date = dateFormatterGet.date(from: orderDateStringPasser!)
                {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                    
                }
                else
                {
                    print("There was an error decoding the string")
                }
                */
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                  dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                  dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                if let date = dateFormatterGet.date(from: orderDateStringPasser!) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }
                
                let dateStr = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "delivered_date")as! String
                if orderDateString == ""
                {
                    cell?.dateValueLbl.isHidden = true
                    cell?.dateLbl.isHidden = true
                    
                }
                else
                {
                    cell?.dateLbl.isHidden = false
                    //cell?.dateLbl.text = "Delivered Date"
                    cell?.dateLbl.text = LanguageDictonary.value(forKey: "delivereddate") as? String
                    cell?.dateValueLbl.isHidden = false
                    cell?.dateValueLbl.text = orderDateString
                }

            }else if showIndex == 2 {
                cell?.order_Cancel.isHidden = true
                cell?.order_close.isHidden = false

                cell?.order_close.setImage(UIImage(named: "gray_info"), for: .normal)
                cell?.order_close.removeTarget(nil, action: nil, for: .allEvents)
                cell?.order_close.tag = indexPath.row
                cell?.order_close.addTarget(self, action: #selector(showCancelReasonPopUp), for: .touchUpInside)
                
                let orderDateStringPasser = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "cancelled_date") as? String
                
                /*
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                
                if let date = dateFormatterGet.date(from: orderDateStringPasser!)
                {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                    
                }
                else
                {
                    print("There was an error decoding the string")
                }
                */
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: LanguageDictonary.value(forKey: "localeID") as! String)
                dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                 dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                if let date = dateFormatterGet.date(from: orderDateStringPasser!) {
                    print(dateFormatterPrint.string(from: date))
                    orderDateString = dateFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }
                
                 let dateStr = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "cancelled_date")as? String
                if orderDateString == ""
                {
                    cell?.dateValueLbl.isHidden = true
                    cell?.dateLbl.isHidden = true
                    
                }
                else
                {
                    cell?.dateLbl.isHidden = false
                    //cell?.dateLbl.text = "Cancelled Date"
                    cell?.dateLbl.text = LanguageDictonary.value(forKey: "cancelleddate") as? String
                    cell?.dateValueLbl.isHidden = false
                    cell?.dateValueLbl.text = orderDateString
                }
                if (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_type")as! String != "COD"{
                    cell?.statusValueLbl.text = "VIEW"
                }
            }
            return cell!
          }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTotalWithWalletCell") as? InvoiceTotalWithWalletCell
            
            
            
            cell?.deliveryLbl.text = LanguageDictonary.value(forKey: "deliveryfee") as? String
            cell?.walletLbl.text = LanguageDictonary.value(forKey: "walletused") as? String
            cell?.offerUsedLbl.text = LanguageDictonary.value(forKey: "offerused") as? String
            cell?.cancelledLbl.text = LanguageDictonary.value(forKey: "cancelleditemtotal") as? String
            cell?.subTotalLbl.text = LanguageDictonary.value(forKey: "subtotal") as? String
            cell?.taxLbl.text = LanguageDictonary.value(forKey: "tax") as? String
            cell?.totalLbl.text = LanguageDictonary.value(forKey: "total") as? String
            
            
            
            
            
            cell?.selectionStyle = .none
            cell?.subTotalAmtLbl.text = self.currencyStr + " " + self.order_amount
            cell?.walletAmtLbl.text = "- " + self.currencyStr + " " + self.wallet_amount
            cell?.taxAmountLbl.text = self.currencyStr + " " + self.grand_tax
            cell?.offerUsedAmountLbl.text = "- " + self.currencyStr + " " + self.offerUsed_amount
            cell?.deliveryAmtlbl.text = self.currencyStr + " " + self.delivery_fee
            cell?.cancelledAmountLbl.text = "- " + self.currencyStr + " " + self.cancelled_amount
            cell?.totalValueLbl.text = self.currencyStr + " " + self.grand_total
            
            if self.wallet_amount == "0.00"
            {
                cell?.walletLblHeightConstraints.constant = 0
                cell?.walletAmtLblHeightConstraints.constant = 0
                cell?.walletLblTopHeightConstraints.constant = 0
                cell?.walletAmtLblTopHeightConstraints.constant = 0
            }
            else
            {
                cell?.walletLblTopHeightConstraints.constant = 17
                cell?.walletAmtLblTopHeightConstraints.constant = 17
                cell?.walletLblHeightConstraints.constant = 21
                cell?.walletAmtLblHeightConstraints.constant = 21
            }
            if self.offerUsed_amount == "0.00"
            {
                cell?.offerLblHeightConstraints.constant = 0
                cell?.offerAmtLblHeightConstraints.constant = 0
                cell?.offerLblTopHeightConstraints.constant = 0
                cell?.offerAmtLblTopHeightConstraints.constant = 0
                
            }
            else
            {
                cell?.offerLblHeightConstraints.constant = 21
                cell?.offerAmtLblHeightConstraints.constant = 21
                cell?.offerLblTopHeightConstraints.constant = 17
                cell?.offerAmtLblTopHeightConstraints.constant = 17
                
            }
            if self.grand_tax == "0.00"
            {
                cell?.taxLblHeightConstraints.constant = 0
                cell?.taxAmtLblHeightConstraints.constant = 0
                cell?.taxLblTopHeightConstraints.constant = 0
                cell?.taxAmtLblTopHeightConstraints.constant = 0
            }
            else
            {
                cell?.taxLblTopHeightConstraints.constant = 15
                cell?.taxAmtLblTopHeightConstraints.constant = 15
                cell?.taxLblHeightConstraints.constant = 21
                cell?.taxAmtLblHeightConstraints.constant = 21
                
            }
            
            if self.cancelled_amount == "0.00"
            {
            cell?.cancelLblHeightConstraints.constant = 0
            cell?.cancelAmtLblHeightConstraints.constant = 0
            cell?.cancelLblTopHeightConstraints.constant = 0
            cell?.cancelAmtLblTopHeightConstraints.constant = 0
            }
            else
            {
                cell?.cancelLblHeightConstraints.constant = 21
                cell?.cancelAmtLblHeightConstraints.constant = 21
                cell?.cancelLblTopHeightConstraints.constant = 17
                cell?.cancelAmtLblTopHeightConstraints.constant = 17
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showIndex == 2
        {
            if (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_type")as! String != "COD"{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RefundDetailsViewController") as! RefundDetailsViewController
                nextViewController.orderId = resultDict.object(forKey: "order_transaction_id")as! String
                self.present(nextViewController, animated:true, completion:nil)
            }

        }
    }
    
    @objc func trackBtnBtnClicked(sender:UIButton) {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        if navigationTypeStr == "present"{
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            //
            nextViewController.order_id = resultDict.object(forKey: "order_transaction_id")as! String
            nextViewController.store_id = ((finalArray.object(at: sender.tag) as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
            nextViewController.navigationTypeStr = navigationTypeStr
            self.present(nextViewController, animated:true, completion:nil)
        }else{
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            nextViewController.order_id = resultDict.object(forKey: "order_transaction_id")as! String
            nextViewController.store_id = ((finalArray.object(at: sender.tag) as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
            nextViewController.navigationTypeStr = navigationTypeStr
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @objc func showCancelReasonPopUp(sender:UIButton) {
        let index = sender.tag
        restaurantNameLbl.text = ((finalArray.object(at: index) as! NSDictionary).object(forKey: "restaurant_name")as! String)
        subTitleNameLbl.text = LanguageDictonary.object(forKey: "cancelreason") as? String
        messageNameLbl.text = (finalArray.object(at: index) as! NSDictionary).object(forKey: "cancelled_reason")as? String ?? ""
        if messageNameLbl.text == ""{
            messageNameLbl.text = (finalArray.object(at: index) as! NSDictionary).object(forKey: "failed_reason")as? String ?? ""
        }
        blackTransprantView.isHidden = false
        
    }
    
    @objc func showCancellationPopUp(sender:UIButton) {
        let index = sender.tag
        restaurantNameLbl.text = ((finalArray.object(at: index) as! NSDictionary).object(forKey: "restaurant_name")as! String)
        subTitleNameLbl.text = LanguageDictonary.object(forKey: "cancellationpolicy") as? String 
        messageNameLbl.text = (finalArray.object(at: index) as! NSDictionary).object(forKey: "cancel_policy")as? String
        blackTransprantView.isHidden = false
        
    }
    
    //MARK:- BottomPopUpDelegate
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        if CommonOrderStatusUpdateStr == "Cancelled"{
           // self.showIndex = 2
            self.orderDetailsAPICall()
            //segmentedControl.selectedSegmentIndex = 2
            CommonOrderStatusUpdateStr = ""
            
        }else if CommonOrderStatusUpdateStr == "reviewAdded"{
            //self.showIndex = 1
            self.orderDetailsAPICall()
            //segmentedControl.selectedSegmentIndex = 1
            CommonOrderStatusUpdateStr = ""
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }

}
