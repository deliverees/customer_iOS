//
//  RestaurantInfoTBCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 20/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import DropDown

protocol delegateForCategorySearch {
    func showItemsBasedOnCategory()
    func getRestaurantItems()
    func showItemBasedOnName(nameStr:String)
}
class RestaurantInfoTBCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    
    @IBOutlet weak var openStatusLbl: UILabel!
    @IBOutlet weak var minimumOrderLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dishNameTxt: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategoryBtn: UIButton!
    @IBOutlet weak var subCategoryDropDown: UIImageView!
    @IBOutlet weak var subCategoryLineView: UIView!
    @IBOutlet weak var preferableItemTextLbl: UILabel!

    @IBOutlet weak var veg_NonVegSwitch: UISwitch!

    @IBOutlet weak var searchView: UIView!
    var delegate : delegateForCategorySearch?
    var OnceCategoryChanged = Bool()
    
    var responseDict = NSMutableDictionary()
    var categoryIndex = Int()
    var categoryIndexforBGColor = Int()

    var sameFirstcategoryIndexfromDidselect = Int()
    
    var subCategoryArray = NSArray()
    
    //dropDown
    let chooseSubCategoryDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryIndex = 0
        categoryIndexforBGColor = 0
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        searchView.layer.cornerRadius = 17.5
        searchView.clipsToBounds = true
        searchView.layer.borderWidth = 0.5
        searchView.layer.borderColor = AppDarkOrange.cgColor
        dishNameTxt.delegate = self
        OnceCategoryChanged = true
        self.minimumOrderLbl.text = LanguageDictonary.object(forKey: "minimumorder") as! String
        // Initialization code
    }
    func getCategoryData(result:NSMutableDictionary){
        responseDict.addEntries(from: result as! [AnyHashable : Any])
        self.setSubCategoryDropDownData()
        categoryCollectionView.reloadData()
        timeLbl.text = ((responseDict.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "delivery_time")as! String)
        openStatusLbl.text = ((responseDict.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "restaurant_status")as! String)
        let currency = ((responseDict.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "restaurant_currency")as! String)
        let price = ((responseDict.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "minimum_order")as! NSNumber).stringValue
        priceLbl.text = currency + price
        
    }

    @IBAction func veg_NonVegSwitchToggle(_ sender: Any)
    {
        pagingIndex = 1
        if veg_NonVegSwitch.isOn == true
        {
            if categoryIndex == 0
            {
                veg_NonVegItemsStr = "1"
                if sameFirstcategoryIndexfromDidselect == 0
                {
                    allcategoryItemsStr = "1"

                self.delegate?.showItemsBasedOnCategory()
                }
                else
                {
                    allcategoryItemsStr = "0"
                    OnceCategoryChanged = true
                    self.setSubCategoryDropDownData()

                }
            }
            else
            {
                veg_NonVegItemsStr = "1"
                categoryIndex = categoryIndexforBGColor - 1
                allcategoryItemsStr = "0"
                OnceCategoryChanged = true
                self.setSubCategoryDropDownData()
                
            }
            categoryCollectionView.reloadData()

        }
        else
        {
            if categoryIndex == 0
            {
                veg_NonVegItemsStr = ""
                if sameFirstcategoryIndexfromDidselect == 0
                {
                    allcategoryItemsStr = "1"
                self.delegate?.showItemsBasedOnCategory()
                }
                else
                {
                    allcategoryItemsStr = "0"
                    OnceCategoryChanged = true
                    self.setSubCategoryDropDownData()

                }
            }else
            {
                veg_NonVegItemsStr = ""
                categoryIndex = categoryIndexforBGColor - 1
                allcategoryItemsStr = "0"
                OnceCategoryChanged = true
                self.setSubCategoryDropDownData()
                
            }
            categoryCollectionView.reloadData()

        }
    }
    
    //MARK:- DropDown Delegate Methods
    func setSubCategoryDropDownData()
    {
        //get Datas
        let strArray = self.responseDict.object(forKey: "category_list")as! NSArray
        let StrmutableArray = strArray.mutableCopy() as! NSMutableArray
        let subCateArray = (StrmutableArray.object(at: categoryIndex)as! NSDictionary).object(forKey: "sub_category_list")as! NSArray
        //self.subCategoryArray.addObjects(from: [subCateArray.value(forKey: "sub_category_name")])
        self.subCategoryArray = subCateArray.value(forKey: "sub_category_name") as! NSArray
        self.subCategoryBtn.setTitle((subCategoryArray[0] as! String), for: .normal)
        
        let subCategoryIDArray = subCateArray.value(forKey: "sub_category_id") as! NSArray
        sub_category_id = subCategoryIDArray[0]as! NSNumber
        main_category_id = (StrmutableArray.object(at: categoryIndex)as! NSDictionary).object(forKey: "main_category_id")as! NSNumber
        if OnceCategoryChanged{
            OnceCategoryChanged = false
            self.delegate?.showItemsBasedOnCategory()
        }
        
        //alloc data to dropdown
        chooseSubCategoryDropDown.dataSource = subCategoryArray as! [String]
        chooseSubCategoryDropDown.anchorView = subCategoryBtn
        chooseSubCategoryDropDown.direction = .bottom
        chooseSubCategoryDropDown.bottomOffset = CGPoint(x: 0, y: subCategoryBtn.bounds.height)
        // Action triggered on selection
        chooseSubCategoryDropDown.selectionAction = { [weak self] (index, item) in
            self?.subCategoryBtn.setTitle(item, for: .normal)
            sub_category_id = subCategoryIDArray[index]as! NSNumber
            self!.delegate?.showItemsBasedOnCategory()
        }
    }
    
    @IBAction func subCategoryBtnAction(_ sender: Any) {
        chooseSubCategoryDropDown.show()
    }
    
    //MARK:- ColloectionView Delegate & DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if responseDict.object(forKey: "category_list") != nil{
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return (responseDict.object(forKey: "category_list")as! NSArray).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCategoryCell", for: indexPath) as! RestaurantCategoryCell
        let strArray = responseDict.object(forKey: "category_list")as! NSArray
        let StrmutableArray = strArray.mutableCopy() as! NSMutableArray
        if indexPath.row == 0{
            cell.categoryNameLbl.text = "All"
        }else{
        cell.categoryNameLbl.text = ((StrmutableArray.object(at: indexPath.row-1)as! NSDictionary).object(forKey: "main_category_name")as! String)
        }
        cell.categoryNameLbl.cornerRadius = 15.0
        
        cell.categoryNameLbl.layer.borderWidth = 0.5
        if categoryIndexforBGColor == indexPath.row{
            cell.categoryNameLbl.backgroundColor = AppLightOrange
            cell.categoryNameLbl.textColor = UIColor.white
             cell.categoryNameLbl.layer.borderColor = AppDarkOrange.cgColor
        }else{
            cell.categoryNameLbl.backgroundColor = UIColor.white
            cell.categoryNameLbl.textColor = UIColor.darkText
            cell.categoryNameLbl.layer.borderColor = AppDarkOrange.cgColor
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let strArray = responseDict.object(forKey: "category_list")as! NSArray
        let StrmutableArray = strArray.mutableCopy() as! NSMutableArray
        var categoryStr = String()
        if indexPath.row == 0
        {
        categoryStr = "All"
        }
        else
        {
        categoryStr = (StrmutableArray.object(at: indexPath.row - 1)as! NSDictionary).object(forKey: "main_category_name")as! String
        }
        var size = categoryStr.size(withAttributes: nil)
        size.width = size.width + 100
        size.height = 30
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pagingIndex = 1
        categoryIndex = indexPath.row
        categoryIndexforBGColor = indexPath.row
        if categoryIndex == 0
        {
            OnceCategoryChanged = false
            pagingIndex = 1
            sameFirstcategoryIndexfromDidselect = 0
            allcategoryItemsStr = "1"
            //self.delegate?.showItemsBasedOnCategory()
            self.delegate?.getRestaurantItems()
        }
        else
        {
            OnceCategoryChanged = true
            pagingIndex = 1
           sameFirstcategoryIndexfromDidselect = 1
           categoryIndex = categoryIndex - 1
           allcategoryItemsStr = "0"
           self.setSubCategoryDropDownData()
        }
        
        categoryCollectionView.reloadData()
    }
    
    //MARK:- TextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text typing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            pagingIndex = 1
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            self.delegate?.showItemBasedOnName(nameStr: updatedText)
        }
        return true
    }

}
