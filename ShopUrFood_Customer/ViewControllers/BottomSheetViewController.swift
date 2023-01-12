//
//  BottomSheetViewController.swift
//  ShopUrGrocery_Customer
//
//  Created by apple5 on 25/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Alamofire
import CocoaMQTT
import SCLAlertView

enum SheetLevel{
    case top, bottom, middle
}

protocol BottomSheetDelegate {
   func updateBottomSheet(status:String)
    func sendLatLang(deliverylatitude:String, deliverylongitude:String, storelatitude:String, storelongitude:String, customerlatitude:String, customerlongitude:String, customerAddressString:String)
}

class BottomSheetViewController: BaseViewController {
    
    
    @IBOutlet var panView: UIView!
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var infoPopView: UIView!
    @IBOutlet weak var infoCloseBtn: UIButton!
    @IBOutlet weak var infoNameTxt: UITextField!
    @IBOutlet weak var infoPhone1Txt: UITextField!
    @IBOutlet weak var infoPhone2Txt: UITextField!
    @IBOutlet weak var infoAddressTxt: UITextField!
    @IBOutlet weak var infoCallBtn: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var paidAmtLbl: UILabel!
    @IBOutlet weak var dropDownBtn: UIButton!
    var restaurant_id = String()
    @IBOutlet weak var contentTblHeight: NSLayoutConstraint!
    
    
    var lastY: CGFloat = 0
    var pan: UIPanGestureRecognizer!
    
    var bottomSheetDelegate: BottomSheetDelegate?
    var parentView: UIView!
    
    var initalFrame: CGRect!
    var topY: CGFloat = 80 //change this in viewWillAppear for top position
    var middleY: CGFloat = 400 //change this in viewWillAppear to decide if animate to top or bottom
    var bottomY: CGFloat = 600 //no need to change this
    let bottomOffset: CGFloat = 64 //sheet height on bottom position
    var lastLevel: SheetLevel = .middle //choose inital position of the sheet
    
    var disableTableScroll = false
    var OnceAllowedDeliveryPage = Bool()
    
    //hack panOffset To prevent jump when goes from top to down
    var panOffset: CGFloat = 0
    var applyPanOffset = false
    
    //tableview variables
    var listItems: [Any] = []
    var headerItems: [Any] = []
    
    var deliveryPersonDetailsDict = NSDictionary()
    var deliveryBoyLatitude: String = ""
    var deliveryBoyLongitude: String = ""
    var orderStatusTypeString: String = ""
    var deliverAssignedString = String()
    var deliverIdString = String()
    var deliverImageString = String()
    var deliverMobileString = String()
    var deliverNameString = String()
    var restaurantLatitude: String = ""
    var restaurantLongitude: String = ""
    var restaurantNameString = String()
    var customerLatitude: String = ""
    var customerLongitude: String = ""
    var customerIdValue = NSNumber()
    var customerMobileNumbe1String = String()
    var customerAddress1String = String()
    var customerAddressString:String?
    var customerEmailString = String()
    var customerNameString = String()
    var topStatusStr : String = ""
    var restaurantDetailsDict = NSDictionary()
    
    var apiStoreIdString = String()
    var apiOrderIdString = String()
    
    var orderTrackingDict = NSDictionary()
    var statusDetailsArray = NSArray()
    var orderStatusStaticIconArray = NSArray()
    var orderStatusArray = NSMutableArray()
    var orderStatusStaticArray = NSArray()
    var customerDetailsDict = NSDictionary()
    var storeDetailsDict = NSDictionary()
    var payTypeString = String()
    var iPhoneUDIDString = String()
    let defaultHost = "35.154.220.4"
    
    var customer_orderId = String()
    var customer_storeId = String()
    var mqtt: CocoaMQTT!
    
    var mqttGetDict = NSDictionary()
    
    var cust_Timer:Timer? = nil {
        willSet {
            cust_Timer?.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.isHidden = true
        OnceAllowedDeliveryPage = true
        infoPopView.layer.cornerRadius = 8.0
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        print("iPhoneUDIDString UUID is : \(iPhoneUDIDString)")
        
//        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        pan.delegate = self
//        self.panView.addGestureRecognizer(pan)
//
//        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        
        //Bug fix #5. see https://github.com/OfTheWolf/UBottomSheet/issues/5
        //Tableview didselect works on second try sometimes so i use here a tap gesture recognizer instead of didselect method and find the table row tapped in the handleTap(_:) method
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
//        tap.delegate = self
//        tableView.addGestureRecognizer(tap)
        //Bug fix #5 end
        
        orderStatusStaticIconArray = [UIImage(named:"ic_order_recieved")!,UIImage(named:"ic_order_confirmed")!,UIImage(named:"ic_order_pickedup")!,UIImage(named:"ic_dispatched")!,UIImage(named:"ic_started")!,UIImage(named:"ic_arrived")!,UIImage(named:"ic_delivered")!,UIImage(named:"ic_deliver_cancel")!]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        infoCallBtn.layer.cornerRadius = 20
        infoNameTxt.layer.cornerRadius = 5
        infoPhone1Txt.layer.cornerRadius = 5
        infoPhone2Txt.layer.cornerRadius = 5
        infoAddressTxt.layer.cornerRadius = 5
        infoPhone1Txt.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        infoPhone2Txt.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        infoAddressTxt.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        
        orderTrackingApiCall()
        dropDownBtn.addTarget(self,action:#selector(orderStatusBtnClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func orderStatusBtnClicked(sender:UIButton) {
        if topStatusStr == ""{
            topStatusStr = "top"
            bottomSheetDelegate?.updateBottomSheet(status: "top")
        }else if topStatusStr == "top"{
            topStatusStr = "bottom"
            bottomSheetDelegate?.updateBottomSheet(status: "bottom")
        }else{
           topStatusStr = "top"
            bottomSheetDelegate?.updateBottomSheet(status: "top")
        }
        
    }
    
    // MARK: MQTT SetUp
    func mqttSetting() {
        let clientID = "\(iPhoneUDIDString)-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 1883)
        mqtt!.keepAlive = 60
        mqtt.connect()
        globalmqtt = mqtt
        mqtt!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initalFrame = UIScreen.main.bounds
        self.topY = round(initalFrame.height * 0.05)
        self.middleY = initalFrame.height * 0.6
        self.bottomY = initalFrame.height - bottomOffset
        self.lastY = self.middleY
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView == tableView else {return}
//
//        if (self.parentView.frame.minY > topY){
//            self.tableView.contentOffset.y = 0
//        }
    }
    
    
    //this stops unintended tableview scrolling while animating to top
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard scrollView == tableView else {return}
//
//        if disableTableScroll{
//            targetContentOffset.pointee = scrollView.contentOffset
//            disableTableScroll = false
//        }
    }
    
    //Bug fix #5. see https://github.com/OfTheWolf/UBottomSheet/issues/5
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        let p = recognizer.location(in: self.tableView)
        let index = tableView.indexPathForRow(at: p)
        //WARNING: calling selectRow doesn't trigger tableView didselect delegate. So handle selected row here.
        //You can remove this line if you dont want to force select the cell
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
    }//Bug fix #5 end
    
    
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> SheetLevel{
        let y = self.lastY
        let velY = recognizer.velocity(in: self.view).y
        if velY < -200{
            return y > middleY ? .middle : .top
        }else if velY > 200{
            return y < (middleY + 1) ? .middle : .bottom
        }else{
            if y > middleY {
                return (y - middleY) < (bottomY - y) ? .middle : .bottom
            }else{
                return (y - topY) < (middleY - y) ? .top : .middle
            }
        }
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
            self.mqtt.disconnect()
            globalmqtt.disconnect()
        }
        
        let icon = UIImage(named:"warning")
        let color = AppLightOrange
        
        _ = alert.showCustom("Warning", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    @objc func infoBtnClicked(sender:UIButton) {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        greyView.isHidden = false
        infoPopView.isHidden = false
    }
    
    // MARK: Order Tracking API Call
    func orderTrackingApiCall() {
        let Parse = CommomParsing()
        Parse.TrackOrderStatus(lang: login_session.value(forKey: "Language") as? String ?? "es", order_id: customer_orderId, store_id: customer_storeId, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.orderTrackingDict = response.value(forKey: "data") as! NSDictionary
                self.deliveryPersonDetailsDict = self.orderTrackingDict.value(forKey: "delivery_person_details") as! NSDictionary
                self.deliverAssignedString = self.deliveryPersonDetailsDict.value(forKey: "deliver_assigned") as! String
                if self.deliverAssignedString == "Yes" {
                    self.deliveryBoyLatitude = self.deliveryPersonDetailsDict.value(forKey: "deliver_latitude") as! String
                    self.deliveryBoyLongitude = self.deliveryPersonDetailsDict.value(forKey: "deliver_longitude") as! String
                    self.deliverNameString = self.deliveryPersonDetailsDict.value(forKey: "deliver_name") as! String
                    let deliveryId:Int = self.deliveryPersonDetailsDict.value(forKey: "deliver_id") as! Int
                    self.deliverIdString = String(deliveryId)
                    self.deliverImageString = self.deliveryPersonDetailsDict.value(forKey: "deliver_image") as! String
                    self.deliverMobileString = self.deliveryPersonDetailsDict.value(forKey: "deliver_mobile") as! String
                    
                    self.infoNameTxt.text = self.deliverNameString
                    self.infoPhone1Txt.text = self.deliverMobileString
                    self.infoPhone2Txt.text = self.deliverMobileString
                    self.infoAddressTxt.text = self.deliverNameString
                }
                //let paidAmt = self.orderTrackingDict.object(forKey: "totalReceivableAmount")as! String
               // self.paidAmtLbl.text = "Amount to Pay :\(common_currency) \(paidAmt)"
                if let otpValue:NSNumber = self.orderTrackingDict.object(forKey: "order_otp") as? NSNumber {
                    self.otpView.isHidden = false
                    self.otpLabel.text = "OTP is:  \(otpValue)"
                }
                else if let otpValue:String = self.orderTrackingDict.object(forKey: "order_otp") as? String {
                    self.otpView.isHidden = false
                    self.otpLabel.text = "OTP is:  \(otpValue)"
                }
                else {
                    self.otpView.isHidden = true
                }
                
                self.apiOrderIdString = self.orderTrackingDict.value(forKey: "order_id") as! String
                
                self.customerDetailsDict = self.orderTrackingDict.value(forKey: "customer_details") as! NSDictionary
                self.customerLatitude = self.customerDetailsDict.value(forKey: "cus_latitude") as? String ?? ""
                self.customerLongitude = self.customerDetailsDict.value(forKey: "cus_longitude") as? String ?? ""
                self.customerAddressString = self.customerDetailsDict.value(forKey: "cus_address") as? String ?? ""
                self.customerNameString = self.customerDetailsDict.value(forKey: "cus_name") as! String
                self.customerMobileNumbe1String = self.customerDetailsDict.value(forKey: "cus_phone") as! String
                self.customerAddress1String = self.customerDetailsDict.value(forKey: "cus_address1") as? String ?? ""
                
                self.restaurantDetailsDict = self.orderTrackingDict.value(forKey: "restaurant_details") as! NSDictionary
                self.restaurantLatitude = self.restaurantDetailsDict.value(forKey: "restaurant_latitude") as! String
                self.restaurantLongitude = self.restaurantDetailsDict.value(forKey: "restaurant_longitude") as! String
                self.restaurantNameString = self.restaurantDetailsDict.value(forKey: "restaurant_name") as! String
                
                self.statusDetailsArray = self.orderTrackingDict.value(forKey: "order_status_details") as! NSArray
                self.orderStatusArray = NSMutableArray(array: self.statusDetailsArray)
                //let statueArr:NSArray = self.statusDetailsArray.value(forKey: "ord_title") as! NSArray
                //self.orderStatusArray = NSMutableArray(array: statueArr)
                print(self.orderStatusArray)
                
                self.tableView.reloadData()
                self.contentTblHeight.constant = self.initalFrame.size.height - 180
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
            self.mqttSetting()
            self.startTimer()

        }, onFailure: {errorResponse in})
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        self.stopTimer()
    }
    //MARK: - Timer Configure
    func startTimer() {
        if cust_Timer == nil {
            cust_Timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(orderTrackingApiBGCall), userInfo: nil, repeats: true)
        }
    }
    func stopTimer()
    {
        if cust_Timer != nil {
            cust_Timer!.invalidate()
            cust_Timer = nil
        }
    }
    @objc func orderTrackingApiBGCall() {
        let Parse = CommomParsing()
        Parse.TrackOrderStatus(lang: login_session.value(forKey: "Language") as? String ?? "es", order_id: customer_orderId, store_id: customer_storeId, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.orderTrackingDict = response.value(forKey: "data") as! NSDictionary
                self.deliveryPersonDetailsDict = self.orderTrackingDict.value(forKey: "delivery_person_details") as! NSDictionary
                self.deliverAssignedString = self.deliveryPersonDetailsDict.value(forKey: "deliver_assigned") as! String
                if self.deliverAssignedString == "Yes" {
                    self.deliveryBoyLatitude = self.deliveryPersonDetailsDict.value(forKey: "deliver_latitude") as! String
                    self.deliveryBoyLongitude = self.deliveryPersonDetailsDict.value(forKey: "deliver_longitude") as! String
                    self.deliverNameString = self.deliveryPersonDetailsDict.value(forKey: "deliver_name") as! String
                    let deliveryId:Int = self.deliveryPersonDetailsDict.value(forKey: "deliver_id") as! Int
                    self.deliverIdString = String(deliveryId)
                    self.deliverImageString = self.deliveryPersonDetailsDict.value(forKey: "deliver_image") as! String
                    self.deliverMobileString = self.deliveryPersonDetailsDict.value(forKey: "deliver_mobile") as! String
                    
                    self.infoNameTxt.text = self.deliverNameString
                    self.infoPhone1Txt.text = self.deliverMobileString
                    self.infoPhone2Txt.text = self.deliverMobileString
                    self.infoAddressTxt.text = self.deliverNameString
                }
                
                if let otpValue:NSNumber = self.orderTrackingDict.object(forKey: "order_otp") as? NSNumber {
                    self.otpView.isHidden = false
                    self.otpLabel.text = "OTP is:  \(otpValue)"
                }
                else if let otpValue:String = self.orderTrackingDict.object(forKey: "order_otp") as? String {
                    self.otpView.isHidden = false
                    self.otpLabel.text = "OTP is:  \(otpValue)"
                }
                else {
                    self.otpView.isHidden = true
                }
                
                self.apiOrderIdString = self.orderTrackingDict.value(forKey: "order_id") as! String
                
                self.customerDetailsDict = self.orderTrackingDict.value(forKey: "customer_details") as! NSDictionary
                if self.customerDetailsDict.value(forKey: "cus_latitude") as? String != nil{
                self.customerLatitude = self.customerDetailsDict.value(forKey: "cus_latitude") as! String
                self.customerLongitude = self.customerDetailsDict.value(forKey: "cus_longitude") as! String
                self.customerAddressString = self.customerDetailsDict.value(forKey: "cus_address") as? String
                self.customerNameString = self.customerDetailsDict.value(forKey: "cus_name") as! String
                self.customerMobileNumbe1String = self.customerDetailsDict.value(forKey: "cus_phone") as! String
                self.customerAddress1String = self.customerDetailsDict.value(forKey: "cus_address1") as? String ?? ""
                }
                
                self.restaurantDetailsDict = self.orderTrackingDict.value(forKey: "restaurant_details") as! NSDictionary
                self.restaurantLatitude = self.restaurantDetailsDict.value(forKey: "restaurant_latitude") as! String
                self.restaurantLongitude = self.restaurantDetailsDict.value(forKey: "restaurant_longitude") as! String
                self.restaurantNameString = self.restaurantDetailsDict.value(forKey: "restaurant_name") as! String
                
                self.statusDetailsArray = self.orderTrackingDict.value(forKey: "order_status_details") as! NSArray
                self.orderStatusArray = NSMutableArray(array: self.statusDetailsArray)
                print(self.orderStatusArray)
                
                self.tableView.reloadData()
                
                if self.orderStatusTypeString == "DELIVERED" {
                    self.mqtt.disconnect()
                    globalmqtt.disconnect()
                    if self.OnceAllowedDeliveryPage{
                        self.OnceAllowedDeliveryPage = false
                        let nav = self.storyboard?.instantiateViewController(withIdentifier: "OrderStatusViewController") as? OrderStatusViewController
                        //self.navigationController?.pushViewController(nav!, animated: true)
                        self.present(nav!, animated:true, completion:nil)
                    }
                }
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    @IBAction func infoCallBtnTapped(_ sender: Any) {
        guard let number = URL(string: "tel://" + deliverMobileString) else { return }
        UIApplication.shared.open(number)
    }
    @IBAction func popCloseBtnTapped(_ sender: Any) {
        greyView.isHidden = true
    }
    
}

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderStatusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetTableCell", for: indexPath) as! BottomSheetTableCell
        cell.statusLbl.text = (orderStatusArray[indexPath.row] as AnyObject).value(forKey: "ord_title") as? String
        cell.iconImageView.image = orderStatusStaticIconArray[indexPath.row] as? UIImage
        cell.selectionStyle = .none
        let tempVal:String = (orderStatusArray[indexPath.row] as AnyObject).value(forKey: "stage_completed") as! String
        if tempVal == "Yes" {
            if let orderTimingDate:String = (self.orderStatusArray[indexPath.row] as AnyObject).value(forKey: "ord_timing") as? String {
                if orderTimingDate != "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    let selectedDateStr = dateFormatter.date(from: orderTimingDate)
                    print(selectedDateStr!)
                    dateFormatter.dateFormat = "dd MMM yy h:mm a"
                    let formattedDate = dateFormatter.string(from: selectedDateStr!)
                    cell.timeLbl.text = formattedDate
                }else{
                    cell.timeLbl.text = (self.orderStatusArray[indexPath.row] as AnyObject).value(forKey: "ord_timing") as? String
                }
            }
            else {
                cell.timeLbl.text = (self.orderStatusArray[indexPath.row] as AnyObject).value(forKey: "ord_timing") as? String
            }
            cell.hideView.backgroundColor = UIColor.clear
            cell.hideView.isHidden = true
            cell.tickImageView.isHidden = false
        }else{
            cell.timeLbl.text = (self.orderStatusArray[indexPath.row] as AnyObject).value(forKey: "ord_timing") as? String
            cell.hideView.isHidden = false
            cell.tickImageView.isHidden = true
            cell.hideView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        }
        
        if cell.statusLbl.text == "Dispatched" {
            cell.infoBtn.isHidden = false
        }
        else {
            cell.infoBtn.isHidden = true
        }
        
        cell.infoBtn.tag = indexPath.row
        cell.infoBtn.addTarget(self,action:#selector(infoBtnClicked(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension BottomSheetViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
// MARK: MQTT Delegate
extension BottomSheetViewController: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        
    }
    
    // These two methods are all we care about for now
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        //mqtt.subscribe("testTopicName")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        TRACE("message: \(String(describing: message.string?.description)), id: \(id)")
        if let msgString = message.string {
            print(msgString)
            
            if let data = msgString.data(using: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    print(json!)
                    mqttGetDict = json!
                    orderStatusTypeString = mqttGetDict.value(forKey: "type") as! String
                    
                    if orderStatusTypeString == "ASSIGNED"{
                        let deliverId = ((mqttGetDict.object(forKey: "data")as! NSDictionary).object(forKey: "deliver_boy_id")as! NSNumber).stringValue
                        let subcribeStr = "delivery/\(deliverId)"
                        mqtt.subscribe(subcribeStr)
                    }else{
                        self.deliveryBoyLatitude = mqttGetDict.value(forKey: "lat") as! String
                        self.deliveryBoyLongitude = mqttGetDict.value(forKey: "lng") as! String
                    }
                    
                    if orderStatusTypeString == "SEND_OTP" {
                        orderTrackingApiCall()
                    }
                    else if orderStatusTypeString == "DELIVERED" {
                        
                        orderTrackingApiBGCall()
                        //mqtt.disconnect()
                        //globalmqtt.disconnect()
                        //let nav = self.storyboard?.instantiateViewController(withIdentifier: "OrderStatusViewController") as? OrderStatusViewController
                        //self.navigationController?.pushViewController(nav!, animated: true)
                    }
                    else if orderStatusTypeString == "FAILED" {
                        mqtt.disconnect()
                        globalmqtt.disconnect()
                        self.showFailurePopUp(msgStr: "Delivery Failed !!")
                    }
                    else if orderStatusTypeString == "STARTED" {
                        orderTrackingApiBGCall()
                    }
                    else if orderStatusTypeString == "ARRIVED" {
                        orderTrackingApiBGCall()
                    }
                    if orderStatusTypeString != "ASSIGNED"{
                        DispatchQueue.main.async {
                            self.bottomSheetDelegate?.sendLatLang(deliverylatitude: self.deliveryBoyLatitude, deliverylongitude: self.deliveryBoyLongitude, storelatitude: self.restaurantLatitude, storelongitude: self.restaurantLongitude, customerlatitude: self.customerLatitude, customerlongitude: self.customerLongitude, customerAddressString : self.customerAddressString ?? "")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Other required methods for CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        TRACE("trust: \(trust)")
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        TRACE("ack: \(ack)")
        if ack == .accept {
            if orderTrackingDict.object(forKey: "delivery_person_details") != nil{
            if (orderTrackingDict.object(forKey: "delivery_person_details")as! NSDictionary).object(forKey: "deliver_assigned")as! String == "No" {
                var subcribeStr = String()
                subcribeStr = "order/" + customer_orderId + "/restaurant/" + customer_storeId
                mqtt.subscribe(subcribeStr)
            }else{
                var subcribeStr = String()
                let deliverId = ((orderTrackingDict.object(forKey: "delivery_person_details")as! NSDictionary).object(forKey: "deliver_id")as! NSNumber).stringValue
                subcribeStr = "delivery/\(deliverId)"
                mqtt.subscribe(subcribeStr)
                
            }
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(String(describing: message.string?.description)), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        TRACE("topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        TRACE("topic: \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err.debugDescription)")
    }
    
    func _console(_ info: String) {
        TRACE("info: \(info)")
    }
}
extension BottomSheetViewController {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 1 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconect"
        }
        
        print("[TRACE] [\(prettyName)]: \(message)")
    }
}
