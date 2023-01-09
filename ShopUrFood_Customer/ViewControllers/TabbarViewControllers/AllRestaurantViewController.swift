//
//  AllRestaurantViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 27/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
class AllRestaurantViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var restaurantTableBottom: NSLayoutConstraint!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var categoryCollectionview: UICollectionView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var restaruntTable: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterBtn: UIButton!

    //Filter View
    @IBOutlet weak var filterGrayBGView: UIView!
    @IBOutlet weak var filterBGView: UIView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterHeaderLabel: UILabel!
    @IBOutlet weak var filterCloseButton: UIButton!
    @IBOutlet weak var filterSearchButton: UIButton!

    var search_halal = String()
    var orderBy_delivery = String()
    var orderBy_rating = String()
    var orderBy_offers = String()
    
    
    var categoryTopIDArray = NSMutableArray()

    
    var allStoreArray = NSMutableArray()
    var categoryArray = NSMutableArray()
    var categoryIndex = Int()
    var selected_categoryId = String()
    
    var showResNameArray = [String]()
    var mostPreTimeNameArray = [String]()
    var commonSearchArray = [String]()

    var selectedIndexCollection = NSMutableArray()

    var selectedIndexTableSec0 = NSMutableArray()
    var selectedIndexTableSec1 = Int()
    var selectedIndexTableSec2 = NSMutableArray()

    var categoryIDArray = NSMutableArray()
    
    var morePreferTimeIDArray = NSMutableArray()
    var morePreferTimeArray:Array = [String]()

    var vegNonVegIDArray = NSMutableArray()
    var vegNonVegArray:Array = [String]()
    
    var CategoryCollectionIndex = Int()

    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    var pageIndex = Int()
    var sortedArray = NSMutableArray()
    var filterApplied = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "allrestaurants") as? String
        orderBy_offers = ""
        orderBy_rating = ""
        orderBy_delivery = ""
        search_halal = ""
        categoryIDArray.removeAllObjects()
        categoryTopIDArray.removeAllObjects()
        morePreferTimeArray = ["1", "2", "3"]
        vegNonVegArray = ["1", "2", ""]

        filterBGView.layer.cornerRadius = 5.0
        filterBGView.layer.masksToBounds = true
        
        filterTableView.layer.cornerRadius = 5.0
        filterTableView.layer.masksToBounds = true
        
        filterSearchButton.layer.cornerRadius = 15.0
        filterSearchButton.layer.masksToBounds = true
        self.filterSearchButton.setTitle(LanguageDictonary.value(forKey: "showrestaurants") as? String, for: .normal)
        self.filterHeaderLabel.text = LanguageDictonary.value(forKey: "filter") as? String
        
        pageIndex = 1
        filterApplied = false
//        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        topNavigationView.layer.shadowOpacity = 0.6
//        topNavigationView.layer.shadowRadius = 3.0
//        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        if revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width-80
            menuBtn.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        categoryIndex = 0
        
        //baseView = self.setCornorShadowEffects(sender: baseView)
        //baseView.layer.cornerRadius = 5.0
        restaruntTable.delegate = self
        restaruntTable.dataSource = self
        restaruntTable.layer.cornerRadius = 5.0
        restaruntTable.clipsToBounds = true
        self.getAllResturantData()
        searchTxt.addTarget(self, action: #selector(typingName), for: .editingChanged)
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
        showResNameArray.append(LanguageDictonary.value(forKey: "veg") as! String)
        showResNameArray.append(LanguageDictonary.value(forKey: "nonveg") as! String)
        showResNameArray.append(LanguageDictonary.value(forKey: "both") as! String)

        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "breakfast") as! String)
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "lunch") as! String)
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "dinner") as! String)

        commonSearchArray.append(LanguageDictonary.value(forKey: "topoffers") as! String)
        commonSearchArray.append(LanguageDictonary.value(forKey: "deliveryTime") as! String)
        commonSearchArray.append(LanguageDictonary.value(forKey: "ratings") as! String)
        commonSearchArray.append(LanguageDictonary.value(forKey: "halal") as! String)

        
        //get KeyBoard Height
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            restaurantTableBottom.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        restaurantTableBottom.constant = 0

    }
    
    func getAllResturantData(){
        self.showLoadingIndicator(senderVC: self)
        if pageIndex == 1{
            allStoreArray.removeAllObjects()
            sortedArray.removeAllObjects()
        }
        let Parse = CommomParsing()
        
        //Parse.getCategoryBasedRestaurants(lang: "en", user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: 1, category_id: categoryIDArray, search_halal: search_halal, orderBy_delivery: orderBy_delivery, orderBy_rating: orderBy_rating, orderBy_offers: orderBy_offers, restaurant_type: vegNonVegIDArray, prefer_time: morePreferTimeIDArray, search_key: "", onSuccess:

        
        Parse.getAllRestaurantList(lang: login_session.value(forKey: "Language") as? String ?? "es", user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: pageIndex, category_id: categoryIDArray, search_halal: search_halal, orderBy_delivery: orderBy_delivery, orderBy_rating: orderBy_rating, orderBy_offers: orderBy_offers, restaurant_type: vegNonVegIDArray, prefer_time: morePreferTimeIDArray, search_key: "", onSuccess:
            
            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.filterGrayBGView.isHidden = true
                self.allStoreArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "all_restautrant_details")as! NSArray) as! [Any])
                if self.pageIndex == 1 {
                    self.categoryArray.removeAllObjects()
                    self.categoryArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "category_list")as! NSArray) as! [Any])
                    self.sortedArray.addObjects(from: self.allStoreArray as! [Any])
                    self.categoryCollectionview.reloadData()
                    self.filterTableView.reloadData()
                }
                self.restaruntTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.filterGrayBGView.isHidden = true
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.filterGrayBGView.isHidden = true
                print(response.object(forKey: "message") as Any)
            }
            self.stopLoadingIndicator(senderVC: self)
            self.restaruntTable.separatorColor = UIColor.lightGray
            self.restaruntTable.isHidden = false
        }, onFailure: {errorResponse in})
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "orange_search"){
            sender.setImage(UIImage(named: "large_orange_close"), for: .normal)
            searchView.isHidden = false
            searchTxt.becomeFirstResponder()
            navigationTitleLbl.isHidden = true
        }else{
            sender.setImage(UIImage(named: "orange_search"), for: .normal)
            searchView.isHidden = true
            searchTxt.resignFirstResponder()
            filterApplied = false
            pageIndex = 1
            if categoryIndex == 0 {
                self.getAllResturantData()
            }else{
                self.getCategoryBasedRestaurant()
            }
            navigationTitleLbl.isHidden = false
        }
    }
    
    
    
    @IBAction func filterBtnAction(_ sender: Any)
    {
        self.filterGrayBGView.isHidden  = false

    }
    
    @IBAction func filterPopupCloseBtnAction(_ sender: Any)
    {
       self.filterGrayBGView.isHidden  = true
    }
    
    @IBAction func filterSearchBtnAction(_ sender: Any)
    {
        pageIndex = 1
        if categoryIndex == 0
        {
            self.getAllResturantData()
        }
        else
        {
            self.getCategoryBasedRestaurant()
        }
    }

    
    //MARK:- Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == filterTableView
        {
           return 3
        }
        else
        {
           return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == filterTableView
        {
        if section == 0
        {
        if categoryArray.count != 0
        {
         return categoryArray.count + 1
        }
            return 0
        }
        else if section == 1
        {
          return showResNameArray.count + 1
        }
        else
        {
          return mostPreTimeNameArray.count + 1
        }
        }
            
            
        else
        {
        if filterApplied == false
        {
            return allStoreArray.count
        }
        else
        {
            return sortedArray.count
        }
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == filterTableView
        {
            if indexPath.section == 0
            {
            if indexPath.row == 0
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCuisinesTitleCell") as? FilterCuisinesTitleCell
            cell?.selectionStyle = .none
                cell?.titileLbl.text = LanguageDictonary.value(forKey: "cusines") as? String
            return cell!
            }
            else
             {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCuisinesDetailCell") as? FilterCuisinesDetailCell
                cell?.selectionStyle = .none
                cell?.cusineNameLbl.text = ((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_name")as! String)
                
                if selectedIndexTableSec0.contains(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                {
                   cell?.cusineCheckBoxImageView.image = UIImage(named: "selectedCheckBox")
                }
                else
                {
                    cell?.cusineCheckBoxImageView.image = UIImage(named: "checkBox")

                }
                
                return cell!
             }
            }
            else if indexPath.section == 1
            {
                if indexPath.row == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterShowResTitleCell") as? FilterShowResTitleCell
                    cell?.selectionStyle = .none
                    cell?.titleLbl.text = LanguageDictonary.value(forKey: "showrestaurantwith") as? String
                    return cell!
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterShowResDetailsCell") as? FilterShowResDetailsCell
                    cell?.selectionStyle = .none
                    cell?.showResWithNameLbl.text = showResNameArray[indexPath.row - 1]
                    
                    if selectedIndexTableSec1 == indexPath.row
                    {
                        cell?.showResWithCheckBoxImageView.image = UIImage(named: "select_radio")
                    }
                    else
                    {
                        cell?.showResWithCheckBoxImageView.image = UIImage(named: "unSelectRadio")
                    }
                    
                    return cell!
                }

            }
            else
            {
                if indexPath.row == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterMostPreferTimeTitleCell") as? FilterMostPreferTimeTitleCell
                    cell?.selectionStyle = .none
                     cell?.titleLbl.text = LanguageDictonary.value(forKey: "mostpreferabletime") as? String
                    return cell!
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterMostPreferTimeDetailsCell") as? FilterMostPreferTimeDetailsCell
                    cell?.selectionStyle = .none
                    cell?.mostPreferTimeNameLbl.text = mostPreTimeNameArray[indexPath.row - 1]
                    
                    if selectedIndexTableSec2.contains(morePreferTimeArray[indexPath.row - 1])
                    {
                        cell?.mostPreferTimeCheckBoxImageView.image = UIImage(named: "selectedCheckBox")
                    }
                    else
                    {
                        cell?.mostPreferTimeCheckBoxImageView.image = UIImage(named: "checkBox")
                    }
                    return cell!
                }

            }
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllDetailsCell") as? ViewAllDetailsCell
        cell?.selectionStyle = .none
        if filterApplied == false{
        let restImg = URL(string: (allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_image")as! String)
        cell?.food_imgView.kf.setImage(with: restImg)
        cell?.titleLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String)
        cell?.openTimeLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "category_name")as! String)
        cell?.descriptionLbl.text = "\(LanguageDictonary.value(forKey: "deliveryTime") as! String) " + ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_delivery_time")as! String)
          
        if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_offer")as! NSNumber) == 0
        {
         cell?.offerPercentLbl.isHidden = true
         cell?.offerPercentImageView.isHidden = true
        }
        else
        {
        cell?.offerPercentLbl.isHidden = false
        cell?.offerPercentImageView.isHidden = false

        cell?.offerPercentLbl.text = "\(LanguageDictonary.value(forKey: "upto") as! String) " + (((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_offer")as! NSNumber).stringValue) + "%" + " \(LanguageDictonary.value(forKey: "off") as! String)" 
        }
        if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! Int == 0 ){
            cell?.startRating.isHidden = true
            cell?.ratingLbl.isHidden = false
            cell?.ratingLbl.text = "0"
        }else{
            cell?.startRating.isHidden = true
            cell?.ratingLbl.isHidden = false
            cell?.ratingLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! NSNumber).stringValue
        }
        cell?.food_imgView.layer.cornerRadius = 5.0
        cell?.food_imgView.clipsToBounds = true
        if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_status")as! String) == "Closed"{
            cell?.closedLbl.isHidden = true
            cell?.closedTransperantView.isHidden = false
            cell?.closedTransperantView.backgroundColor = WhiteTranspertantColor
            cell?.titleLbl.textColor = UIColor.lightGray
            cell?.openTimeLbl.textColor = UIColor.lightGray
            cell?.descriptionLbl.textColor = UIColor.lightGray
            cell?.offerPercentLbl.textColor = UIColor.lightGray
            cell?.reviewRatingImageView.image = UIImage(named: "grayReview")
            cell?.deliBoyImageView.image = UIImage(named: "deliveryGrayIcon")
            cell?.offerPercentImageView.image = UIImage(named: "grayOfferPercent")
        }else{
            cell?.closedLbl.isHidden = true
            cell?.closedTransperantView.isHidden = true
            cell?.titleLbl.textColor = UIColor.darkText
            cell?.openTimeLbl.textColor = UIColor.darkGray
            cell?.descriptionLbl.textColor = UIColor.darkText
            cell?.offerPercentLbl.textColor = UIColor.darkText
            cell?.reviewRatingImageView.image = UIImage(named: "Ratings")
            cell?.deliBoyImageView.image = UIImage(named: "ic_started")
            cell?.offerPercentImageView.image = UIImage(named: "OfferPercent1")

        }
        
        if indexPath.row == self.allStoreArray.count - 1 && self.allStoreArray.count % 10 == 0 && categoryIndex == 0 {
            pageIndex += 1
            self.getAllResturantData()
            
        }
        }else{
            let restImg = URL(string: (sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_image")as! String)
            cell?.food_imgView.kf.setImage(with: restImg)
            cell?.titleLbl.text = ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String)
            cell?.openTimeLbl.text = ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "category_name")as! String)
            cell?.descriptionLbl.text = "\(LanguageDictonary.value(forKey: "deliveryTime") as! String) " + ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_delivery_time")as! String)
            
            if ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_offer")as! NSNumber) == 0
            {
                cell?.offerPercentLbl.isHidden = true
                cell?.offerPercentImageView.isHidden = true
            }
            else
            {
                cell?.offerPercentLbl.isHidden = false
                cell?.offerPercentImageView.isHidden = false
            cell?.offerPercentLbl.text = "\(LanguageDictonary.value(forKey: "upto") as! String) " + (((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_offer")as! NSNumber).stringValue) + "%" + " \(LanguageDictonary.value(forKey: "off") as! String)"
            }
            if ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! Int == 0 ){
                cell?.startRating.isHidden = true
                cell?.ratingLbl.isHidden = false
                cell?.ratingLbl.text = "0"

            }else{
                cell?.startRating.isHidden = true
                cell?.ratingLbl.isHidden = false
                cell?.ratingLbl.text = ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! NSNumber).stringValue
            }
            cell?.food_imgView.layer.cornerRadius = 5.0
            cell?.food_imgView.clipsToBounds = true
            if ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_status")as! String) == "Closed"{
                cell?.closedLbl.isHidden = true
                cell?.closedTransperantView.isHidden = false
                cell?.titleLbl.textColor = UIColor.lightGray
                cell?.openTimeLbl.textColor = UIColor.lightGray
                 cell?.descriptionLbl.textColor = UIColor.lightGray
                cell?.offerPercentLbl.textColor = UIColor.lightGray
                cell?.closedTransperantView.backgroundColor = WhiteTranspertantColor
                cell?.reviewRatingImageView.image = UIImage(named: "grayReview")
                cell?.deliBoyImageView.image = UIImage(named: "deliveryGrayIcon")
                cell?.offerPercentImageView.image = UIImage(named: "grayOfferPercent")
            }else{
                cell?.closedLbl.isHidden = true
                cell?.closedTransperantView.isHidden = true
                cell?.titleLbl.textColor = UIColor.darkText
                cell?.openTimeLbl.textColor = UIColor.darkGray
                cell?.descriptionLbl.textColor = UIColor.darkText
                cell?.offerPercentLbl.textColor = UIColor.darkText
                cell?.reviewRatingImageView.image = UIImage(named: "Ratings")
                cell?.deliBoyImageView.image = UIImage(named: "ic_started")
                cell?.offerPercentImageView.image = UIImage(named: "OfferPercent1")

            }
            
            if indexPath.row == self.sortedArray.count - 1 && self.sortedArray.count % 10 == 0 && categoryIndex == 0 {
                pageIndex += 1
                self.getAllResturantData()
                
            }
        }
        return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == filterTableView
        {
          print("Filter didselect")
            
            if indexPath.section == 0
            {
                
                if categoryIDArray.contains(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                {
                    categoryIDArray.remove(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                    
                }
                else
                {
                    categoryIDArray.add(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                }
                
                print("categoryIDArray : ",categoryIDArray)
                
                
                if selectedIndexTableSec0.contains(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                    
                {
                    selectedIndexTableSec0.remove(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                }
                else
                {
                    selectedIndexTableSec0.add(((categoryArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue)
                }
                
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                
                UIView.performWithoutAnimation
                    {
                        filterTableView.reloadRows(at: [indexPath], with: .none)
                        //filterTableView.reloadSections(IndexSet(integer: indexPathRow), with: .automatic)
                        //newOrdersTblView.reloadData()
                        
                }

            }
            else if indexPath.section == 1
            {
                selectedIndexTableSec1 = indexPath.row
                let indexPathRow:Int = indexPath.section
                
                print("VegNonveg : ", selectedIndexTableSec1)
                
                if selectedIndexTableSec1 == 1
                {
                    vegNonVegIDArray.removeAllObjects()
                    vegNonVegIDArray.add(vegNonVegArray[0])
                }
                else if selectedIndexTableSec1 == 2
                {
                    vegNonVegIDArray.removeAllObjects()
                    vegNonVegIDArray.add(vegNonVegArray[1])
                }
                else
                {
                    vegNonVegIDArray.removeAllObjects()
                    vegNonVegIDArray.add("1")
                    vegNonVegIDArray.add("2")
                }
                
                print("vegNonVegIDArray : ",vegNonVegIDArray)

                UIView.performWithoutAnimation
                    {
                        filterTableView.reloadSections(IndexSet(integer: indexPathRow), with: .automatic)
                        //newOrdersTblView.reloadData()
                }

            }
            else
            {
                
                if morePreferTimeIDArray.contains(morePreferTimeArray[indexPath.row - 1])
                {
                    morePreferTimeIDArray.remove(morePreferTimeArray[indexPath.row - 1])
                    
                }
                else
                {
                    morePreferTimeIDArray.add(morePreferTimeArray[indexPath.row - 1])
                }
                
                print("morePreferTimeIDArray : ",morePreferTimeIDArray)

                
                if selectedIndexTableSec2.contains(morePreferTimeArray[indexPath.row - 1])
                    
                {
                    selectedIndexTableSec2.remove(morePreferTimeArray[indexPath.row - 1])
                }
                else
                {
                    selectedIndexTableSec2.add(morePreferTimeArray[indexPath.row - 1])
                }
                
                let indexPath = IndexPath(item: indexPath.row, section: 2)

                UIView.performWithoutAnimation
                    {
                        filterTableView.reloadRows(at: [indexPath], with: .none)
                        //filterTableView.reloadSections(IndexSet(integer: indexPathRow), with: .automatic)
                        //newOrdersTblView.reloadData()
                        
                }
                
            }

        }
        else
        {
        if filterApplied == true
        {
        let rest_id = ((sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
        let storeName = (sortedArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if #available(iOS 11.0, *) {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
            nextViewController.rest_id = rest_id
            nextViewController.storeName = storeName
            self.present(nextViewController, animated:true, completion:nil)
        }
        }
        else
        {
            let rest_id = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
            let storeName = (allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if #available(iOS 11.0, *) {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
                nextViewController.rest_id = rest_id
                nextViewController.storeName = storeName
                self.present(nextViewController, animated:true, completion:nil)
            }
          }
        
        }
    }
    
    //MARK:- ColloectionView Delegate & DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if categoryArray.count != 0{
//            return categoryArray.count + 1
//        }
        return commonSearchArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var categoryStr = String()
        if indexPath.row == 0
        {
            categoryStr = "All"
        }else{
            //categoryStr = (categoryArray.object(at: indexPath.row-1)as! NSDictionary).object(forKey: "category_name")as! String
            categoryStr = commonSearchArray[indexPath.row - 1]

        }
        var size = categoryStr.size(withAttributes: nil)
        size.width = size.width + 100
        size.height = 30
        return size
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCategoryCell", for: indexPath) as! RestaurantCategoryCell
        if indexPath.row == 0
        {
            cell.categoryNameLbl.text = LanguageDictonary.value(forKey: "all") as? String
            
            if categoryIndex == 0
            {
                cell.categoryNameLbl.backgroundColor = AppLightOrange
                cell.categoryNameLbl.textColor = UIColor.white
                cell.categoryNameLbl.layer.borderWidth = 0.5
                cell.categoryNameLbl.layer.borderColor = AppDarkOrange.cgColor
            }
            else
            {
                cell.categoryNameLbl.backgroundColor = UIColor.white
                cell.categoryNameLbl.textColor = UIColor.darkText
                cell.categoryNameLbl.layer.borderWidth = 0.5
                cell.categoryNameLbl.layer.borderColor = AppDarkOrange.cgColor
            }
           
            
        }else{
           // cell.categoryNameLbl.text = ((categoryArray.object(at: indexPath.row-1)as! NSDictionary).object(forKey: "category_name")as! String)
            cell.categoryNameLbl.text = commonSearchArray[indexPath.row - 1]
            
         //   if self.CategoryCollectionIndex == indexPath.row
            if categoryTopIDArray.contains((commonSearchArray[indexPath.row - 1]))
            {
                cell.categoryNameLbl.backgroundColor = AppLightOrange
                cell.categoryNameLbl.textColor = UIColor.white
                cell.categoryNameLbl.layer.borderWidth = 0.5
                cell.categoryNameLbl.layer.borderColor = AppDarkOrange.cgColor
            }
            else
            {
                cell.categoryNameLbl.backgroundColor = UIColor.white
                cell.categoryNameLbl.textColor = UIColor.darkText
                cell.categoryNameLbl.layer.borderWidth = 0.5
                cell.categoryNameLbl.layer.borderColor = AppDarkOrange.cgColor
            }


        }
        cell.categoryNameLbl.cornerRadius = 15.0
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.CategoryCollectionIndex = indexPath.row
        filterApplied = false
        searchTxt.text = ""
        self.view.endEditing(true)
        categoryIndex = indexPath.row
      
        
        if categoryIndex == 0
        {
            orderBy_offers = ""
            orderBy_delivery = ""
            orderBy_rating = ""
            search_halal = ""

            self.categoryTopIDArray.removeAllObjects()
            self.categoryIDArray.removeAllObjects()
            self.selectedIndexTableSec0.removeAllObjects()
            self.selectedIndexTableSec2.removeAllObjects()
            self.selectedIndexTableSec1 = 3
            self.filterTableView.reloadData()
            
            self.restaruntTable.isHidden = true
            pageIndex = 1
            self.getAllResturantData()
        }
        else
        {
            
            if categoryTopIDArray.contains((commonSearchArray[indexPath.row - 1]))
            {
                categoryTopIDArray.remove((commonSearchArray[indexPath.row - 1]))
                if categoryIndex == 1
                {
                   orderBy_offers = ""
                }
                else if categoryIndex == 2
                {
                  orderBy_delivery = ""
                }
                else if categoryIndex == 3
                {
                  orderBy_rating = ""
                }
                else if categoryIndex == 4
                {
                  search_halal = ""
                }
            }
            else
            {
                self.categoryTopIDArray.removeAllObjects()
                categoryTopIDArray.add((commonSearchArray[indexPath.row - 1]))
                if categoryIndex == 1
                {
                    orderBy_offers = "1"
                }
                else if categoryIndex == 2
                {
                    orderBy_delivery = "1"
                }
                else if categoryIndex == 3
                {
                    orderBy_rating = "1"
                }
                else if categoryIndex == 4
                {
                    search_halal = "1"
                }
                
            }
//            self.restaruntTable.isHidden = true
//            selected_categoryId = ((categoryArray.object(at: indexPath.row-1)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue
            
            self.getCategoryBasedRestaurant()
             categoryCollectionview.reloadData()
        }
    }
    
    
    func getCategoryBasedRestaurant(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        
        Parse.getCategoryBasedRestaurants(lang: login_session.value(forKey: "Language") as? String ?? "es", user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: 1, category_id: categoryIDArray, search_halal: search_halal, orderBy_delivery: orderBy_delivery, orderBy_rating: orderBy_rating, orderBy_offers: orderBy_offers, restaurant_type: vegNonVegIDArray, prefer_time: morePreferTimeIDArray, search_key: "", onSuccess:
        
       // Parse.getCategoryBasedRestaurants(lang: "en", user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: 1,category_id:selected_categoryId , onSuccess:
            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.allStoreArray.removeAllObjects()
                self.allStoreArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "all_restautrant_details")as! NSArray) as! [Any])
                self.filterGrayBGView.isHidden = true
                self.restaruntTable.reloadData()
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.showTokenExpiredPopUp(msgStr: LanguageDictonary.value(forKey: "norecordsfound") as! String)
                self.filterGrayBGView.isHidden = true
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                self.filterGrayBGView.isHidden = true
            }
            else{
                self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                print(response.object(forKey: "message") as Any)
                self.filterGrayBGView.isHidden = true
            }
            self.stopLoadingIndicator(senderVC: self)
            self.restaruntTable.isHidden = false
            self.restaruntTable.separatorColor = UIColor.lightGray
        }, onFailure: {errorResponse in})
    }

    
    @objc func typingName(textField:UITextField){
        if textField.text?.count == 0 {
            filterApplied = false
        }else{
            filterApplied = true
            sortedArray.removeAllObjects()
            sortedArray.addObjects(from: allStoreArray as! [Any])
        }
        if let typedText = textField.text {
            searchRestaurantByName(input: typedText) { (result) -> Void in
                print(result)
            }
        }
    }
    func searchRestaurantByName(input: String, completion: @escaping (_ result: NSMutableArray) -> Void)
    {
       
        let nameArray = NSMutableArray()
        let tempArray = sortedArray.value(forKey: "restaurant_name")as! NSArray
        let removalIndex = NSMutableArray()
        nameArray.addObjects(from:tempArray as! [Any])
        for index in 0..<nameArray.count{
            var tempName = nameArray.object(at: index)as! String
            tempName = tempName.lowercased()
            if !tempName.contains(input){
                removalIndex.add(index)
            }
        }
        for deleteIndex in 0..<removalIndex.count{
            let selectedIndex = removalIndex.object(at: deleteIndex)as! Int
            sortedArray.replaceObject(at: selectedIndex, with: "")
        }
        sortedArray.remove("")
        restaruntTable.reloadData()
        completion(sortedArray)
    }

}
