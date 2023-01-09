//
//  TrackViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CRRefresh
import Lottie
import BottomPopup


@available(iOS 11.0, *)
class TrackViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,BottomPopupDelegate {

    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var emptyMsgLbl: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var baseView: UIView!
    var resultsArray = NSMutableArray()
    var pagingIndex:Int = 1
    var firstTimeCalled = Bool()
    var maintainSelectedIndex = Int()

    
    @IBOutlet weak var orderHistoryGrayView: UIView!
    @IBOutlet weak var orderHistoryMessagePopUpView: UIView!
    @IBOutlet weak var orderHistoryOrangelineView: UIView!
    @IBOutlet weak var orderHistoryOKButton: UIButton!
    @IBOutlet weak var orderHistoryMessageLbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTimeCalled = true
        pagingIndex = 1
        self.OrderData()
        self.showLoadingIndicator(senderVC: self)
       
        baseView = self.setCornorShadowEffects(sender: baseView)
        baseView.layer.cornerRadius = 5.0
        orderTable.layer.cornerRadius = 5.0
        // set menu Button Action
        if revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width-80
            menuBtn.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
        
        orderHistoryOKButton.layer.cornerRadius = 20.0


    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitle.text = LanguageDictonary.value(forKey: "orderhistory") as? String
        if newOneOrderUpdated == "true"{
            newOneOrderUpdated = "false"
            pagingIndex = 1
        }
        if isfromPaymentSucessPage == true
        {
         isfromPaymentSucessPage = false
         self.OrderData()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        orderHistoryGrayView.isHidden = true
    }
    
    @IBAction func orderHistoryButtonAction(_ sender: Any)
    {
        orderHistoryGrayView.isHidden = true
        
    }

    
    //MARK:- API Methods
    func OrderData(){
       
        let Parse = CommomParsing()
        Parse.getMyOrderData(lang: login_session.value(forKey: "Language") as? String ?? "es",order_num: "",page_no: pagingIndex, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                if self.pagingIndex == 1 {
                    self.resultsArray.removeAllObjects()
                       }
                self.resultsArray.addObjects(from: (response.object(forKey: "data")as! NSDictionary).object(forKey: "orderArray") as! [Any])
                self.orderTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && self.pagingIndex == 1 {
                self.emptyMsgLbl.text = (response.object(forKey: "message")as! String)
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
        if firstTimeCalled{
            firstTimeCalled = false
        emptyView.isHidden = false
        let tempView = LOTAnimationView(name: "EmptyCart")
        tempView.frame = CGRect(x:0, y:0, width: 300, height: 300
        )
        animationView.addSubview(tempView)
        
        tempView.play()
        }
        
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
       // cell?.orderDateLbl.text = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderDate")as! String)
        
         let orderDateStringPasser = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderDate")as! String)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterPrint = DateFormatter()
        //dateFormatterPrint.locale = localeIdendifier as Locale
        dateFormatterPrint.locale = NSLocale(localeIdentifier: LanguageDictonary.value(forKey: "localeID") as! String) as Locale
        dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatterGet.date(from: orderDateStringPasser)
        {
            print(dateFormatterPrint.string(from: date))
            cell?.orderDateLbl.text = dateFormatterPrint.string(from: date)
            
        }
        
        
        let currency = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "ordCurrency")as! String)
        let amount = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderAmount")as! String)
        cell?.TotalAmtValueLbl.text = "\(currency)\(amount)"
        AmountStringToShowForCustomer = "\(currency)\(amount)"
        cell?.reOrderBtn.layer.cornerRadius = 16.0
        cell?.reOrderBtn.layer.borderWidth = 0.2
        cell?.reOrderBtn.layer.borderColor = AppDarkOrange.cgColor
        
        cell?.invoiceBtn.setTitle(LanguageDictonary.value(forKey: "invoice") as? String, for: .normal)
        cell?.orderIdLbl.text = LanguageDictonary.value(forKey: "orderid") as? String
        cell?.orderOnLbl.text = LanguageDictonary.value(forKey: "orderedon") as? String
        cell?.totalAmtLbl.text = LanguageDictonary.value(forKey: "totalamount") as? String
        cell?.trackBtn.setTitle(LanguageDictonary.value(forKey: "track") as? String, for: .normal)
        cell?.viewAllBtn.setTitle(LanguageDictonary.value(forKey: "viewall") as? String, for: .normal)
        cell?.reOrderBtn.setTitle(LanguageDictonary.value(forKey: "repeatorder") as? String, for: .normal)
        
        
        cell?.reOrderBtn.tag = indexPath.row
        cell?.reOrderBtn.addTarget(self, action: #selector(repeatOrderBtnTapped), for: .touchUpInside)

        cell?.baseView.layer.borderWidth = 0.2
        cell?.baseView.layer.borderColor = UIColor.lightGray.cgColor
        cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
        cell?.baseView.layer.cornerRadius = 10.0
        cell?.invoiceBtn.addTarget(self, action: #selector(invoiceBtnTapped), for: .touchUpInside)
        cell?.invoiceBtn.tag = indexPath.row
        cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
        cell?.viewAllBtn.tag = indexPath.row

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
    
    @objc func viewAllBtnTapped(sender:UIButton)
    {
        let index = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
        nextViewController.orderId = (resultsArray.object(at: index) as! NSDictionary).object(forKey: "orderId")as! String
        nextViewController.orderisRejected = false
        nextViewController.isfromNotificationClick = false
        nextViewController.navigationTypeStr = "push"
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func invoiceBtnTapped(sender:UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InvoiceViewController") as! InvoiceViewController
        nextViewController.order_id = (resultsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "orderId")as! String
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func repeatOrderBtnTapped(sender:UIButton)
    {
        
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        let order_id = ((resultsArray.object(at: sender.tag)as! NSDictionary).object(forKey: "orderId")as! String)
        Parse.setRepeatOrder(lang: login_session.value(forKey: "Language") as? String ?? "es",order_id:order_id , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                actAsBaseTabbar.selectedIndex = 0
//                self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.orderHistoryGrayView.isHidden = false
                self.orderHistoryMessageLbl.text = (response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
        nextViewController.orderId = (resultsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "orderId")as! String
        //self.present(nextViewController, animated:true, completion:nil)
        nextViewController.navigationTypeStr = "push"
        self.navigationController?.pushViewController(nextViewController, animated: true)
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
