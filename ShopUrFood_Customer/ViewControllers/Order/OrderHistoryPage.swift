//
//  OrderHistoryPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SWRevealViewController
import CRRefresh
import Lottie
import BottomPopup



@available(iOS 11.0, *)
class OrderHistoryPage: BaseViewController,UITableViewDelegate,UITableViewDataSource,BottomPopupDelegate {

    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var emptyMessageLbl: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var orderTable: UITableView!
    var resultsArray = NSMutableArray()
    var orderHistoryMessageArray = NSMutableArray()

    var pagingIndex = Int()
    
    @IBOutlet weak var orderHistoryGrayView: UIView!
    @IBOutlet weak var orderHistoryMessagePopUpView: UIView!
    @IBOutlet weak var orderHistoryOrangelineView: UIView!
    @IBOutlet weak var orderHistoryOKButton: UIButton!
    @IBOutlet weak var orderHistoryMessageLbl: UILabel!
    var maintainSelectedIndex = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        baseContentView.layer.cornerRadius = 5.0
        orderTable.layer.cornerRadius = 5.0
        
        self.showLoadingIndicator(senderVC: self)
        pagingIndex = 1
        self.OrderData()
        
        /// animator: your customize animator, default is NormalHeaderAnimator
        orderTable.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            /// start refresh
            self?.resultsArray.removeAllObjects()
            self?.pagingIndex = 1
            self?.OrderData()
        }
        
        orderHistoryGrayView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        orderHistoryGrayView.addGestureRecognizer(tap)
        orderHistoryGrayView.isUserInteractionEnabled = true
        self.view.addSubview(orderHistoryGrayView)

        orderHistoryMessagePopUpView.layer.cornerRadius = 8.0
        
        orderHistoryOrangelineView.clipsToBounds = true
        orderHistoryOrangelineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        orderHistoryOrangelineView.layer.cornerRadius = 6
        orderHistoryOrangelineView.layer.masksToBounds = true
        
        orderHistoryOKButton.layer.cornerRadius = 2 //20.0

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        orderHistoryGrayView.isHidden = true
    }

    @IBAction func orderHistoryButtonAction(_ sender: Any)
    {
        orderHistoryGrayView.isHidden = true

    }
    
    
    @IBAction func BtnAction(_ sender: Any) {
        //let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarController") as! UITabBarController
        actAsBaseTabbar.selectedIndex = 2 //tabBarSelectedIndex
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "orderhistory") as? String
        if isfromPaymentSucessPage == true
        {
        isfromPaymentSucessPage = false
        pagingIndex = 1
        self.OrderData()
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- API Methods
    func OrderData()
    {
        if pagingIndex == 1 {
            resultsArray.removeAllObjects()
        }

        let Parse = CommomParsing()
        Parse.getMyOrderData(lang: login_session.value(forKey: "Language") as? String ?? "es",order_num: "",page_no: pagingIndex, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultsArray.addObjects(from: (response.object(forKey: "data")as! NSDictionary).object(forKey: "orderArray") as! [Any])
                self.orderTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "No Orders available!" && self.pagingIndex == 1 {
                self.emptyMessageLbl.text = (response.object(forKey: "message")as! String)
                self.setNoitemFound()
            }
            else{
            }
            self.stopLoadingIndicator(senderVC: self)
            self.orderTable.cr.endHeaderRefresh()
            self.orderTable.cr.endLoadingMore()
        }, onFailure: {errorResponse in})
    }
    
    func setNoitemFound()  {
        emptyView.isHidden = false
        let tempView = LottieAnimationView(name: "EmptyCart")
        tempView.frame = CGRect(x:0, y:0, width: 300, height: 300
        )
        animationView.addSubview(tempView)
        
        tempView.play()
        
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as? OrderHistoryCell
        cell?.selectionStyle = .none
        cell?.orderIdValueLbl.text = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderId")as! String)
        cell?.orderDateLbl.text = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderDate")as! String)
        let currency = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "ordCurrency")as! String)
        let amount = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderAmount")as! String)
        cell?.TotalAmtValueLbl.text = "\(currency)\(amount)"
        AmountStringToShowForCustomer = "\(currency)\(amount)"
        
        cell?.invoiceBtn.setTitle(LanguageDictonary.value(forKey: "invoice") as? String, for: .normal)
        cell?.orderIdLbl.text = LanguageDictonary.value(forKey: "orderid") as? String
        cell?.orderOnLbl.text = LanguageDictonary.value(forKey: "orderedon") as? String
        cell?.totalAmtLbl.text = LanguageDictonary.value(forKey: "totalamount") as? String
        cell?.trackBtn.setTitle(LanguageDictonary.value(forKey: "track") as? String, for: .normal)
        cell?.viewAllBtn.setTitle(LanguageDictonary.value(forKey: "viewall") as? String, for: .normal)
        cell?.reOrderBtn.setTitle(LanguageDictonary.value(forKey: "repeatorder") as? String, for: .normal)
        
        cell?.trackBtn.layer.borderWidth = 2
        cell?.trackBtn.layer.borderColor = UIColor.red.cgColor
        cell?.trackBtn.setTitleColor(UIColor.red, for: .normal)
        cell?.trackBtn.layer.backgroundColor = UIColor.white.cgColor
        
        cell?.reOrderBtn.layer.cornerRadius = 2 //16.0
        cell?.reOrderBtn.layer.borderWidth = 0.2
        cell?.reOrderBtn.layer.borderColor = AppDarkOrange.cgColor
        cell?.baseView.layer.borderWidth = 0.2
        cell?.baseView.layer.borderColor = UIColor.lightGray.cgColor
        cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
        cell?.baseView.layer.cornerRadius = 10.0
        cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
        cell?.viewAllBtn.tag = indexPath.row

        cell?.invoiceBtn.addTarget(self, action: #selector(invoiceBtnTapped), for: .touchUpInside)
        cell?.invoiceBtn.tag = indexPath.row
        cell?.reOrderBtn.tag = indexPath.row
        cell?.reOrderBtn.addTarget(self, action: #selector(repeatOrderBtnTapped), for: .touchUpInside)
        if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderTrack")as! Int == 1{
            cell?.trackBtn.isHidden = false
            cell?.trackBtn.addTarget(self, action: #selector(trackOrderBtnTapped), for: .touchUpInside)
            cell?.trackBtn.tag = indexPath.row
        }else{
            cell?.trackBtn.isHidden = true
        }
        // Adding Bottom Load
        if indexPath.row == self.resultsArray.count - 1 && self.resultsArray.count % 10 == 0 {
            pagingIndex += 1
            self.OrderData()
            
        }
        return cell!
    }
    
    @objc func invoiceBtnTapped(sender:UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InvoiceViewController") as! InvoiceViewController
        nextViewController.order_id = (resultsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "orderId")as! String
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func viewAllBtnTapped(sender:UIButton)
    {
        let index = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
        nextViewController.orderId = (resultsArray.object(at: index) as! NSDictionary).object(forKey: "orderId")as! String
        nextViewController.navigationTypeStr = "present"
        nextViewController.orderisRejected = false
        nextViewController.isfromNotificationClick = false
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func trackOrderBtnTapped(sender:UIButton){
        let index = sender.tag
        maintainSelectedIndex = index
        if ((resultsArray.object(at: index)as! NSDictionary).object(forKey: "store_details")as! NSArray).count == 1{
            let tempArray = NSMutableArray()
            tempArray.addObjects(from: ((resultsArray.object(at: index)as! NSDictionary).object(forKey: "store_details")as! NSArray) as! [Any])
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            //
            nextViewController.order_id = ((resultsArray.object(at: index)as! NSDictionary).object(forKey: "orderId")as! String)
            nextViewController.store_id = (tempArray.object(at: 0)as! NSDictionary).object(forKey: "store_id")as! String
            nextViewController.navigationTypeStr = "present"
            self.present(nextViewController, animated:true, completion:nil)
            
        }else{
            guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryTrackingPopUpPage") as? OrderHistoryTrackingPopUpPage else { return }
            popupVC.height = 250
            popupVC.topCornerRadius = 30.0
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.shouldDismissInteractivelty = true
            popupVC.popupDelegate = self
            popupVC.dataArray.addObjects(from: ((resultsArray.object(at: index)as! NSDictionary).value(forKey: "store_details")as! NSArray) as! [Any])
            present(popupVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func repeatOrderBtnTapped(sender:UIButton)
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        let order_id = ((resultsArray.object(at: sender.tag)as! NSDictionary).object(forKey: "orderId")as! String)
        Parse.setRepeatOrder(lang: login_session.value(forKey: "Language") as? String ?? "es",order_id:order_id , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                actAsBaseTabbar.selectedIndex = 0
                self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.orderHistoryGrayView.isHidden = false
                self.orderHistoryMessageLbl.text = (response.object(forKey: "message")as! String)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "No items will be added in cart!" {
                actAsBaseTabbar.selectedIndex = 0
                self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
        nextViewController.orderId = (resultsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "orderId")as! String
        nextViewController.navigationTypeStr = "present"
        nextViewController.orderisRejected = false
        nextViewController.isfromNotificationClick = false
        self.present(nextViewController, animated:true, completion:nil)
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
        print("bottomPopupDidDismiss")
        if popUpToTrackingStatus == "allow"{
            let tempArray = NSMutableArray()
            tempArray.addObjects(from: ((resultsArray.object(at: maintainSelectedIndex)as! NSDictionary).object(forKey: "store_details")as! NSArray) as! [Any])
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            //
            nextViewController.order_id = ((resultsArray.object(at: maintainSelectedIndex)as! NSDictionary).object(forKey: "orderId")as! String)
            nextViewController.store_id = (tempArray.object(at: popUpToTrackingSelectedIndex)as! NSDictionary).object(forKey: "store_id")as! String
            nextViewController.navigationTypeStr = "present"
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
    
    
}
