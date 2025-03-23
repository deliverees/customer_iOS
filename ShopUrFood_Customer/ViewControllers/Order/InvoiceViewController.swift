//
//  InvoiceViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class InvoiceViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var navigationTitleLbl: UILabel!
    
    @IBOutlet var topNavigationView: UIView!
    @IBOutlet weak var InvoiceTable: UITableView!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var addressBGView: UIView!
    @IBOutlet weak var addressPopupView: UIView!
    @IBOutlet weak var addressNameLbl: UILabel!
    @IBOutlet weak var addressHeaderLabel: UILabel!
    @IBOutlet weak var addressTextLabel: UILabel!
    
    
    @IBOutlet weak var quantityBGView: UIView!
    @IBOutlet weak var quantityPopupView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var preorderDateValueLabel: UILabel!
    @IBOutlet weak var quantityValueLabel: UILabel!
    
    @IBOutlet weak var toppingsTableView: UITableView!
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var preorderDate: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var preorderDateLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var preorderDatevalueHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var toppingsTableviewHeightConstraints: NSLayoutConstraint!
    
    
    var toppingsArray = NSMutableArray()
    
    var order_id = String()
    var resultDict = NSMutableDictionary()
    var addressDict = NSMutableDictionary()
    var itemsArray = NSMutableArray()
    var totalStoreArray = NSMutableArray()
    
    var order_amount:String = ""
    var grand_tax:String = ""
    var managementFee: String?
    var grand_total:String = ""
    var delivery_fee:String = ""
    var currencyStr:String = ""
    var wallet_amount:String = ""
    var offerUsed_amount:String = ""
    var cancelled_amount:String = ""
    
    var useWallet = Bool()
    
    private var choicesAdapter: InvoiceDetailChoicesTableViewAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toppingsTableView.delegate = nil
        toppingsTableView.dataSource = nil
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "invoicedetails") as? String
        self.preorderDate.text = LanguageDictonary.value(forKey: "preorderdate") as? String
        self.quantityLbl.text = LanguageDictonary.value(forKey: "quantity") as? String
        
        self.addressHeaderLabel.text = LanguageDictonary.value(forKey: "address:") as? String
        self.showLoadingIndicator(senderVC: self)
        InvoiceTable.delegate = self
        InvoiceTable.dataSource = self
        InvoiceTable.rowHeight = UITableView.automaticDimension
        InvoiceTable.estimatedRowHeight = UITableView.automaticDimension
        InvoiceTable.estimatedRowHeight = 105
        
        useWallet = false
        
        addressBGView.isHidden = true
        addressPopupView.layer.cornerRadius = 8.0
        addressPopupView.layer.masksToBounds = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addressBGView.addGestureRecognizer(tap1)
        addressBGView.isUserInteractionEnabled = true
        self.view.addSubview(addressBGView)
        
        quantityBGView.isHidden = true
        quantityPopupView.layer.cornerRadius = 8.0
        quantityPopupView.layer.masksToBounds = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        quantityBGView.addGestureRecognizer(tap2)
        quantityBGView.isUserInteractionEnabled = true
        self.view.addSubview(quantityBGView)
        
        self.GetData()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        addressBGView.isHidden = true
    }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        quantityBGView.isHidden = true
        choicesAdapter = nil
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- API Methods
    func GetData(){
        let Parse = CommomParsing()
        Parse.getCustomerInvoice(lang: login_session.value(forKey: "Language") as? String ?? "es",order_id: order_id, onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200
            {
                self.resultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                print("INVOICE DATA : ",self.resultDict)
                self.order_amount = self.resultDict.value(forKey: "grand_sub_total") as! String
                self.grand_tax = self.resultDict.value(forKey: "grand_tax_total") as! String
                self.grand_total = self.resultDict.value(forKey: "grand_total") as! String
                self.managementFee = self.resultDict.value(forKey: "management_fee") as? String
                self.delivery_fee = self.resultDict.value(forKey: "delivery_fee") as! String
                self.cancelled_amount = self.resultDict.value(forKey: "cancelled_item_amount") as! String
                
                self.currencyStr = self.resultDict.value(forKey: "currency") as! String
                
                
                self.offerUsed_amount = self.resultDict.value(forKey: "offer_used") as! String
                self.wallet_amount = self.resultDict.value(forKey: "wallet_used") as! String
                
                if (self.resultDict.value(forKey: "wallet_used") as! String != "0.00")
                {
                    self.useWallet = true
                    self.wallet_amount = self.resultDict.value(forKey: "wallet_used") as! String
                }
                else
                {
                    self.useWallet = false
                }
                
                self.addressDict.addEntries(from: self.resultDict.object(forKey: "customerDetailArray") as! [AnyHashable : Any])
                let tempArray = self.resultDict.object(forKey: "order_detailArray") as! NSArray
                self.totalStoreArray = tempArray.mutableCopy() as! NSMutableArray
                self.InvoiceTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        totalStoreArray.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultDict.object(forKey: "customerDetailArray") != nil{
            if section == 0 || section == 1 || section == totalStoreArray.count + 2 {
                return  1
            }else{
                return ((totalStoreArray.object(at: section-2)as! NSDictionary).object(forKey: "item_lists")as! NSArray).count+1
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Invoice_addressCell") as? Invoice_addressCell
            cell?.selectionStyle = .none
            cell?.addressNameLbl.text = (addressDict.object(forKey: "customeName") as? String)
            cell?.deliveryAddress_titleLbl.text = LanguageDictonary.value(forKey: "deliveryaddress") as? String
            cell?.contact_number_title.text = LanguageDictonary.value(forKey: "contactnumber") as? String
            cell?.emailAddress_titleLbl.text = LanguageDictonary.value(forKey: "emailaddress") as? String
            
            let addressOne  = (addressDict.object(forKey: "customerAddress2") as? String) ?? ""
            let addressTwo = (addressDict.object(forKey: "customerAddress1") as? String) ?? ""
            cell?.address_valueLbl.text = addressOne + "\n" + addressTwo
            cell?.mobileNumberLbl.text = (addressDict.object(forKey: "customerMobile") as! String)
            cell?.emailValueLbl.text = (addressDict.object(forKey: "customerEmail") as! String)
            cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
            cell?.baseView.layer.cornerRadius = 5.0
            return cell!
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Invoice_order_detailsTBCell") as? Invoice_order_detailsTBCell
            
            cell?.orderTitleLbl.text = LanguageDictonary.value(forKey: "orderdetail") as? String
            cell?.orderNumber_titleLbl.text = LanguageDictonary.value(forKey: "ordernumber") as? String
            cell?.orderDate_titleLbl.text = LanguageDictonary.value(forKey: "orderdate") as? String
            cell?.payment_titleLbl.text = LanguageDictonary.value(forKey: "payment") as? String
            cell?.orderTypeLbl.text = LanguageDictonary.value(forKey: "ordertype") as? String
            cell?.paymentStatusLbl.text = LanguageDictonary.value(forKey: "paymentstatus") as? String
            cell?.orderNumberValueLbl.text = (resultDict.object(forKey: "order_id") as! String)
            cell?.orderDate_valueLbl.text = (resultDict.object(forKey: "order_date") as! String)
            cell?.paymentValueLbl.text = (resultDict.object(forKey: "paytype") as! String)
            cell?.paymentStatusValueLbl.text = (resultDict.object(forKey: "payment_status") as! String)
            
            if String (resultDict.object(forKey: "self_pickup") as! Int) == "0"
            {
                cell?.orderTypeValueLbl.text = "Delivery"
            }
            else
            {
                cell?.orderTypeValueLbl.text = LanguageDictonary.value(forKey: "selfpickup") as? String
                
            }
            cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
            cell?.baseView.layer.cornerRadius = 5.0
            cell?.selectionStyle = .none
            return cell!
        }
        else if indexPath.section == totalStoreArray.count + 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTotalWithWalletCell") as? InvoiceTotalWithWalletCell
            cell?.selectionStyle = .none
            
            cell?.deliveryLbl.text = LanguageDictonary.value(forKey: "deliveryfee") as? String
            cell?.walletLbl.text = LanguageDictonary.value(forKey: "walletused") as? String
            cell?.offerUsedLbl.text = LanguageDictonary.value(forKey: "offerused") as? String
            cell?.cancelledLbl.text = LanguageDictonary.value(forKey: "cancelleditemtotal") as? String
            cell?.subTotalLbl.text = LanguageDictonary.value(forKey: "subtotal") as? String
            cell?.managmenetFeeLbl.text = Localization.value(for: "managementFee")
            cell?.taxLbl.text = LanguageDictonary.value(forKey: "tax") as? String
            cell?.totalLbl.text = LanguageDictonary.value(forKey: "total") as? String
            
            
            cell?.subTotalAmtLbl.text = self.currencyStr + " " + self.order_amount
            cell?.walletAmtLbl.text = "- " + self.currencyStr + " " + self.wallet_amount
            cell?.taxAmountLbl.text = self.currencyStr + " " + self.grand_tax
            cell?.offerUsedAmountLbl.text = "- " + self.currencyStr + " " + self.offerUsed_amount
            cell?.deliveryAmtlbl.text = self.currencyStr + " " + self.delivery_fee
            cell?.managementFeeAmountLbl.text = self.currencyStr + " " + (self.managementFee ?? "")
            cell?.cancelledAmountLbl.text = "- " + self.currencyStr + " " + self.cancelled_amount
            cell?.totalValueLbl.text = self.currencyStr + " " + self.grand_total
            
            cell?.walletLbl.superview?.isHidden = self.wallet_amount == "0.00"
            cell?.offerUsedLbl.superview?.isHidden = self.offerUsed_amount == "0.00"
            cell?.taxLbl.superview?.isHidden = self.grand_tax == "0.00"
            cell?.cancelledLbl.superview?.isHidden = self.cancelled_amount == "0.00"
            cell?.managmenetFeeLbl.superview?.isHidden = self.managementFee == nil || self.managementFee == "0.00"
            
            return cell!
            
        }else {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Invoice_Item_titleTBCell") as? Invoice_Item_titleTBCell
                cell?.restaurantNameLbl.text = ((totalStoreArray.object(at: indexPath.section-2)as! NSDictionary).object(forKey: "store_name")as! String)
                cell?.selectionStyle = .none
                cell?.infoBtn.tag = indexPath.section-2
                cell?.infoBtn.addTarget(self,action:#selector(infoButtonClicked(sender:)), for: .touchUpInside)
                
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Invoice_Item_cell") as? Invoice_Item_cell
                cell?.selectionStyle = .none
                let indexDict = NSMutableDictionary()
                let itemArray = (totalStoreArray.object(at: indexPath.section-2)as! NSDictionary).object(forKey: "item_lists")as! NSArray
                var tempArray = NSMutableArray()
                tempArray = itemArray.mutableCopy() as! NSMutableArray
                indexDict.addEntries(from: (tempArray.object(at: indexPath.row-1)as! NSDictionary) as! [AnyHashable : Any])
                let foodImg = URL(string: indexDict.object(forKey: "pdt_image")as! String)
                cell?.food_image.kf.setImage(with: foodImg)
                cell?.foodNameLbl.text = (indexDict.object(forKey: "item_name")as! String)
                let currency = (indexDict.object(forKey: "ord_currency")as! String)
                let price = (indexDict.object(forKey: "ord_unit_price")as! String)
                let qtyStr = (indexDict.object(forKey: "ord_quantity")as! NSNumber).stringValue
                cell?.foodPriceLbl.text = "\(currency)\(price)"
                cell?.qtyButton.setTitle("Qty:\(qtyStr)", for: .normal)
                let section = indexPath.section-2
                let row = indexPath.row-1
                cell!.qtyButton.tag = (section*100)+row
                cell?.qtyButton.addTarget(self,action:#selector(qtyButtonClicked(sender:)), for: .touchUpInside)
                
                
                return cell!
            }
        }
    }
    
    @objc func infoButtonClicked(sender:UIButton)
    {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        addressBGView.isHidden = false
        addressNameLbl.text = ((totalStoreArray.object(at: buttonRow)as! NSDictionary).object(forKey: "store_name")as! String)
        addressTextLabel.text = ((totalStoreArray.object(at: buttonRow)as! NSDictionary).object(forKey: "store_location")as! String)
        
    }
    
    @objc func qtyButtonClicked(sender:UIButton)
    {
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        let buttonRow = sender.tag
        print("section is:",section)
        print("row is:",row)
        
        quantityBGView.isHidden = false
        
        let indexDict = NSMutableDictionary()
        let itemArray = (totalStoreArray.object(at: section)as! NSDictionary).object(forKey: "item_lists")as! NSArray
        var tempArray = NSMutableArray()
        tempArray = itemArray.mutableCopy() as! NSMutableArray
        indexDict.addEntries(from: (tempArray.object(at: row)as! NSDictionary) as! [AnyHashable : Any])
        let choicesDict = indexDict.object(forKey: "choice") as? [[String: Any]] ?? []
        let choicesTwoDict = indexDict.object(forKey: "choiceTwo") as? [[String: Any]] ?? []
        let choicesThreeDict = indexDict.object(forKey: "choiceThree") as? [[String: Any]] ?? []
        if choicesDict.isEmpty && choicesTwoDict.isEmpty && choicesThreeDict.isEmpty {
            toppingsTableView.reloadData()
            toppingsTableView.isHidden = true
            toppingsTableviewHeightConstraints.constant = 0
        }
        else {
            toppingsTableView.isHidden = false
            toppingsTableviewHeightConstraints.constant = 94
            let toppingsAdapter = InvoiceDetailChoicesTableViewAdapter(
                titleOne: indexDict.object(forKey: "pro_title_choice") as? String,
                titleTwo: indexDict.object(forKey: "pro_titleTwo_choice") as? String,
                titleThree: indexDict.object(forKey: "pro_titleThree_choice") as? String,
                dictionaryChoices: choicesDict,
                dictionaryChoicesTwo: choicesTwoDict,
                dictionaryChoicesThree: choicesThreeDict)
            self.choicesAdapter = toppingsAdapter
            toppingsTableView.delegate = toppingsAdapter
            toppingsTableView.dataSource = toppingsAdapter
            toppingsTableView.reloadData()
            toppingsTableviewHeightConstraints.constant = min(toppingsTableView.contentSize.height, 180)
        }
        let currency = (indexDict.object(forKey: "ord_currency")as! String)
        let price = (indexDict.object(forKey: "ord_unit_price")as! String)
        let qtyStr = String (indexDict.object(forKey: "ord_quantity")as! Int)
        
        itemNameLbl.text = (indexDict.object(forKey: "item_name") as! String)
        priceValueLabel.text = "\(currency)\(price)"
        taxValueLabel.text = (indexDict.object(forKey: "ord_tax_amt") as! String)
        
        if (indexDict.object(forKey: "pre_order_date") as! String) == "-"
        {
            preorderDateLblHeightConstraints.constant = 0
            preorderDatevalueHeightConstraints.constant = 0
        }
        else
        {
            preorderDateLblHeightConstraints.constant = 16.5
            preorderDatevalueHeightConstraints.constant = 17
            preorderDateValueLabel.text = (indexDict.object(forKey: "pre_order_date") as! String)
        }
        quantityValueLabel.text = qtyStr
        
    }
    
}

fileprivate struct InvoiceChoice {
    enum ChoiceType {
        case one
        case two
        case three
    }
    var choiceName: String = ""
    var choiceAmount: String = ""
    var choiceType: ChoiceType = .one
    
    init(dictionary: [String: Any]) {
        var choiceAmountKey = "choice_amount"
        if let name = dictionary["choicename"] as? String {
            choiceName = name
            choiceType = .one
        } else if let name = dictionary["choiceTwoname"] as? String {
            choiceName = name
            choiceType = .two
            choiceAmountKey = "choiceTwo_amount"
        } else if let name = dictionary["choiceThreename"] as? String {
            choiceName = name
            choiceType = .three
            choiceAmountKey = "choiceThree_amount"
        }
        if let amountString = dictionary[choiceAmountKey] as? NSNumber {
            choiceAmount = String(format: "%.2f", amountString.doubleValue)
        }
    }
    
    var isOne: Bool {
        choiceType == .one
    }
    
    var isTwo: Bool {
        choiceType == .two
    }
    
    var isThree: Bool {
        choiceType == .three
    }
}

fileprivate final class InvoiceDetailChoicesTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var titleOne: String = ""
    private var titleTwo: String = ""
    private var titleThree: String = ""
    private var choices: [InvoiceChoice] = []
    private var sectionedChoices: [[InvoiceChoice]] {
        [choices.filter(\.isOne),choices.filter(\.isTwo), choices.filter(\.isThree)]
            .filter({ !$0.isEmpty })
    }
    
    init(
        titleOne: String?,
        titleTwo: String?,
        titleThree: String?,
        dictionaryChoices: [[String: Any]],
        dictionaryChoicesTwo: [[String: Any]],
        dictionaryChoicesThree: [[String: Any]]) {
            self.titleOne = titleOne ?? ""
            self.titleTwo = titleTwo ?? ""
            self.titleThree = titleThree ?? ""
            let choices = dictionaryChoices.map({ InvoiceChoice(dictionary: $0) })
            self.choices.append(contentsOf: choices)
            let choicesTwo = dictionaryChoicesTwo.map({ InvoiceChoice(dictionary: $0) })
            self.choices.append(contentsOf: choicesTwo)
            let choicesThree = dictionaryChoicesThree.map({ InvoiceChoice(dictionary: $0) })
            self.choices.append(contentsOf: choicesThree)
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionedChoices.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionedChoices[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingsTableViewCell") as? ToppingsTableViewCell
        cell?.selectionStyle = .none
        let choice = sectionedChoices[indexPath.section][indexPath.row]
        cell?.toppingsValueLbl.text = choice.choiceName + " : " + choice.choiceAmount
        return cell!
    }
    
    private func titleForSection(_ section: Int) -> String {
        switch section {
        case 0:
            if !choices.filter(\.isOne).isEmpty {
                return titleOne
            } else if !choices.filter(\.isTwo).isEmpty {
                return titleTwo
            } else {
                return titleThree
            }
        case 1:
            if !choices.filter(\.isTwo).isEmpty {
                return titleTwo
            } else {
                return titleThree
            }
        case 2:
            return titleThree
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white
        let label = UILabel()
        
        label.text = titleForSection(section)
        label.textColor = UIColor.black
        label.font = UIFont.truenoRegular(size: 14)
        header.addSubview(label)
        header.frame = CGRect()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalToConstant: tableView.frame.width - 20)
        ])
        return header
    }
}
