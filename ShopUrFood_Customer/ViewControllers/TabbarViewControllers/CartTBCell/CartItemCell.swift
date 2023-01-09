//
//  CartItemCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 25/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
protocol delegateForChoiceRemoveFromCart {
    func showBGLoader()
    func reloadCartData()
}

class CartItemCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var lessBtn: UIButton!
    @IBOutlet weak var removeFromCartBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    var choiceArray = NSMutableArray()
    var mainSection = Int()
    var mainIndex = Int()
    var delegate : delegateForChoiceRemoveFromCart?

    
    
    
    @IBOutlet weak var toppingCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.toppingCollectionView.delegate = self
        self.toppingCollectionView.dataSource = self
        self.quantityView.layer.borderWidth = 0.2
        self.quantityView.layer.borderColor = UIColor.lightGray.cgColor
        self.quantityView.layer.cornerRadius = 5.0
        self.foodImg.layer.cornerRadius = 5.0
        self.foodImg.layer.borderWidth = 0.2
        self.foodImg.layer.borderColor = UIColor.lightGray.cgColor
        self.baseView.layer.borderWidth = 0.2
        self.baseView.layer.borderColor = UIColor.lightGray.cgColor
        self.baseView.layer.cornerRadius = 5.0
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(index:Int,section:Int)
    {
        mainSection = section
        mainIndex = index
        quantityLbl.text = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[index].cartQuantity)
        let foodImgUrl = URL(string: Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[index].productImage)
        foodImg.kf.setImage(with: foodImgUrl)
        foodNameLbl.text = Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[index].productName
        let currency = Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[index].cartCurrency as String
        let price = Singleton.sharedInstance.MyCartModel.data.cartDetails[section].addedItemDetails[index].cartSubTotal as String
        priceLbl.text = "\(currency) \(price)"
        self.tag = section
       
        toppingCollectionView.reloadData()
    }
    
    
    //MARK:- ColloectionView Delegate & DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if Singleton.sharedInstance.MyCartModel.data.cartDetails[mainSection].addedItemDetails[mainIndex].cartHasChoice == "Yes"{
            return Singleton.sharedInstance.MyCartModel.data.cartDetails[mainSection].addedItemDetails[mainIndex].cartChoices.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartToppingCollectionCell", for: indexPath) as! CartToppingCollectionCell
        cell.choiceNameLbl.text = Singleton.sharedInstance.MyCartModel.data.cartDetails[mainSection].addedItemDetails[mainIndex].cartChoices[indexPath.row].choiceName
        cell.choice_closeBtn.tag = (mainIndex*100)+indexPath.row
        cell.choice_closeBtn.addTarget(self, action: #selector(choiceClosedBtnTapped), for: .touchUpInside)

         return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryStr = Singleton.sharedInstance.MyCartModel.data.cartDetails[mainSection].addedItemDetails[mainIndex].cartChoices[indexPath.row].choiceName
        var size = categoryStr!.size(withAttributes: nil)
        size.width = size.width + 40
        size.height = 30
        return size
    }
    @objc func choiceClosedBtnTapped(sender:UIButton){
        let HeaderSection = self.tag
        let section = sender.tag / 100
        let row = sender.tag % 100
        print (section)
        print (row)
        print (HeaderSection)
        self.delegate?.showBGLoader()
        var choiceIdArray = [Int]()
         let categoryStr = Singleton.sharedInstance.MyCartModel.data.cartDetails[HeaderSection].addedItemDetails[section].cartChoices[row].choiceId
        let cartId =  String(Singleton.sharedInstance.MyCartModel.data.cartDetails[HeaderSection].addedItemDetails[section].cartId)
        let productId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[HeaderSection].addedItemDetails[section].productId)

        choiceIdArray.append(categoryStr!)

        let Parse = CommomParsing()
        Parse.removeChoiceFromCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: cartId,product_id: productId, choice_id: choiceIdArray, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.delegate?.reloadCartData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                
            }
        }, onFailure: {errorResponse in})

    }
}
