//
//  RefundDetailsViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 26/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl


class RefundDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var noItemFoundLbl: UILabel!
    @IBOutlet weak var refundTable: UITableView!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var navigationTitlelbl: UILabel!
    @IBOutlet weak var topSegmentView: ScrollableSegmentedControl!
    
    //REFUND DETAILS
    @IBOutlet weak var refundBGView: UIView!
    @IBOutlet weak var refundPopupView: UIView!
    @IBOutlet weak var refundPopUpCloseBtn: UIButton!
    @IBOutlet weak var refundDateLbl: UILabel!
    @IBOutlet weak var refundTransactionIDLbl: UILabel!
    @IBOutlet weak var refundTransactionFeeLbl: UILabel!
    @IBOutlet weak var refundOfferAmntLbl: UILabel!
    @IBOutlet weak var refundDeliveryFeeLbl: UILabel!
    @IBOutlet weak var refundAmountLbl: UILabel!

    
    
    var pendingArray = NSMutableArray()
    var completedArray = NSMutableArray()
    var finalArray = NSMutableArray()
    var orderId = String()
    var resultsArray = NSMutableArray()
    var showingIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showingIndex = 0
        self.setSegmentData()
        self.orderDetailsAPICall()
        
        // Do any additional setup after loading the view.
        refundPopupView.layer.cornerRadius = 5.0
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
    }

    @IBAction func refundPopUpCloseBtnTapped(_ sender: Any) {
       refundBGView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitlelbl.text = LanguageDictonary.value(forKey: "refunddetails") as? String
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setSegmentData(){
        topSegmentView.segmentStyle = .textOnly
        topSegmentView.insertSegment(withTitle: LanguageDictonary.value(forKey: "pending") as! String, image: nil, at: 0)
        topSegmentView.insertSegment(withTitle:  LanguageDictonary.value(forKey: "completed") as! String, image: nil, at: 1)
        topSegmentView.underlineSelected = true
        topSegmentView.tintColor = AppDarkOrange
        topSegmentView.selectedSegmentContentColor = UIColor.black
        topSegmentView.selectedSegmentIndex = 0
        topSegmentView.fixedSegmentWidth = true
        topSegmentView.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        showingIndex = sender.selectedSegmentIndex
        finalArray.removeAllObjects()
        if showingIndex == 0 {
            finalArray.addObjects(from: pendingArray as! [Any])
        }else{
            finalArray.addObjects(from: completedArray as! [Any])
        }
        if finalArray.count == 0 {
            noItemFoundLbl.isHidden = false
        }else{
            noItemFoundLbl.isHidden = true
        }
        refundTable.reloadData()
        
    }
    
    func orderDetailsAPICall(){
        self.showLoadingIndicator(senderVC: self)
        self.pendingArray.removeAllObjects()
        self.completedArray.removeAllObjects()
        self.finalArray.removeAllObjects()
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getRefundDetails(lang: login_session.value(forKey: "Language") as? String ?? "es",order_id:orderId, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultsArray.addObjects(from: response.object(forKey: "data") as! [Any])
                self.setDataToArray()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    //MARK:- Result Divied as Two Arrays
    func setDataToArray()  {
        for data in resultsArray
        {
            let tempDict = data as! NSDictionary
            if tempDict.object(forKey: "refund_status") as! String == "Pending" || tempDict.object(forKey: "refund_status") as! String == "Pendiente"{
                pendingArray.add(tempDict)
            }else{
                completedArray.add(tempDict)
            }
        }
        finalArray.addObjects(from: pendingArray as! [Any])
        if finalArray.count == 0 {
            noItemFoundLbl.isHidden = false
        }else{
           noItemFoundLbl.isHidden = true
        }
        refundTable.reloadData()
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if showingIndex == 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundTableViewCell") as? RefundTableViewCell
        cell?.selectionStyle = .none
        cell?.baseContentView.layer.cornerRadius = 5.0
        cell?.baseContentView = self.setCornorShadowEffects(sender: (cell?.baseContentView)!)
        cell?.orderIDValueLbl.text = String(format: ": %@",(finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "transaction_id")as! String)
        cell?.itemNameValuelbl.text = String(format: ": %@", (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "item_name")as! String)
        let currency = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_currency")as! String
        let price = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_total")as! String
        cell?.itemAmtValueLbl.text = ": " + currency + " " + price
        cell?.cancelTypeValueLbl.text = String(format: ": %@",(finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "cancel_type")as! String)

        return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RefundCompletedTableViewCell") as? RefundCompletedTableViewCell
            cell?.selectionStyle = .none
            cell?.baseContentView.layer.cornerRadius = 5.0
            cell?.baseContentView = self.setCornorShadowEffects(sender: (cell?.baseContentView)!)
            cell?.orderIDValueLbl.text = String(format: ": %@",(finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "transaction_id")as! String)

            cell?.itemNameValuelbl.text = String(format: ": %@", (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "item_name")as! String)
            
            let currency = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_currency")as! String
            
            let price = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_total")as! String
            cell?.itemAmtValueLbl.text = ": " + currency + " " + price
            
            let refundPrice = (finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "refund_amount")as! String
            cell?.refundAmountlbl.text = ": " + " " + refundPrice

            cell?.cancelTypeValueLbl.text = String(format: ": %@",(finalArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "cancel_type")as! String)
            
            cell?.refundDetailsBtn.tag = indexPath.row
            cell?.refundDetailsBtn.addTarget(self,action:#selector(refundDetailsBtnClicked(sender:)), for: .touchUpInside)
            
            return cell!
        }
    }
    
    
    @objc func refundDetailsBtnClicked(sender:UIButton)
    {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        
        refundDateLbl.text = ": " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "refund_date")as! String)
        
        refundTransactionIDLbl.text = ": " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "transaction_id")as! String)
        
        refundTransactionFeeLbl.text = ": " + "- " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "commission")as! String)
        
        refundOfferAmntLbl.text = ": " + "- " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "order_currency")as! String) + " " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "offer_amt")as! String)
        
        refundDeliveryFeeLbl.text = ": " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "order_currency")as! String) + " " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "del_fee")as! String)
        
        refundAmountLbl.text = ": " + ((finalArray.object(at: buttonRow)as! NSDictionary).object(forKey: "refund_amount")as! String)
        
        refundBGView.isHidden = false
    }
    
}
