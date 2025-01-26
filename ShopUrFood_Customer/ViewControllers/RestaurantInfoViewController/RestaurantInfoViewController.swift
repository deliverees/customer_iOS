//
//  RestaurantInfoViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 20/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import DropDown
import BottomPopup
import CRRefresh
import ScrollableSegmentedControl


class RestaurantInfoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, delegateForCategorySearch, BottomPopupDelegate {
    
    
    @IBOutlet weak var cartBatchLbl: UILabel!
    @IBOutlet weak var NavigationTitlelbl: UILabel!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var noItemsLbl: UILabel!
    @IBOutlet weak var restaurantInfoHeaderView: RestaurantInfoHeaderView!
    var showIndex = Int()
    
    var rest_id = String()
    var storeName = String()
    var responseDict = NSMutableDictionary()
    var itemsArray = NSMutableArray()
    var currentPopUpName = String()
    var storeDict = NSMutableDictionary()
    var isLoadForFirstTime = Bool()
    var noOfRows = Int()
    var itemLimitReached = Bool()
    var search_halal = String()
    var orderBy_splOffers = String()
    var orderBy_topOffers = String()
    var search_combo = String()
    
    var selAvailableTimeBool = Bool()
    
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var InfoTable: UITableView!
    
    //Filter View
    @IBOutlet weak var filterGrayView: UIView!
    @IBOutlet weak var filterBGPopUpView: UIView!
    @IBOutlet weak var filterPopUpCloseButton: UIButton!
    
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var firstShowDetailsButton: UIButton!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondInnerView: UIView!
    @IBOutlet weak var secondShowDetailsButton: UIButton!
    @IBOutlet weak var ascendingOrderBtn: UIButton!
    @IBOutlet weak var descendingOrderBtn: UIButton!
    @IBOutlet weak var hightoLowBtn: UIButton!
    @IBOutlet weak var lowtoHighBtn: UIButton!
    @IBOutlet weak var byName: UILabel!
    @IBOutlet weak var byPrice: UILabel!
    
    
    
    var selectedIndexTableSec0 = NSMutableArray()
    var selectedIndexTableSec1 = Int()
    var selectedIndexTableSec2 = NSMutableArray()
    
    var categoryIDArray = NSMutableArray()
    
    var initialMorePreferTimeIDArray = NSMutableArray()
    var morePreferTimeIDArray = NSMutableArray()
    var morePreferTimeArray:Array = [String]()
    
    var vegNonVegIDArray = NSMutableArray()
    var vegNonVegArray:Array = [String]()
    
    var showResNameArray = [String]()
    var mostPreTimeNameArray = [String]()
    var commonSearchArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIndex = 0
        self.setSegmentData()
        
        orderBy_splOffers = ""
        search_combo = ""
        orderBy_topOffers = ""
        search_halal = ""
        
        categoryIDArray.removeAllObjects()
        morePreferTimeArray = ["1", "2", "3", "4", "5"]
        vegNonVegArray = ["1", "2", ""]
        self.secondView.isHidden = true
        pagingIndex = 1
        NavigationTitlelbl.text = storeName
        self.getResturantDetails()
        sortByStr = ""
        showWorkingHoursView = "false"
        isLoadForFirstTime = true
        itemLimitReached = false
        selAvailableTimeBool = false
        filterBGPopUpView.layer.cornerRadius = 5.0
        filterBGPopUpView.layer.masksToBounds = true
        
        firstShowDetailsButton.layer.cornerRadius = 2 //15.0
        firstShowDetailsButton.layer.masksToBounds = true
        self.firstShowDetailsButton.setTitle(LanguageDictonary.value(forKey: "showitems") as? String, for: .normal)
        self.secondShowDetailsButton.setTitle(LanguageDictonary.value(forKey: "showitems") as? String, for: .normal)
        self.ascendingOrderBtn.setTitle(LanguageDictonary.value(forKey: "acendingorder") as? String, for: .normal)
        self.descendingOrderBtn.setTitle(LanguageDictonary.value(forKey: "decendingorder") as? String, for: .normal)
        self.hightoLowBtn.setTitle(LanguageDictonary.value(forKey: "hightolow") as? String, for: .normal)
        self.lowtoHighBtn.setTitle(LanguageDictonary.value(forKey: "lowtohigh") as? String, for: .normal)
        self.byName.text = Localization.value(for: "byname")
        self.byPrice.text = Localization.value(for: "byprice")
        
        secondShowDetailsButton.layer.cornerRadius = 2 //15.0
        secondShowDetailsButton.layer.masksToBounds = true
        
        firstShowDetailsButton.layer.borderWidth = 2
        firstShowDetailsButton.layer.borderColor = UIColor.red.cgColor
        firstShowDetailsButton.setTitleColor(UIColor.red, for: .normal)
        firstShowDetailsButton.layer.backgroundColor = UIColor.white.cgColor
        
        secondShowDetailsButton.layer.borderWidth = 2
        secondShowDetailsButton.layer.borderColor = UIColor.red.cgColor
        secondShowDetailsButton.setTitleColor(UIColor.red, for: .normal)
        secondShowDetailsButton.layer.backgroundColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
        commonSearchArray.append(LanguageDictonary.value(forKey: "topoffers") as! String)
        commonSearchArray.append(LanguageDictonary.value(forKey: "specialoffers") as! String)
        commonSearchArray.append(LanguageDictonary.value(forKey: "combo") as! String)
        commonSearchArray.append(LanguageDictonary.value(forKey: "halal") as! String)
        
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "breakfast") as! String)
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "brunch") as! String)
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "lunch") as! String)
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "supper") as! String)
        mostPreTimeNameArray.append(LanguageDictonary.value(forKey: "dinner") as! String)
        
        showResNameArray.append(LanguageDictonary.value(forKey: "veg") as! String)
        showResNameArray.append(LanguageDictonary.value(forKey: "nonveg") as! String)
        showResNameArray.append(LanguageDictonary.value(forKey: "both") as! String)
        
        
        veg_NonVegItemsStr = ""
        
        cartBatchLbl.layer.cornerRadius = 9.0
        cartBatchLbl.layer.borderWidth = 1.0
        cartBatchLbl.layer.borderColor = UIColor.white.cgColor
        cartBatchLbl.clipsToBounds = true
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func topCartBtnAction(_ sender: Any) {
        guard login_session.isUserLogged() else {
            AppRouter.shared.presentLogin(in: self)
            return
        }
        actAsBaseTabbar.selectedIndex = 0
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cartCount = login_session.object(forKey: "userCartCount") as? String ?? "0"
        if (cartCount == "0"){
            cartBatchLbl.isHidden = true
        }else{
            cartBatchLbl.isHidden = false
            cartBatchLbl.text = cartCount
        }
    }
    
    
    func setSegmentData(){
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: LanguageDictonary.value(forKey: "flite") as? String, image: nil, at: 0)
        segmentedControl.insertSegment(withTitle:  LanguageDictonary.value(forKey: "sortby") as? String, image: nil, at: 1)
        segmentedControl.underlineSelected = true
        segmentedControl.tintColor = AppDarkOrange
        segmentedControl.selectedSegmentContentColor = UIColor.black
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.fixedSegmentWidth = true
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl)
    {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        showIndex = sender.selectedSegmentIndex
        if showIndex == 0
        {
            self.firstTableView.isHidden = false
            self.secondView.isHidden = true
        }
        else if showIndex == 1
        {
            self.secondView.isHidden = false
            self.firstTableView.isHidden = true
        }
    }
    
    @IBAction func sortBtnAction(_ sender: Any)
    {
        if sortByStr == "2"{
            ascendingOrderBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "3"{
            descendingOrderBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "4"{
            lowtoHighBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "5"{
            hightoLowBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }
        self.filterGrayView.isHidden = false
    }
    
    
    @IBAction func HighLowBtnAction(_ sender: Any) {
        sortByStr = "5"
        ascendingOrderBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        descendingOrderBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightoLowBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        lowtoHighBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
    }
    
    @IBAction func lowHightBtnAction(_ sender: Any) {
        sortByStr = "4"
        ascendingOrderBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        descendingOrderBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightoLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowtoHighBtn.setImage(UIImage(named: "select_radio"), for: .normal)
    }
    
    @IBAction func descendingBtnAction(_ sender: Any) {
        sortByStr = "3"
        ascendingOrderBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        descendingOrderBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        hightoLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowtoHighBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
    }
    
    @IBAction func AscendingBtnAction(_ sender: Any) {
        sortByStr = "2"
        ascendingOrderBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        descendingOrderBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightoLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowtoHighBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
    }
    
    @IBAction func firstShowDetailsBtnTapped(_ sender: Any)
    {
        pagingIndex = 1
        if allcategoryItemsStr == "1"
        {
            self.getRestaurantItems()
        }
        else
        {
            self.showItemsBasedOnCategory()
        }
        self.filterGrayView.isHidden = true
        
    }
    
    @IBAction func secondShowDetailsBtnTapped(_ sender: Any)
    {
        pagingIndex = 1
        
        if allcategoryItemsStr == "1"
        {
            self.getRestaurantItems()
        }
        else
        {
            self.showItemsBasedOnCategory()
        }
        self.filterGrayView.isHidden = true
    }
    
    @IBAction func filterPopupCloseBtnTapped(_ sender: Any)
    {
        self.filterGrayView.isHidden = true
    }
    
    @IBAction func infoBtnAction(_ sender: Any) {
        currentPopUpName = "info"
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "InfoAboutRestaurantViewController") as? InfoAboutRestaurantViewController else { return }
        popupVC.height = 400
        popupVC.topCornerRadius = 30.0
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = true
        popupVC.popupDelegate = self
        popupVC.ResultData = self.responseDict
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        if isfromMyReviewPage
        {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyReviewPage") as! MyReviewPage
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Calling API methods
    func getResturantDetails(){
        self.showLoadingIndicator(senderVC: self)
        
        let Parse = CommomParsing()
        
        
        Parse.restaurantDetails(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, review_page_no: "1", search_text: "", sort_by: "", item_type: "", search_halal: "", search_combo: "", orderBy_spl_offer: "", orderBy_top_offers: "", available_time: "", page_no: 1, initial_loading: "", onSuccess:
                                    {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.responseDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                let strArray = self.responseDict.object(forKey: "category_list")as! NSArray
                if strArray.count != 0{
                    let StrmutableArray = strArray.mutableCopy() as! NSMutableArray
                    main_category_id = (StrmutableArray.object(at: 0)as! NSDictionary).object(forKey: "main_category_id") as! NSNumber
                    let subCateArray = (StrmutableArray.object(at: 0)as! NSDictionary).object(forKey: "sub_category_list")as! NSArray
                    let subCategoryArray = subCateArray.value(forKey: "sub_category_id") as! NSArray
                    sub_category_id = subCategoryArray.object(at: 0)as! NSNumber
                    
                    // let Str = (self.responseDict.object(forKey: "sel_available_time") as! NSNumber).stringValue
                    getRestaurentID = self.rest_id
                    let Str = self.responseDict.object(forKey: "sel_available_time")
                    
                    if Str as? String != nil
                    {
                        if Str as? String == ""
                        {
                            self.initialMorePreferTimeIDArray.removeAllObjects()
                            self.getRestaurantItems()
                        }
                        else
                        {
                            let Str = (self.responseDict.object(forKey: "sel_available_time") as! NSNumber).stringValue
                            let indexStr = (self.responseDict.object(forKey: "sel_available_time") as! Int)
                            
                            self.initialMorePreferTimeIDArray.removeAllObjects()
                            self.initialMorePreferTimeIDArray.add(Str)
                            self.morePreferTimeIDArray.add(self.morePreferTimeArray[indexStr-1])
                            
                            self.selectedIndexTableSec2.add(indexStr)
                            
                            let indexPath = IndexPath(item: indexStr, section: 1)
                            
                            UIView.performWithoutAnimation
                            {
                                self.firstTableView.reloadRows(at: [indexPath], with: .none)
                            }
                            self.selAvailableTimeBool = true
                            
                            self.getRestaurantItems()
                            
                        }
                        
                    }
                    else if Str as? Int != nil
                    {
                        let Str = (self.responseDict.object(forKey: "sel_available_time") as! NSNumber).stringValue
                        let indexStr = (self.responseDict.object(forKey: "sel_available_time") as! Int)
                        
                        self.initialMorePreferTimeIDArray.removeAllObjects()
                        self.initialMorePreferTimeIDArray.add(Str)
                        self.morePreferTimeIDArray.add(self.morePreferTimeArray[indexStr-1])
                        
                        self.selectedIndexTableSec2.add(indexStr)
                        
                        let indexPath = IndexPath(item: indexStr, section: 1)
                        
                        UIView.performWithoutAnimation
                        {
                            self.firstTableView.reloadRows(at: [indexPath], with: .none)
                        }
                        self.selAvailableTimeBool = true
                        
                        self.getRestaurantItems()
                    }
                    else
                    {
                        self.initialMorePreferTimeIDArray.removeAllObjects()
                        self.getRestaurantItems()
                        
                    }
                    self.InfoTable.isHidden = false
                    self.InfoTable.reloadData()
                }
                else
                {
                    self.showTokenExpiredPopUp(msgStr: LanguageDictonary.value(forKey: "noitemsfound") as! String)
                    self.dismiss(animated: true, completion: nil)
                }
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                
            }else{
                print(response.object(forKey: "message") as Any)
                self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as? String ?? "")
                self.InfoTable.isHidden = true
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in
            self.stopLoadingIndicator(senderVC: self)
            self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
            self.InfoTable.isHidden = true
        })
    }
    
    private var isLoadingMore = false
    
    //MARK: - first manually load first index of category and subcategory
    func getRestaurantItems()  {
        self.showLoadingIndicator(senderVC: self)
        allcategoryItemsStr = "1"
        if isLoadForFirstTime
        {
            isLoadForFirstTime = false
            let Parse = CommomParsing()
            
            Parse.restaurantDetails(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, review_page_no: "1", search_text: "", sort_by: "", item_type: "", search_halal: "", search_combo: "", orderBy_spl_offer: "", orderBy_top_offers: "", available_time: self.initialMorePreferTimeIDArray, page_no: 1, initial_loading: "", onSuccess:
                                        {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    self.storeDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                    
                    if ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_list") as! NSArray).count != 0
                    {
                        
                        if pagingIndex > 1
                        {
                            self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_list") as! NSArray) as! [Any])
                        }
                        else
                        {
                            self.itemsArray.removeAllObjects()
                            self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_list") as! NSArray) as! [Any])
                        }
                        
                        self.InfoTable.reloadData()
                        
                    }
                    
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else
                {
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    print(response.object(forKey: "message") as Any)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
                self.InfoTable.isHidden = true
            })
        }
        else
        {
            guard !isLoadingMore else {
                return
            }
            isLoadingMore = true
            let Parse = CommomParsing()
            
            Parse.restaurantDetails(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, review_page_no: "1", search_text: "", sort_by: sortByStr, item_type: vegNonVegIDArray, search_halal: search_halal, search_combo: search_combo, orderBy_spl_offer: orderBy_splOffers, orderBy_top_offers: orderBy_topOffers, available_time: morePreferTimeIDArray, page_no: pagingIndex, initial_loading: "", onSuccess:{
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    let entries = (response.object(forKey: "data")as! NSDictionary)
                    self.storeDict.addEntries(from: entries as! [AnyHashable : Any])
                    
                    let newItemsList = entries.object(forKey: "item_list") as! [Any]
                    
                    if newItemsList.isEmpty {
                        self.itemLimitReached = true // TODO: Review this, this is a hack to avoid eternal reloading
                    }
                    if pagingIndex > 1
                    {
                        self.itemsArray.addObjects(from: newItemsList)
                    }
                    else
                    {
                        self.itemsArray.removeAllObjects()
                        self.itemsArray.addObjects(from: newItemsList)
                    }
                    
                    self.InfoTable.reloadData()
                    
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.noItemsLbl.isHidden = self.itemsArray.count > 0
                    print(response.object(forKey: "message") as Any)
                }
                self.stopLoadingIndicator(senderVC: self)
                self.isLoadingMore = false
            }, onFailure: {errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
                self.isLoadingMore = false
            })
        }
    }
    
    //MARK: -Dynamically Load Items depends on category & subcategory Selection
    func showItemsBasedOnCategory() {
        self.selAvailableTimeBool = false
        
        if allcategoryItemsStr == "1"
        {
            let Parse = CommomParsing()
            
            Parse.getCategoryBasedItems(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, main_category_id: "", sub_category_id: "", sort_by: sortByStr, search_text: "", page_no: pagingIndex, all: allcategoryItemsStr, item_type: vegNonVegIDArray, search_halal: search_halal, search_combo: search_combo, orderBy_spl_offer: orderBy_splOffers, orderBy_top_offers: orderBy_topOffers, available_time: morePreferTimeIDArray, onSuccess:
                                            {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    if pagingIndex > 1
                    {
                        //self.itemsArray.removeAllObjects()
                        self.itemLimitReached = false
                        
                        self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_lists") as! NSArray) as! [Any])
                    }
                    else
                    {
                        self.itemLimitReached = false
                        self.itemsArray.removeAllObjects()
                        self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_lists") as! NSArray) as! [Any])
                        
                    }
                    self.InfoTable.reloadData()
                    
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                    
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                    if pagingIndex > 1
                    {
                        self.itemLimitReached = true
                    }
                    else if pagingIndex == 1
                    {
                        self.itemLimitReached = false
                        
                        self.itemsArray.removeAllObjects()
                    }
                    else
                    {
                        
                    }
                    
                    self.InfoTable.reloadData()
                    
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    print(response.object(forKey: "message") as Any)
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                }
                self.stopLoadingIndicator(senderVC: self)
                
                
            }, onFailure: {errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
                self.itemLimitReached = true
            })
        }
        else
        {
            let Parse = CommomParsing()
            
            Parse.getCategoryBasedItems(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, main_category_id: main_category_id.stringValue, sub_category_id: sub_category_id.stringValue, sort_by: sortByStr, search_text: "", page_no: pagingIndex, all: allcategoryItemsStr, item_type: vegNonVegIDArray, search_halal: search_halal, search_combo: search_combo, orderBy_spl_offer: orderBy_splOffers, orderBy_top_offers: orderBy_topOffers, available_time: morePreferTimeIDArray, onSuccess:
                                            {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    
                    if pagingIndex > 1
                    {
                        self.itemLimitReached = false
                        
                        self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_lists") as! NSArray) as! [Any])
                    }
                    else
                    {
                        self.itemLimitReached = false
                        
                        self.itemsArray.removeAllObjects()
                        self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_lists") as! NSArray) as! [Any])
                        
                    }
                    self.InfoTable.reloadData()
                    
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                    
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                    if pagingIndex > 1
                    {
                        self.itemLimitReached = true
                        
                    }
                    else if pagingIndex == 1
                    {
                        self.itemLimitReached = false
                        
                        self.itemsArray.removeAllObjects()
                    }
                    else
                    {
                        
                    }
                    self.InfoTable.reloadData()
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                    
                }
                
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    print(response.object(forKey: "message") as Any)
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                }
                self.stopLoadingIndicator(senderVC: self)
                
                
            }, onFailure: {errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
                self.InfoTable.isHidden = true
            })
        }
    }
    
    func showItemBasedOnName(nameStr:String)
    {
        self.selAvailableTimeBool = false
        
        if allcategoryItemsStr == "1"
        {
            let Parse = CommomParsing()
            Parse.getCategoryBasedItems(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, main_category_id: "", sub_category_id: "", sort_by: sortByStr, search_text: nameStr, page_no: pagingIndex, all: allcategoryItemsStr, item_type: vegNonVegIDArray, search_halal: search_halal, search_combo: search_combo, orderBy_spl_offer: orderBy_splOffers, orderBy_top_offers: orderBy_topOffers, available_time: morePreferTimeIDArray, onSuccess:
                                            {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    self.itemsArray.removeAllObjects()
                    self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_lists") as! NSArray) as! [Any])
                    self.InfoTable.reloadSections(IndexSet(integer: 1), with: .none)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    print(response.object(forKey: "message") as Any)
                    self.itemsArray.removeAllObjects()
                    self.InfoTable.reloadSections(IndexSet(integer: 1), with: .none)
                }
                self.stopLoadingIndicator(senderVC: self)
                self.InfoTable.cr.endHeaderRefresh()
                self.InfoTable.cr.endLoadingMore()
                
            }, onFailure: {errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
                self.InfoTable.isHidden = true
            })
            
        }
        else
        {
            
            let Parse = CommomParsing()
            
            Parse.getCategoryBasedItems(lang: login_session.value(forKey: "Language") as? String ?? "es", restaurant_id: rest_id, main_category_id: main_category_id.stringValue, sub_category_id: sub_category_id.stringValue, sort_by: sortByStr, search_text: nameStr, page_no: pagingIndex, all: allcategoryItemsStr, item_type: vegNonVegIDArray, search_halal: search_halal, search_combo: search_combo, orderBy_spl_offer: orderBy_splOffers, orderBy_top_offers: orderBy_topOffers, available_time: morePreferTimeIDArray, onSuccess:
                                            {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    self.itemsArray.removeAllObjects()
                    self.itemsArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "item_lists") as! NSArray) as! [Any])
                    self.InfoTable.reloadSections(IndexSet(integer: 1), with: .none)
                    
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                    
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    print(response.object(forKey: "message") as Any)
                    if self.itemsArray.count > 0
                    {
                        self.noItemsLbl.isHidden = true
                    }else
                    {
                        self.noItemsLbl.isHidden = false
                        
                    }
                    
                }
                self.stopLoadingIndicator(senderVC: self)
                self.InfoTable.cr.endHeaderRefresh()
                self.InfoTable.cr.endLoadingMore()
                
            }, onFailure: {errorResponse in
                self.stopLoadingIndicator(senderVC: self)
                self.showToastAlert(senderVC: self, messageStr: errorResponse?.localizedDescription ?? "")
                self.InfoTable.isHidden = true
            })
            
        }
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == firstTableView
        {
            return 3
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == firstTableView
        {
            return UITableView.automaticDimension
        }
        else
        {
            return 265
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == firstTableView
        {
            self.noItemsLbl.isHidden = true
            if section == 0
            {
                return commonSearchArray.count + 1
            }
            else if section == 1
            {
                return mostPreTimeNameArray.count + 1
            }
            else
            {
                return showResNameArray.count + 1
            }
            
        }
        else
        {
            
//            if section == 0{
//                return 1
//            }else{
                
                if itemsArray.count == 1
                {
                    noOfRows = 1
                    return 1
                    
                }else if itemsArray.count == 0{
                    noOfRows = 0
                    return 1
                }
                else if itemsArray.count % 2 == 0{
                    noOfRows = itemsArray.count/2
                    return itemsArray.count/2
                }
                else{
                    let temp  = itemsArray.count/2 + itemsArray.count % 2
                    noOfRows = temp
                    return temp
                }
                
            }
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == firstTableView
        {
            if indexPath.section == 0
            {
                if indexPath.row == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCuisinesTitleCell") as? FilterCuisinesTitleCell
                    cell?.selectionStyle = .none
                    cell?.titileLbl.text = LanguageDictonary.value(forKey: "showitemwith") as? String
                    return cell!
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCuisinesDetailCell") as? FilterCuisinesDetailCell
                    cell?.selectionStyle = .none
                    cell?.cusineNameLbl.text = commonSearchArray[indexPath.row - 1]
                    
                    if selectedIndexTableSec0.contains(indexPath.row)
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterMostPreferTimeTitleCell") as? FilterMostPreferTimeTitleCell
                    cell?.selectionStyle = .none
                    cell?.titleLbl.text = LanguageDictonary.value(forKey: "timeofday") as? String
                    return cell!
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterMostPreferTimeDetailsCell") as? FilterMostPreferTimeDetailsCell
                    cell?.selectionStyle = .none
                    cell?.mostPreferTimeNameLbl.text = mostPreTimeNameArray[indexPath.row - 1]
                    
                    if selectedIndexTableSec2.contains(indexPath.row)
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
            else
            {
                if indexPath.row == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterShowResTitleCell") as? FilterShowResTitleCell
                    cell?.selectionStyle = .none
                    cell?.titleLbl.text = LanguageDictonary.value(forKey: "category") as? String
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
            
        }
        
        else
        {
//            if indexPath.section == 0
//            {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantInfoTBCell") as? RestaurantInfoTBCell
//                cell?.selectionStyle = .none
//                
//                
//                
//                
//                if responseDict.object(forKey: "category_list") != nil
//                {
//                    if (responseDict.object(forKey: "category_list") as? NSArray)?.count != 0
//                    {
//                        cell?.getCategoryData(result: responseDict)
//                        cell?.delegate = self
//                    }
//                    
//                    if allcategoryItemsStr == "1"
//                    {
//                        cell?.subCategoryBtn.isHidden = true
//                        cell?.subCategoryBtn.isUserInteractionEnabled = false
//                        cell?.subCategoryDropDown.isHidden = true
//                        cell?.subCategoryLineView.isHidden = true
//                    }
//                    else
//                    {
//                        cell?.subCategoryBtn.isHidden = false
//                        cell?.subCategoryBtn.isUserInteractionEnabled = true
//                        cell?.subCategoryDropDown.isHidden = false
//                        cell?.subCategoryLineView.isHidden = false
//                    }
//                    
//                    
//                    
//                    cell?.dishNameTxt.placeholder = LanguageDictonary.value(forKey: "enterdishname") as? String
//                    if self.selAvailableTimeBool == true
//                    {
//                        cell?.preferableItemTextLbl.isHidden = false
//                        let Str = (self.responseDict.object(forKey: "sel_available_time") as! Int)
//                        
//                        let PreferableText = LanguageDictonary.value(forKey: "preferableitems") as! String
//                        
//                        cell?.preferableItemTextLbl.text = PreferableText + " " + mostPreTimeNameArray[Str - 1]
//                    }
//                    else
//                    {
//                        cell?.preferableItemTextLbl.isHidden = true
//                    }
//                }
//                return cell!
//            }
//            else
//            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTwoFoodCell") as? RestaurantTwoFoodCell
                cell?.selectionStyle = .none
                cell?.addOneBtn.setTitle(LanguageDictonary.value(forKey: "add") as? String, for: .normal)
                cell?.addOneBtn.layer.borderWidth = 2
                cell?.addOneBtn.layer.borderColor = UIColor.red.cgColor
                cell?.addOneBtn.setTitleColor(UIColor.red, for: .normal)
                cell?.addOneBtn.layer.backgroundColor = UIColor.white.cgColor
                
                let image3 = UIImage(named: "add")
                
                cell?.addOneBtn.setImage(image3, for: .normal)
                cell?.addOneBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                
                cell?.firstAddBtn.setTitle(LanguageDictonary.value(forKey: "add") as? String, for: .normal)
                cell?.firstAddBtn.layer.borderWidth = 2
                cell?.firstAddBtn.layer.borderColor = UIColor.red.cgColor
                cell?.firstAddBtn.setTitleColor(UIColor.red, for: .normal)
                cell?.firstAddBtn.layer.backgroundColor = UIColor.white.cgColor
                
                cell?.firstAddBtn.setImage(image3, for: .normal)
                cell?.firstAddBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                cell?.NoItemsFound.text = LanguageDictonary.value(forKey: "norecordsfound") as? String
                if itemsArray.count > 0
                {
                    cell?.firstView.isHidden = false
                    cell?.secondView.isHidden = false
                    cell?.NoItemsFound.isHidden = true
                    
                    let actualIndex = indexPath.row + indexPath.row
                    cell?.loadFirstFoodItems(item: itemsArray.object(at: actualIndex)as! NSDictionary)
                    cell?.secondView.isHidden = true
                    if actualIndex+1 < itemsArray.count{
                        cell?.loadSecondFoodItems(item: itemsArray.object(at: actualIndex+1)as! NSDictionary)
                        cell?.secondView.isHidden = false
                    }
                    cell?.firstView.tag = actualIndex
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.gestureTap(_:)))
                    cell?.firstView.addGestureRecognizer(tap)
                    cell?.firstView.isUserInteractionEnabled = true
                    cell?.addOneBtn.tag = actualIndex
                    cell?.addOneBtn.addTarget(self, action: #selector(addOneBtnTapped), for: .touchUpInside)
                    
                    
                    
                    cell?.secondView.tag = actualIndex + 1
                    let firsttap = UITapGestureRecognizer(target: self, action: #selector(self.firstgestureTap(_:)))
                    cell?.secondView.addGestureRecognizer(firsttap)
                    cell?.secondView.isUserInteractionEnabled = true
                    cell?.firstAddBtn.tag = actualIndex + 1
                    cell?.firstAddBtn.addTarget(self, action: #selector(firstAddBtnTapped), for: .touchUpInside)
                    
                }
                else
                {
                    cell?.firstView.isHidden = true
                    cell?.secondView.isHidden = true
                    cell?.NoItemsFound.isHidden = false
                }
                
                return cell!
                
            }
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == noOfRows - 1
            && self.itemsArray.count % 10 == 0
            && !itemLimitReached
            && !isLoadingMore {
            pagingIndex += 1
            if allcategoryItemsStr == "1"
            {
                self.getRestaurantItems()
            }
            else
            {
                self.showItemsBasedOnCategory()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == firstTableView
        {
            print("Filter didselect")
            
            if indexPath.section == 0
            {
                
                if categoryIDArray.contains((commonSearchArray[indexPath.row - 1]))
                {
                    categoryIDArray.remove((commonSearchArray[indexPath.row - 1]))
                    
                    if indexPath.row == 1
                    {
                        orderBy_topOffers = ""
                    }
                    else if indexPath.row == 2
                    {
                        orderBy_splOffers = ""
                    }
                    else if indexPath.row == 3
                    {
                        search_combo = ""
                    }
                    else
                    {
                        search_halal = ""
                    }
                    
                }
                else
                {
                    categoryIDArray.add((commonSearchArray[indexPath.row - 1]))
                    
                    if indexPath.row == 1
                    {
                        orderBy_topOffers = "1"
                    }
                    else if indexPath.row == 2
                    {
                        orderBy_splOffers = "1"
                    }
                    else if indexPath.row == 3
                    {
                        search_combo = "1"
                    }
                    else
                    {
                        search_halal = "1"
                    }
                    
                }
                
                print("orderBy_topOffers : ",orderBy_topOffers)
                print("orderBy_splOffers : ",orderBy_splOffers)
                print("search_combo : ",search_combo)
                print("search_halal : ",search_halal)
                
                
                if selectedIndexTableSec0.contains(indexPath.row)
                    
                {
                    selectedIndexTableSec0.remove(indexPath.row)
                }
                else
                {
                    selectedIndexTableSec0.add(indexPath.row)
                }
                
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                
                UIView.performWithoutAnimation
                {
                    firstTableView.reloadRows(at: [indexPath], with: .none)
                }
                
            }
            
            else if indexPath.section == 1
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
                
                
                if selectedIndexTableSec2.contains(indexPath.row)
                    
                {
                    selectedIndexTableSec2.remove(indexPath.row)
                }
                else
                {
                    selectedIndexTableSec2.add(indexPath.row)
                }
                
                let indexPath = IndexPath(item: indexPath.row, section: 1)
                
                UIView.performWithoutAnimation
                {
                    firstTableView.reloadRows(at: [indexPath], with: .none)
                }
                
            }
            else
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
                }
                
                print("vegNonVegIDArray : ",vegNonVegIDArray)
                
                UIView.performWithoutAnimation
                {
                    firstTableView.reloadSections(IndexSet(integer: indexPathRow), with: .automatic)
                }
                
            }
            
        }
        
    }
    
    @objc func addOneBtnTapped(_ sender: UIButton)
    {
        guard login_session.isUserLogged() else {
            AppRouter.shared.presentLogin(in: self)
            return
        }
        let resultdata = NSMutableDictionary()
        let index = sender.tag
        resultdata.addEntries(from: (itemsArray.object(at: index)as! NSDictionary) as! [AnyHashable : Any])
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
        nextViewController.rest_id = rest_id
        nextViewController.item_id = (resultdata.object(forKey: "item_id") as! NSNumber).stringValue
        nextViewController.itemName = (resultdata.object(forKey: "item_name") as! String)
        
        let Str = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id")
        
        if ((Str as? Int) != nil)
        {
            nextViewController.restaurant_id = ((storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! NSNumber).stringValue
        }
        else if ((Str as? String) != nil)
        {
            nextViewController.restaurant_id = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! String
        }
        
        if isfromMyReviewPage
        {
            self.revealViewController().pushFrontViewController(nextViewController, animated: true)
        }
        else
        {
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @objc func firstAddBtnTapped(_ sender: UIButton)
    {
        guard login_session.isUserLogged() else {
            AppRouter.shared.presentLogin(in: self)
            return
        }
        let resultdata = NSMutableDictionary()
        let index = sender.tag
        resultdata.addEntries(from: (itemsArray.object(at: index)as! NSDictionary) as! [AnyHashable : Any])
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
        nextViewController.rest_id = rest_id
        nextViewController.item_id = (resultdata.object(forKey: "item_id") as! NSNumber).stringValue
        nextViewController.itemName = (resultdata.object(forKey: "item_name") as! String)
        
        
        let Str = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id")
        
        if ((Str as? Int) != nil)
        {
            nextViewController.restaurant_id = ((storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! NSNumber).stringValue
        }
        else if ((Str as? String) != nil)
        {
            nextViewController.restaurant_id = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! String
        }
        
        
        //  nextViewController.restaurant_id = ((storeDict.object(forKey: "restaurant_id")as! NSNumber).stringValue)
        if isfromMyReviewPage
        {
            self.revealViewController().pushFrontViewController(nextViewController, animated: true)
        }
        else
        {
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    
    @objc func gestureTap(_ sender: UITapGestureRecognizer)
    {
        guard login_session.isUserLogged() else {
            AppRouter.shared.presentLogin(in: self)
            return
        }
        let resultdata = NSMutableDictionary()
        let index = sender.view?.tag
        resultdata.addEntries(from: (itemsArray.object(at: index!)as! NSDictionary) as! [AnyHashable : Any])
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
        nextViewController.item_id = (resultdata.object(forKey: "item_id") as! NSNumber).stringValue
        nextViewController.itemName = (resultdata.object(forKey: "item_name") as! String)
        
        let Str = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id")
        
        if ((Str as? Int) != nil)
        {
            nextViewController.restaurant_id = ((storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! NSNumber).stringValue
        }
        else if ((Str as? String) != nil)
        {
            nextViewController.restaurant_id = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! String
        }
        
        if isfromMyReviewPage
        {
            self.revealViewController().pushFrontViewController(nextViewController, animated: true)
        }
        else
        {
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @objc func firstgestureTap(_ sender: UITapGestureRecognizer)
    {
        guard login_session.isUserLogged() else {
            AppRouter.shared.presentLogin(in: self)
            return
        }
        let resultdata = NSMutableDictionary()
        let index = sender.view?.tag
        resultdata.addEntries(from: (itemsArray.object(at: index!)as! NSDictionary) as! [AnyHashable : Any])
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
        nextViewController.item_id = (resultdata.object(forKey: "item_id") as! NSNumber).stringValue
        nextViewController.itemName = (resultdata.object(forKey: "item_name") as! String)
        
        
        
        let Str = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id")
        
        if ((Str as? Int) != nil)
        {
            nextViewController.restaurant_id = ((storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! NSNumber).stringValue
        }
        else if ((Str as? String) != nil)
        {
            nextViewController.restaurant_id = (storeDict.object(forKey: "restaurant_info") as! NSDictionary).value(forKey: "restaurant_id") as! String
        }
        
        
        //nextViewController.restaurant_id = (storeDict.object(forKey: "restaurant_id")as! String)
        if isfromMyReviewPage
        {
            self.revealViewController().pushFrontViewController(nextViewController, animated: true)
        }
        else
        {
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        // self.present(nextViewController, animated:true, completion:nil)
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
        if currentPopUpName == "sort"{
            self.getRestaurantItems()
        }
        if showWorkingHoursView == "true"{
            showWorkingHoursView = "false"
            guard let tempArray = self.responseDict.object(forKey: "working_hours") as? NSArray else {
                self.showToastAlert(senderVC: self, messageStr: "No existen datos")
                return
            }
            let workingHours = WorkingHours(from: tempArray)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WrokingHoursViewController") as! WrokingHoursViewController
            nextViewController.workingHours = workingHours
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}


