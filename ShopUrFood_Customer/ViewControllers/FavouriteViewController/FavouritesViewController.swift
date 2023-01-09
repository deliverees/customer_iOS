//
//  FavouritesViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 07/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Lottie

@available(iOS 11.0, *)
class FavouritesViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var emptyAlertLbl: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var favouriteTbl: UITableView!
    var favouriteItemsArray = NSMutableArray()
    var pageIndex = Int()
    var navigationType = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        isfromFavPage = false
//        baseView.layer.cornerRadius = 5.0
//        baseView = self.setCornorShadowEffects(sender: baseView)
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.showLoadingIndicator(senderVC: self)
        pageIndex = 1
        self.GetData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationTitleLbl.text = LanguageDictonary.value(forKey: "favourites") as? String
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        isfromFavPage = false
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
    }
    
    //MARK:- API Methods
    func GetData(){
        let Parse = CommomParsing()
        Parse.getWishList(lang: login_session.value(forKey: "Language") as? String ?? "es",page_no: pageIndex, onSuccess: {
            response in
              print("FAV:::", response)
            if response.object(forKey: "code") as! Int == 200{
                let resultDict = NSMutableDictionary()
                resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                print("FAV:::", resultDict)
                self.favouriteItemsArray.addObjects(from: (resultDict.object(forKey: "product_wish_list")as! NSArray) as! [Any])
                self.favouriteTbl.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else if response.object(forKey: "code")as! Int == 400 && self.pageIndex == 1 {
               // && response.object(forKey: "message")as! String == "Product not available!"
                self.emptyAlertLbl.text = (response.object(forKey: "message")as! String)
                self.setNoitemFound()
            }
            else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func setNoitemFound()  {
        emptyAlertLbl.text = "Product not available!"
        emptyView.isHidden = false
         let tempView = LOTAnimationView(name: "empty-box")
            tempView.frame = CGRect(x:0, y:0, width: 250, height: 250
        )
        
            animationView.addSubview(tempView)
            
            tempView.play()

    }
    
    
    //MARK:- Remove from wishList
    @objc func removeFromWishList(sender:UIButton){
        self.showLoadingIndicator(senderVC: self)
        let selectedIndex = sender.tag
        let product_id  = ((favouriteItemsArray.object(at: selectedIndex)as! NSDictionary).object(forKey: "product_id")as! NSNumber).stringValue
        
        let Parse = CommomParsing()
        Parse.addToWishList(lang: login_session.value(forKey: "Language") as? String ?? "es",product_id: product_id, onSuccess: {
            response in
            if response.object(forKey: "code") as! Int == 200{
                self.favouriteItemsArray.removeObject(at: selectedIndex)
                self.favouriteTbl.reloadSections(IndexSet(integer: 0), with: .automatic)
                if self.favouriteItemsArray.count == 0 {
                    self.setNoitemFound()
                }
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTBCell") as? FavouriteTBCell
        cell?.selectionStyle = .none
        let indexDict = NSMutableDictionary()
        indexDict.addEntries(from: ((favouriteItemsArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any]))
        let foodImg = URL(string: indexDict.object(forKey: "product_image") as! String)
        cell?.food_image.kf.setImage(with: foodImg)
        cell?.food_nameLbl.text = (indexDict.object(forKey: "product_title")as! String)
        let currency = (indexDict.object(forKey: "product_currency_code")as! String)
        if (indexDict.object(forKey: "pro_has_discount")as! String) == "Yes"{
            let offerPrice = (indexDict.object(forKey: "product_original_price")as! NSNumber).stringValue
            let finalPrice = currency + offerPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.offerPriceLbl.attributedText = attributeString
            let discountPrice = (indexDict.object(forKey: "product_discount_price")as! NSNumber).stringValue
            cell?.mainPriceLbl.text = currency + discountPrice
        }else{
            cell?.offerPriceLbl.text = ""
            let offerPrice = (indexDict.object(forKey: "product_original_price")as! NSNumber).stringValue
            cell?.mainPriceLbl.text = currency + offerPrice
           
        }
        cell?.statusLbl.text = (indexDict.object(forKey: "availablity")as! String)
        cell?.descLbl.text = (indexDict.object(forKey: "product_desc")as! String)
        cell?.disLikeBtn.tag = indexPath.row
        cell?.disLikeBtn.addTarget(self, action: #selector(removeFromWishList), for: .touchUpInside)
        cell?.baseView.layer.cornerRadius = 10.0
        cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
        if indexPath.row == self.favouriteItemsArray.count - 1 && self.favouriteItemsArray.count % 10 == 0 {
            pageIndex += 1
            self.GetData()
            
        }

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isfromFavPage = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
        nextViewController.item_id = ((favouriteItemsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "product_id")as! NSNumber).stringValue
        nextViewController.itemName = ((favouriteItemsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "product_title")as! String)
        nextViewController.restaurant_id = ((favouriteItemsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
        
        if self.navigationType == "sidebar" || isfromFavPage
        {
        self.revealViewController().pushFrontViewController(nextViewController, animated: true)
        }
        else
        {
        self.present(nextViewController, animated:true, completion:nil)
        }
    }
   

}
