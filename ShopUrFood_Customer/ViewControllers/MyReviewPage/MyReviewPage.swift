//
//  MyReviewPage.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 25/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import Lottie



@available(iOS 11.0, *)
class MyReviewPage: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var emptyMsgLbl: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var topSegmentView: ScrollableSegmentedControl!
    @IBOutlet weak var baseContentView: UIView!
    var resultDict = NSMutableDictionary()
    var resultsArray = NSMutableArray()
    var itemReviewArray = NSMutableArray()
    var restaurantReviewArray = NSMutableArray()
    var orderReviewArray = NSMutableArray()
    var showIndex = Int()
    var navigationType = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        showIndex = 0
        isfromMyReviewPage = false
        self.setSegmentData()
        self.getReviewData()
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
//        baseContentView.layer.cornerRadius = 5.0

        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "myreviews") as? String
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setSegmentData(){
        topSegmentView.segmentStyle = .textOnly
        topSegmentView.insertSegment(withTitle: LanguageDictonary.value(forKey: "items") as? String, image: nil, at: 0)
        topSegmentView.insertSegment(withTitle: LanguageDictonary.value(forKey: "resturants") as? String, image: nil, at: 1)
        topSegmentView.insertSegment(withTitle: LanguageDictonary.value(forKey: "orders") as? String, image: nil, at: 2)
        topSegmentView.underlineSelected = true
        topSegmentView.tintColor = AppDarkOrange
        topSegmentView.selectedSegmentContentColor = UIColor.black
        topSegmentView.selectedSegmentIndex = 0
        topSegmentView.fixedSegmentWidth = true
        topSegmentView.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
    }
    
    //MARK:- API Methods
    func getReviewData(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.GetMyReviews(lang: login_session.value(forKey: "Language") as? String ?? "es",page_no: "1", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                self.resultsArray.addObjects(from: (self.resultDict.object(forKey: "item_review_list")as! NSArray) as! [Any])
                self.reviewTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "No Reviews available!" {
                self.emptyMsgLbl.text = (response.object(forKey: "message")as! String)
                self.setNoitemFound()
            }
            self.stopLoadingIndicator(senderVC: self)
           
        }, onFailure: {errorResponse in})
    }
    
    func setNoitemFound()  {
        emptyView.isHidden = false
        let tempView = LOTAnimationView(name: "EmptyReviewAlert")
        tempView.frame = CGRect(x:0, y:0, width: 300, height: 200)
        animationView.addSubview(tempView)
        
        tempView.play()
        
    }
    
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        showIndex = sender.selectedSegmentIndex
        resultsArray.removeAllObjects()
        if showIndex == 0 && resultDict.object(forKey: "item_review_list") != nil{
             self.resultsArray.addObjects(from: (resultDict.object(forKey: "item_review_list")as! NSArray) as! [Any])
        }else if showIndex == 1 && resultDict.object(forKey: "rest_review_list") != nil{
            self.resultsArray.addObjects(from: (resultDict.object(forKey: "rest_review_list")as! NSArray) as! [Any])
        }else{
            if (resultDict.object(forKey: "order_review_list") != nil){
           self.resultsArray.addObjects(from: (resultDict.object(forKey: "order_review_list")as! NSArray) as! [Any])
            }
        }

        if resultsArray.count == 0{
            self.setNoitemFound()
        }else{
            emptyView.isHidden = true
        }
        reviewTable.reloadData()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if showIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewTableViewCell") as? OrderReviewTableViewCell
            cell?.selectionStyle = .none
            cell?.titleLbl.text = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "delivery_person_name")as? String
            cell?.timeLbl.text = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "created_date")as? String
            cell?.reviewMsgLbl.text = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_comments")as? String

            if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 1{
                cell?.starOne.isHidden = false
                cell?.starTwo.isHidden = true
                cell?.starThree.isHidden = true
                cell?.starFour.isHidden = true
                cell?.starFive.isHidden = true
            }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 2{
                cell?.starOne.isHidden = false
                cell?.starTwo.isHidden = false
                cell?.starThree.isHidden = true
                cell?.starFour.isHidden = true
                cell?.starFive.isHidden = true
            }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 3{
                cell?.starOne.isHidden = false
                cell?.starTwo.isHidden = false
                cell?.starThree.isHidden = false
                cell?.starFour.isHidden = true
                cell?.starFive.isHidden = true
            }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 4{
                cell?.starOne.isHidden = false
                cell?.starTwo.isHidden = false
                cell?.starThree.isHidden = false
                cell?.starFour.isHidden = false
                cell?.starFive.isHidden = true
            }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 5{
                cell?.starOne.isHidden = false
                cell?.starTwo.isHidden = false
                cell?.starThree.isHidden = false
                cell?.starFour.isHidden = false
                cell?.starFive.isHidden = true
            }
            cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)

            return cell!
            
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemReviewTableViewCell") as? itemReviewTableViewCell
        cell?.selectionStyle = .none
        if showIndex == 0{
        let imageUrl =  URL(string: (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "item_image")as! String)
        cell?.foodImg.kf.setImage(with: imageUrl)
        cell?.itemNameLbl.text = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "item_title")as? String
        
        }else if showIndex == 1 {
            let imageUrl =  URL(string: (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_image")as! String)
            cell?.foodImg.kf.setImage(with: imageUrl)
            cell?.itemNameLbl.text = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as? String
        }
        cell?.timelbl.text = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "created_date")as? String
        if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 1{
            cell?.starOne.isHidden = false
            cell?.starTwo.isHidden = true
            cell?.startThree.isHidden = true
            cell?.starFour.isHidden = true
            cell?.starFive.isHidden = true
        }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 2{
            cell?.starOne.isHidden = false
            cell?.starTwo.isHidden = false
            cell?.startThree.isHidden = true
            cell?.starFour.isHidden = true
            cell?.starFive.isHidden = true
        }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 3{
            cell?.starOne.isHidden = false
            cell?.starTwo.isHidden = false
            cell?.startThree.isHidden = false
            cell?.starFour.isHidden = true
            cell?.starFive.isHidden = true
        }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 4{
            cell?.starOne.isHidden = false
            cell?.starTwo.isHidden = false
            cell?.startThree.isHidden = false
            cell?.starFour.isHidden = false
            cell?.starFive.isHidden = true
        }else  if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! Int == 5{
            cell?.starOne.isHidden = false
            cell?.starTwo.isHidden = false
            cell?.startThree.isHidden = false
            cell?.starFour.isHidden = false
            cell?.starFive.isHidden = true
        }
        cell?.msgLbl.text = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "review_comments")as! String)
        cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
        cell?.baseView.layer.cornerRadius = 5.0
        return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isfromMyReviewPage = true
        if showIndex == 0 {
            let resultdata = NSMutableDictionary()
            resultdata.addEntries(from: (resultsArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
            nextViewController.item_id = (resultdata.object(forKey: "product_id") as! NSNumber).stringValue
             nextViewController.restaurant_id = (resultdata.object(forKey: "restaurant_id") as! NSNumber).stringValue
            nextViewController.itemName = (resultdata.object(forKey: "item_title") as! String)
            if self.navigationType == "sidebar" || isfromMyReviewPage
            {
                self.revealViewController().pushFrontViewController(nextViewController, animated: true)
            }
            else
            {

            self.present(nextViewController, animated:true, completion:nil)
            }
            
        }else if showIndex == 1 {
            let resultdata = NSMutableDictionary()
            resultdata.addEntries(from: (resultsArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if #available(iOS 11.0, *) {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
                nextViewController.rest_id = (resultdata.object(forKey: "res_store_id") as! NSNumber).stringValue
                nextViewController.storeName = resultdata.object(forKey: "restaurant_name")as! String
                if self.navigationType == "sidebar" || isfromMyReviewPage
                {
                    self.revealViewController().pushFrontViewController(nextViewController, animated: true)
                }
                else
                {
                self.present(nextViewController, animated:true, completion:nil)
                }
        }
    }
    }
    
}
