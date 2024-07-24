//
//  HomeViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import QuartzCore
import MarqueeLabel
import ListPlaceholder

@available(iOS 11.0, *)
class HomeViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var topNavigationView: UIView!
    
    @IBOutlet weak var secondViewAll: UIButton!
    @IBOutlet weak var allResturants: UIButton!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var categoryThreeViewAllBtn: UIButton!
    @IBOutlet weak var categoryTwoViewAllBtn: UIButton!
    @IBOutlet weak var noRestLbl: UILabel!
    
    @IBOutlet weak var featureCollectionViewBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var locationLbl: MarqueeLabel!
    @IBOutlet weak var firstCategoryNameLbl: UILabel!
    
    @IBOutlet weak var topUserNameLbl: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var thirdCategoryNameLbl: UILabel!
    @IBOutlet weak var secondCategoryNameLbl: UILabel!
    @IBOutlet weak var food_three_collectionView: UICollectionView!
    @IBOutlet weak var food_two_collectionView: UICollectionView!
    @IBOutlet weak var shop_collectionView: UICollectionView!
    @IBOutlet weak var food_collectionView: UICollectionView!
    @IBOutlet weak var resturantsCollectionView: UICollectionView! //restaurant_rating //delivery_time
    @IBOutlet weak var categories_collectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var staticResturentLbl: UILabel!
    
    @IBOutlet weak var featuredLblStatic: UILabel!
    
    let reuseIdentifier = "Home_Resturants_collection_cell"
    let catIdentifier = "Home_Categories_Collection_Cell"
    
    //Search Views
    @IBOutlet weak var searchGrayView: UIView!
    @IBOutlet weak var searchTopView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBackButton: UIButton!
    @IBOutlet weak var searchRTextField: UITextField!
    
    //PROMOTIONAL OFFERS VIEW
    @IBOutlet weak var promotionalOfferBGView: UIView!
    @IBOutlet weak var promotionalOfferPopupView: UIView!
    @IBOutlet weak var promotionalOfferTxtLbl: UILabel!
    @IBOutlet weak var promotionalHeaderTxtLbl: UILabel!
    @IBOutlet weak var promotionalOfferOkayButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    var searchTxtStr:String = ""
    var pagingIndex = Int()
    var resSelectedBool = Bool()
    var resultsArray = NSMutableArray()
    
    var promotionOffersDict = NSMutableDictionary()
    
    @IBOutlet weak var btnAllHome: UIImageView!
    @IBOutlet weak var btnAllRestaurantsHome: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allResturants.setTitle(LanguageDictonary.value(forKey: "viewall") as? String, for: .normal)
        self.allResturants.isHidden = true
        
        self.secondViewAll.setTitle(LanguageDictonary.value(forKey: "viewall") as? String, for: .normal)
        self.secondViewAll.isHidden = true
        
        self.categoryTwoViewAllBtn.setTitle(LanguageDictonary.value(forKey: "viewall") as? String, for: .normal)
        self.categoryTwoViewAllBtn.isHidden = true
        self.categoryThreeViewAllBtn.setTitle(LanguageDictonary.value(forKey: "viewall") as? String, for: .normal)
        self.categoryThreeViewAllBtn.isHidden = true
        
        self.promotionalOfferOkayButton.setTitle(LanguageDictonary.value(forKey: "okaygotit") as? String, for: .normal)
        self.staticResturentLbl.text =  LanguageDictonary.value(forKey: "featured") as? String
        //self.staticResturentLbl.isHidden = true
        self.noRestLbl.text =  LanguageDictonary.value(forKey: "No Restaurant found in your location. try new location") as? String
        self.featuredLblStatic.text =  LanguageDictonary.value(forKey: "featuredresturants") as? String
        self.featuredLblStatic.isHidden = true
        isfromShippingAddressPage = false
        self.getHomeDataFromAPI()
        self.searchGrayView.isHidden = true
        
        if revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.width-80
            menuBtn.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        locationLbl.tag = 101
        locationLbl.type = .continuous
        locationLbl.animationCurve = .easeInOut
        locationLbl.speed = .rate(40)
        locationLbl.fadeLength = 10.0
        locationLbl.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapLocationLbl))
        locationLbl.addGestureRecognizer(tap)
        
        actAsBaseTabbar = self.tabBarController!
        
        searchRTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let rectShape1 = CAShapeLayer()
        rectShape1.bounds = promotionalOfferPopupView.frame
        rectShape1.position = promotionalOfferPopupView.center
        rectShape1.path = UIBezierPath(roundedRect: promotionalOfferPopupView.bounds, byRoundingCorners: [UIRectCorner.topLeft , UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 20, height: 20)).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.frame = promotionalOfferPopupView.bounds
        maskLayer.path = rectShape1.path
        
        // Set the newly created shape layer as the mask for the image view's layer
        promotionalOfferPopupView.layer.mask = maskLayer
        
        let tapGestureRecognizerBtnAllHome = UITapGestureRecognizer(target: self, action: #selector(imagedTapedBtnAllHome(tapGestureRecognizer:)))
        
        //btnAllHome.isUserInteractionEnabled = true
        //btnAllHome.addGestureRecognizer(tapGestureRecognizerBtnAllHome)
        
        //let tapGestureRecognizerBtnAllRestaurantsHome = UITapGestureRecognizer(target: self, action: #selector(imagedTapedBtnAllRestaurantsHome(tapGestureRecognizer:)))
        
        //btnAllRestaurantsHome.isUserInteractionEnabled = true
        //btnAllRestaurantsHome.addGestureRecognizer(tapGestureRecognizerBtnAllRestaurantsHome)
        
        //btnAllRestaurantsHome.alpha = 0.5
        
        view.addSubview(fb)
        
        fb.addTarget(self, action: #selector(onClickFB), for: .touchUpInside)
    }
    
    @objc func imagedTapedBtnAllHome(tapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        btnAllHome.alpha = 1
        btnAllRestaurantsHome.alpha = 0.5
    }
    
    @objc func imagedTapedBtnAllRestaurantsHome(tapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        btnAllHome.alpha = 0.5
        btnAllRestaurantsHome.alpha = 1
    }
    
    @objc func onClickFB() {
        actAsBaseTabbar.selectedIndex = 0
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
    }
    
    let fb: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        button.backgroundColor = .white
        
        //let image = UIImage(systemName: "cartfb", withConfiguration: UIImage.SymbolConfiguration(pointSize: 48, weight: .medium))
        
        let image = UIImage(named: "cartfb")
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24.0)
        
        let adjustedImage = image?.applyingSymbolConfiguration(symbolConfiguration)
        
        //let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        //let image2 = UIImage(named: "cart_fb")
        //imageView2.image = image2
        //passwordTxt.leftView = imageView2
        
        button.setImage(adjustedImage, for: .normal)
        
        //button.imageView = imageView2
        
        //button.tintColor = .red
        //button.setTitleColor(.red, for: .normal)
        //button.layer.shadowRadius = 10
        //button.layer.shadowOpacity = 0.3
        
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        
        button.layer.cornerRadius = 30
        
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fb.frame = CGRect(x: view.frame.size.width - 70,
                          y: view.frame.size.height - 160,
                          width: 60,
                          height: 60)
    }
    
    //MARK: - UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //shouldShowResults = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        if textField.text == ""
        {
            self.searchTableView.isHidden = true
        }
        textField.resignFirstResponder()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text!.count == 1
        {
            searchTxtStr = textField.text!
            self.pagingIndex = 1
            self.searchTableView.isHidden = false
            getSearchData()
        }
        
        if textField.text! == ""
        {
            self.searchTableView.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        if textField.text! != ""
        {
            searchTxtStr = updatedTextString as String
            self.pagingIndex = 1
            self.searchTableView.isHidden = false
            getSearchData()
        }
        else
        {
            searchTxtStr = ""
            self.pagingIndex = 1
            self.searchTableView.isHidden = true
            getSearchData()
        }
        return true
    }
    
    
    @objc func didTapLocationLbl(sender: UITapGestureRecognizer)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func viewAllRestauranBtnTapped(_ sender: Any) {
        actAsBaseTabbar.selectedIndex = 1
    }
    
    //get Greeting Text
    func greetingLogic() -> String{
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!
        var greeting = String()
        
        if hourInt >= 12 && hourInt <= 16 {
            greeting = LanguageDictonary.object(forKey: "goodafternoon") as! String
        }
        else if hourInt >= 7 && hourInt <= 12 {
            greeting = LanguageDictonary.object(forKey: "goodmorning") as! String
        }
        else if hourInt >= 16 && hourInt <= 20 {
            greeting = LanguageDictonary.object(forKey: "goodevening") as! String
        }
        else if hourInt >= 20 && hourInt <= 24 {
            greeting = LanguageDictonary.object(forKey: "goodevening") as! String
        }
        if let userName = login_session.object(forKey: "user_name") as? String {
            greeting = greeting + ", " + userName
        }
        
        return greeting
    }
    
    
    @IBAction func locationBtnAction(_ sender: Any) {
        
        self.promotionalOfferBGView.isHidden = true
        
        //        let Parse = CommomParsing()
        //        Parse.commonTest(u_email:"lakshmi@pofitec.com",u_psd:"Lk123456",device_type:"ios",u_key:"121", onSuccess: {
        //            response in
        //            print (response)
        //        }, onFailure: {errorResponse in
        //            print (errorResponse?.localizedDescription as Any)
        //        })
        //
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func viewAllOne(_ sender: Any) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
        nav?.selectedIndex = 0
        nav?.categoryName = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[0].categoryName
        nav?.categoryId =  String(Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[0].categoryId)
        self.navigationController?.pushViewController(nav!, animated: true)
    }
    @IBAction func viewAllTwo(_ sender: Any) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
        nav?.selectedIndex = 1
        nav?.categoryName = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].categoryName
        nav?.categoryId =  String(Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].categoryId)
        self.navigationController?.pushViewController(nav!, animated: true)
    }
    
    @IBAction func viewAllThree(_ sender: Any) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
        nav?.selectedIndex = 2
        nav?.categoryName = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].categoryName
        nav?.categoryId =  String(Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].categoryId)
        self.navigationController?.pushViewController(nav!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        locationLbl.text = (login_session.object(forKey: "user_address")as! String)
        self.topUserNameLbl.text = self.greetingLogic()
        self.navigationController?.navigationBar.isHidden = true
        if isfromShippingAddressPage
        {
            isfromShippingAddressPage = false
            getHomeDataFromAPI()
        }
        let cartCount = login_session.object(forKey: "userCartCount") as? String ?? "0"
        if (cartCount == "0"){
            actAsBaseTabbar.tabBar.items?[0].badgeValue = nil
        }else{
            actAsBaseTabbar.tabBar.items?[0].badgeValue = cartCount
            actAsBaseTabbar.tabBar.items?[0].badgeColor = AppDarkOrange
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PermissionsManager.shared.requestAuthorizationAndNotificationsPermissions()
        fb.isHidden = !login_session.isUserLogged()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        promotionalOfferBGView.isHidden = true
    }
    
    //MARK:- Calling API methods
    func getHomeDataFromAPI(){
        // self.showLoadingIndicator(senderVC: self)
        self.showCollectionLoader()
        let Parse = CommomParsing()
        Parse.Resturant_Home_Pasre(lang: login_session.value(forKey: "Language") as? String ?? "es", user_latitude: String(describing:login_session.object(forKey: "user_latitude") as AnyObject), user_longitude: String(describing: login_session.object(forKey: "user_longitude") as AnyObject), onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let mod = ResturantHome(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.resturantHomeModel = mod
                
                if ((response.object(forKey: "data")as! NSDictionary).value(forKey: "offers") as? NSDictionary) != nil
                {
                    self.promotionOffersDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary).value(forKey: "offers") as! [AnyHashable : Any])
                    self.promotionalOfferBGView.isHidden = false
                    self.promotionalOfferTxtLbl.text = self.promotionOffersDict.value(forKey: "description") as? String
                    self.promotionalHeaderTxtLbl.text = self.promotionOffersDict.value(forKey: "title") as? String
                }
                else
                {
                    self.promotionalOfferBGView.isHidden = true
                    
                }
                
                self.hideCollectionLoader()
                self.LoadHeaderTxt()
                self.resturantsCollectionView.reloadData()
                self.categories_collectionView.reloadData()
                self.food_collectionView.reloadData()
                self.shop_collectionView.reloadData()
                //self.food_two_collectionView.reloadData()
                //self.food_three_collectionView.reloadData()
                self.resturantsCollectionView.isHidden = false
                self.food_collectionView.isHidden = false
                self.shop_collectionView.isHidden = true
                self.food_two_collectionView.isHidden = true
                self.food_three_collectionView.isHidden = true
                self.noItemsView.isHidden = true
                self.checkUIwithData()
            }else if response.object(forKey: "code") as! Int == 400{
                if response.object(forKey: "message")as! String == "Token is Expired"{
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    self.tokenExpired()
                }else{
                    self.hideCollectionLoader()
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    self.resturantsCollectionView.isHidden = true
                    self.food_collectionView.isHidden = true
                    self.shop_collectionView.isHidden = true
                    self.food_two_collectionView.isHidden = true
                    self.noItemsView.isHidden = false
                    
                }
                //print(response.object(forKey: "message") as Any)
            }
        }, onFailure: {errorResponse in
            
        })
    }
    
    
    //MARK:- API Methods
    func getSearchData()
    {
        //self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getHomeSearchData(lang: login_session.value(forKey: "Language") as? String ?? "es",search_key: searchTxtStr, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.LoadTopData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func LoadTopData(resultDict:NSMutableDictionary)
    {
        resultsArray.removeAllObjects()
        resultsArray.addObjects(from: (resultDict.object(forKey: "search_list")as! NSArray) as! [Any])
        print("resultsArray", resultsArray)
        if resultsArray.count == 0
        {
            // searchTableView.isHidden = true
        }
        else
        {
            //searchTableView.isHidden = false
        }
        searchTableView.reloadData()
    }
    
    
    func showCollectionLoader()
    {
        resturantsCollectionView.reloadData()
        resturantsCollectionView.layoutIfNeeded()
        self.resturantsCollectionView.showLoader()
        
        
        food_collectionView.reloadData()
        food_collectionView.layoutIfNeeded()
        self.food_collectionView.showLoader()
        
        shop_collectionView.reloadData()
        shop_collectionView.layoutIfNeeded()
        self.shop_collectionView.showLoader()
        
        categories_collectionView.reloadData()
        categories_collectionView.layoutIfNeeded()
        self.categories_collectionView.showLoader()
        
        /*food_two_collectionView.reloadData()
         food_two_collectionView.layoutIfNeeded()
         self.food_two_collectionView.showLoader()
         
         food_three_collectionView.reloadData()
         food_three_collectionView.layoutIfNeeded()
         self.food_three_collectionView.showLoader()*/
    }
    func checkUIwithData()
    {
        if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count < 2{
            //self.featureCollectionViewBottomHeight.constant = 20.0
            secondCategoryNameLbl.isHidden = true
            thirdCategoryNameLbl.isHidden = true
            categoryTwoViewAllBtn.isHidden = true
            categoryThreeViewAllBtn.isHidden = true
        }
        else if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count == 2
        {
            self.featureCollectionViewBottomHeight.constant = 400.0
            secondCategoryNameLbl.isHidden = true
            categoryTwoViewAllBtn.isHidden = true
            thirdCategoryNameLbl.isHidden = true
            categoryThreeViewAllBtn.isHidden = true
        }
        else{
            self.featureCollectionViewBottomHeight.constant = 740.0
            secondCategoryNameLbl.isHidden = true
            thirdCategoryNameLbl.isHidden = true
            categoryTwoViewAllBtn.isHidden = true
            categoryThreeViewAllBtn.isHidden = true
        }
    }
    func hideCollectionLoader()  {
        self.resturantsCollectionView.hideLoader()
        self.food_collectionView.hideLoader()
        self.shop_collectionView.hideLoader()
        self.food_two_collectionView.hideLoader()
        self.food_three_collectionView.hideLoader()
        self.categories_collectionView.hideLoader()
    }
    
    func LoadHeaderTxt()
    {
        /*firstCategoryNameLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[0].categoryName.uppercased()
         firstCategoryNameLbl.isHidden = true
         if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count >= 2 {
         secondCategoryNameLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].categoryName.uppercased()
         }
         if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count >= 3 {
         thirdCategoryNameLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].categoryName.uppercased()
         }*/
    }
    
    //MARK:- UITableView Delegate & DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.resultsArray.count > 0
        {
            return resultsArray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ((self.resultsArray[section] as AnyObject).value(forKey: "item_list") as! NSArray).count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell") as? RestaurantListTableViewCell
            cell?.selectionStyle = .none
            cell?.restaurantSelectedButtons.tag = indexPath.section
            cell?.restaurantSelectedButtons.addTarget(self,action:#selector(restaurantBtnClicked(sender:)), for: .touchUpInside)
            
            cell?.restaurantNameLbl.text = ((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "store_name") as? String)
            return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as? ItemListTableViewCell
            cell?.selectionStyle = .none
            cell?.itemNameLbl.text = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "item_list") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "item_name") as! String)
            
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.section)
        print(indexPath.row)
        
        if indexPath.row > 0
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
            nextViewController.item_id = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "item_list") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "item_id") as! String)
            nextViewController.itemName = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "item_list") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "item_name") as! String)
            nextViewController.restaurant_id = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "store_id") as? NSNumber)!.stringValue))
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @objc func restaurantBtnClicked(sender:UIButton)
    {
        let buttonRow = sender.tag
        print("buttonRow is:",buttonRow)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
        nextViewController.rest_id = ((((self.resultsArray[buttonRow] as AnyObject).value(forKey: "store_id") as? NSNumber)!.stringValue))
        nextViewController.storeName = (((self.resultsArray[buttonRow] as AnyObject).value(forKey: "store_name") as? String)!)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK:- ColloectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // This is the minimum inter item spacing, can be more
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Singleton.sharedInstance.categoriesHomeModel != nil {
            print(Singleton.sharedInstance.categoriesHomeModel)
        }
        if Singleton.sharedInstance.resturantHomeModel != nil{
            if collectionView == resturantsCollectionView{
                return Singleton.sharedInstance.resturantHomeModel.data.allRestaurant.count
            }else if collectionView == food_collectionView{
                
                var _count = 0
                
                var allCats = true
                
                if cat_selected == 0 {
                    allCats = true
                } else {
                    allCats = false
                }
                
                for index in 0..<Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count {
                    
                    var cat_id = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[index].categoryId
                    
                    if allCats == false && cat_id != cat_selected {
                        continue
                    }
                    
                    let ard = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[index].restaurantDetails.count
                    _count = _count + ard
                }
                
                return _count
            }else if collectionView == shop_collectionView{
                return Singleton.sharedInstance.resturantHomeModel.data.featuredRestaurant.count
            } else if collectionView == categories_collectionView{
                print(Singleton.sharedInstance.resturantHomeModel.data.category_list.count)
                return Singleton.sharedInstance.resturantHomeModel.data.category_list.count
            } else if collectionView == food_two_collectionView{
                if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count >= 2{
                    return Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails.count
                }else{
                    return 0
                }
            }else {
                /*if Singleton.sharedInstance.resturantHomeModel.data.category_list.count >= 3{
                 return Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails.count
                 }
                 else{
                 return 0
                 }*/
                return 0
            }
        }else{
            return 4
        }
    }
    
    var cat_selected = 0
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == resturantsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Home_Resturants_collection_cell
            
            cell.resturantImg.layer.cornerRadius = 5.0
            cell.ImgBGView.layer.cornerRadius = 5.0
            cell.resturantImg.layer.borderWidth = 0.5
            cell.resturantImg.layer.borderColor = UIColor.lightGray.cgColor
            
            if Singleton.sharedInstance.resturantHomeModel != nil {
                let rest_img = URL(string: Singleton.sharedInstance.resturantHomeModel.data.allRestaurant[indexPath.row].restaurantLogo)
                cell.resturantImg.kf.setImage(with:rest_img!)
                //cell.ImgBGView.backgroundColor = BlackTranspertantColor
                cell.resturantNameLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurant[indexPath.row].restaurantName
            }
            cell.layer.cornerRadius = 5.0
            return cell
        }else if collectionView == categories_collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: catIdentifier, for: indexPath) as! Home_Categories_Collection_Cell
            
            cell.category_image.layer.cornerRadius = 5.0
            
            if Singleton.sharedInstance.resturantHomeModel != nil {
                if cat_selected == Singleton.sharedInstance.resturantHomeModel.data.category_list[indexPath.row].categoryId {
                    cell.category_image.alpha = 1
                } else {
                    cell.category_image.alpha = 0.5
                }
                
                if (indexPath.row != 0) {
                    let rest_img = URL(string: Singleton.sharedInstance.resturantHomeModel.data.category_list[indexPath.row].categoryImage)
                    cell.category_image.kf.setImage(with:rest_img!)
                    //cell.ImgBGView.backgroundColor = BlackTranspertantColor
                } else {
                    let imageName = Singleton.sharedInstance.resturantHomeModel.data.category_list[indexPath.row].categoryImage
                    cell.category_image.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
                    cell.category_image.image = UIImage.init(named: imageName!)
                }
                cell.category_name.text = Singleton.sharedInstance.resturantHomeModel.data.category_list[indexPath.row].categoryName
            }
            cell.layer.cornerRadius = 5.0
            return cell
        }else if collectionView == food_collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionCell", for: indexPath) as! FoodCollectionCell
            
            if Singleton.sharedInstance.resturantHomeModel != nil{
                
                var allRestaurantDetails = [RestaurantDetail]()
                
                var allCats = true
                
                if cat_selected == 0 {
                    allCats = true
                } else {
                    allCats = false
                }
                
                for index in 0..<Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.count {
                    var cat_id = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[index].categoryId
                    
                    var ard = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[index].restaurantDetails
                    
                    for idx in 0..<ard!.count {
                        
                        if allCats == false && cat_id != cat_selected {
                            continue
                        }
                        
                        var dictionary = [String:Any]()
                        
                        dictionary["restaurant_desc"] = ard![idx].restaurantDesc
                        dictionary["restaurant_id"] = ard![idx].restaurantId
                        dictionary["restaurant_image"] = ard![idx].restaurantImage
                        dictionary["restaurant_name"] = ard![idx].restaurantName
                        dictionary["restaurant_rating"] = ard![idx].restaurantRating
                        dictionary["restaurant_status"] = ard![idx].restaurantStatus
                        dictionary["today_wking_time"] = ard![idx].todayWkingTime
                        dictionary["delivery_time"] = ard![idx].deliveryTime
                        dictionary["cat_id"] = cat_id
                        
                        let value = RestaurantDetail(fromDictionary: dictionary)
                        allRestaurantDetails.append(value)
                    }
                    
                }
                
                print(indexPath.row)
                
                let ard = allRestaurantDetails[indexPath.row]
                
                let food_img = ard.restaurantImage.replacingOccurrences(of: " ", with: "%20")
                if let food_img = URL(string: food_img) {
                    cell.foodImg.kf.setImage(with: food_img)
                } else {
                    cell.foodImg.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
                    cell.foodImg.image = UIImage.init(named: "2019-11-6")
                }
                
                cell.food_titleLbl.text = ard.restaurantName
                cell.lblDeliverTime.text = ard.deliveryTime
                
                let rating = ard.restaurantRating
                if (rating == 0) {
                    cell.lblRestaurantRating.text = LanguageDictonary.value(forKey: "noratings") as? String
                } else {
                    cell.lblRestaurantRating.text = "\(rating)"
                }
                
                if ard.restaurantRating == 0{
                    cell.ratingStar.isHidden = false
                    cell.ratingValueLbl.isHidden = true
                }else{
                    cell.ratingStar.isHidden = true
                    cell.ratingValueLbl.isHidden = false
                    cell.ratingValueLbl.text = String(format: "%d", ard.restaurantRating)
                }
                
            }
            // code shadow effects
            cell.layer.cornerRadius = 5.0
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.6
            let containerView = cell.baseView!
            containerView.layer.cornerRadius = 5
            containerView.clipsToBounds = true
            return cell
            
        }else if collectionView == food_two_collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionCell", for: indexPath) as! FoodCollectionCell
            
            if Singleton.sharedInstance.resturantHomeModel != nil{
                let food_img = URL(string: Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantImage)
                cell.foodImg.kf.setImage(with: food_img)
                cell.food_titleLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantName
                //cell.ratingsLbl.text = String(format: "%d", Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantRating)
                cell.openTimeLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].todayWkingTime
                cell.shopLocationLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantDesc
                
                if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantRating == 0{
                    cell.ratingStar.isHidden = false
                    cell.ratingValueLbl.isHidden = true
                }else{
                    cell.ratingStar.isHidden = true
                    cell.ratingValueLbl.isHidden = false
                    cell.ratingValueLbl.text = String(format: "%d", Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantRating)
                }
            }
            
            // code shadow effects
            cell.layer.cornerRadius = 5.0
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.6
            let containerView = cell.baseView!
            containerView.layer.cornerRadius = 5
            containerView.clipsToBounds = true
            return cell
        }
        else if collectionView == shop_collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionCell", for: indexPath) as! StoreCollectionCell
            if Singleton.sharedInstance.resturantHomeModel != nil{
                let shop_img = URL(string: Singleton.sharedInstance.resturantHomeModel.data.featuredRestaurant[indexPath.row].restaurantLogo)
                cell.storeImg.kf.setImage(with: shop_img)
            }
            cell.layer.cornerRadius = 5.0
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.6
            let containerView = cell.baseView!
            containerView.layer.cornerRadius = 35.0
            containerView.clipsToBounds = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionCell", for: indexPath) as! FoodCollectionCell
            
            if Singleton.sharedInstance.resturantHomeModel != nil{
                let food_img = URL(string: Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantImage)
                cell.foodImg.kf.setImage(with: food_img)
                cell.food_titleLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantName
                //cell.ratingsLbl.text = String(format: "%d", Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantRating)
                cell.openTimeLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].todayWkingTime
                cell.shopLocationLbl.text = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantDesc
                if Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantRating == 0{
                    cell.ratingStar.isHidden = false
                    cell.ratingValueLbl.isHidden = true
                }else{
                    cell.ratingStar.isHidden = true
                    cell.ratingValueLbl.isHidden = false
                    cell.ratingValueLbl.text = String(format: "%d", Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantRating)
                }
                
            }
            
            // code shadow effects
            cell.layer.cornerRadius = 5.0
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.6
            let containerView = cell.baseView!
            containerView.layer.cornerRadius = 5
            containerView.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var rest_id = String()
        var cat_id = String()
        var storeName = String()
        if(collectionView == resturantsCollectionView){ //primer grid el que es horizontal
            storeName = Singleton.sharedInstance.resturantHomeModel.data.allRestaurant[indexPath.row].restaurantName
            rest_id = String(Singleton.sharedInstance.resturantHomeModel.data.allRestaurant[indexPath.row].restaurantId)
        }else if collectionView == food_collectionView{ //segundo grid el que es vertical
            if cat_selected == 0 { // All categories selected, so we need to unwrap categorized array to a single one. The trick done in cellForItem must be improved
                let allRestaurantsDetails = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.flatMap({
                    $0.compactMap(\.restaurantDetails)
                })?.flatMap({ $0 })
                guard let restaurant = allRestaurantsDetails?[indexPath.row] else {
                    return
                }
                storeName = restaurant.restaurantName
                rest_id = String(restaurant.restaurantId)
            } else {
                guard let categoryRestaurantDetails = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails.first (where: { det in
                    det.categoryId == cat_selected
                }) else {
                    return
                }
                storeName = categoryRestaurantDetails.restaurantDetails[indexPath.row].restaurantName
                rest_id = String(categoryRestaurantDetails.restaurantDetails[indexPath.row].restaurantId)
            }
        }else if collectionView == food_two_collectionView{
            storeName = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantName
            rest_id = String(Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[1].restaurantDetails[indexPath.row].restaurantId)
        }else if collectionView == food_three_collectionView{
            storeName = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantName
            rest_id = String(Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[2].restaurantDetails[indexPath.row].restaurantId)
        }else if collectionView == categories_collectionView{
            storeName = Singleton.sharedInstance.resturantHomeModel.data.category_list[indexPath.row].categoryName
            let cat_id_selected = Singleton.sharedInstance.resturantHomeModel.data.category_list[indexPath.row].categoryId
            
            cat_selected = cat_id_selected!
            
            self.food_collectionView.reloadData()
            self.categories_collectionView.reloadData()
            //let filter = Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[0].restaurantDetails.filter({ $0.restaurantId == cat_id, options: .caseInsensitive) != nil})
            
            return
        }else{
            storeName = Singleton.sharedInstance.resturantHomeModel.data.featuredRestaurant[indexPath.row].restaurantName
            rest_id = String(Singleton.sharedInstance.resturantHomeModel.data.featuredRestaurant[indexPath.row].restaurantId)
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
        nextViewController.rest_id = rest_id
        nextViewController.storeName = storeName
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func promotionOfferOkBtnTapped(_ sender: Any)
    {
        promotionalOfferBGView.isHidden = true
    }
    
    
    
    @IBAction func searchBackBtnTapped(_ sender: Any)
    {
        self.searchGrayView.isHidden = true
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any)
    {
        self.promotionalOfferBGView.isHidden = true
        self.searchGrayView.isHidden = false
        if self.searchTxtStr == ""
        {
            self.searchTableView.isHidden = true
        }
    }
    
}




extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
