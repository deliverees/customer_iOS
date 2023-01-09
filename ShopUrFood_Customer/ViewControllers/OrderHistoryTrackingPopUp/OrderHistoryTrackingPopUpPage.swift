//
//  OrderHistoryTrackingPopUpPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 29/05/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup

class OrderHistoryTrackingPopUpPage: BottomPopupViewController,UITableViewDataSource,UITableViewDelegate {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    @IBOutlet weak var trackTable: UITableView!
    var dataArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpToTrackingStatus = "d't allow"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn_Act(_ sender: Any) {
        popUpToTrackingStatus = "d't allow"
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func trackBntTapped(sender:UIButton){
        popUpToTrackingSelectedIndex = sender.tag
        popUpToTrackingStatus = "allow"
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTBCell") as? OrderHistoryTBCell
        cell?.selectionStyle = .none
        cell?.restaurantNameLbl.text = ((dataArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "store_name")as! String)
        cell?.locationLbl.text = ((dataArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "store_location")as! String)
        cell?.trackbtn.tag = indexPath.row
        cell?.trackbtn.addTarget(self, action: #selector(trackBntTapped), for: .touchUpInside)
        return cell!

    }
    
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(278)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
}
