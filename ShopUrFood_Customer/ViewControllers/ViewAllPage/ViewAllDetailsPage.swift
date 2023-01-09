//
//  ViewAllDetailsPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 14/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ViewAllDetailsPage: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var topTitleLbl: UILabel!
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var detailsTable: UITableView!
    var selectedIndex = Int()
    var allStoreArray = NSMutableArray()
    var categoryId = String()
    var categoryName = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        detailsTable.layer.cornerRadius = 5.0
        detailsTable.layer.shadowColor = UIColor.lightGray.cgColor
        detailsTable.layer.shadowOffset = CGSize(width: 3, height: 3)
        detailsTable.layer.shadowOpacity = 0.7
        detailsTable.layer.shadowRadius = 4.0
        detailsTable.estimatedRowHeight = 80
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        
        self.getAllResturantData()
        topTitleLbl.text = categoryName
        // Do any additional setup after loading the view.
    }
    
    func getAllResturantData(){
        self.showLoadingIndicator(senderVC: self)
        
        let Parse = CommomParsing()
        
        Parse.getCategoryBasedRestaurants(lang: login_session.value(forKey: "Language") as? String ?? "es", user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: 1, category_id: [categoryId], search_halal: "", orderBy_delivery: "", orderBy_rating: "", orderBy_offers: "", restaurant_type: [], prefer_time: [], search_key: "", onSuccess:

      //  Parse.getCategoryBasedRestaurants(lang: "en", user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: 1,category_id:categoryId , onSuccess:
            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.allStoreArray.removeAllObjects()
                self.allStoreArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "all_restautrant_details")as! NSArray) as! [Any])
                self.detailsTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                print(response.object(forKey: "message") as Any)
            }
            self.stopLoadingIndicator(senderVC: self)
            self.detailsTable.separatorColor = UIColor.lightGray
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStoreArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllDetailsCell") as? ViewAllDetailsCell
        cell?.selectionStyle = .none
        let restImg = URL(string: (allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_image")as! String)
        cell?.food_imgView.kf.setImage(with: restImg)
        cell?.titleLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String)
        cell?.openTimeLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "today_wking_time")as! String)
        cell?.descriptionLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_desc")as! String)
        if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! Int == 0 ){
            cell?.startRating.isHidden = false
            cell?.ratingLbl.isHidden = true
        }else{
            cell?.startRating.isHidden = true
            cell?.ratingLbl.isHidden = false
            cell?.ratingLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! NSNumber).stringValue
        }
        cell?.food_imgView.layer.cornerRadius = 5.0
        cell?.food_imgView.clipsToBounds = true
        if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_status")as! String) == "Closed"{
            cell?.closedLbl.isHidden = false
            cell?.closedTransperantView.isHidden = false
            cell?.closedTransperantView.backgroundColor = WhiteTranspertantColor
        }else{
            cell?.closedLbl.isHidden = true
            cell?.closedTransperantView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if #available(iOS 11.0, *) {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
            nextViewController.rest_id = String((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! Int)
            nextViewController.storeName = (allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
