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
    func hideBGLoader()
    func reloadCartData()
}

class CartItemCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var lessBtn: UIButton!
    @IBOutlet weak var removeFromCartBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var choicesStackView: UIStackView!
    
    var choiceArray = NSMutableArray()
    var mainSection = Int()
    var mainIndex = Int()
    var delegate : delegateForChoiceRemoveFromCart?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quantityView.layer.borderWidth = 0.2
        self.quantityView.layer.borderColor = UIColor.lightGray.cgColor
        self.quantityView.layer.cornerRadius = 5.0
        self.foodImg.layer.cornerRadius = 5.0
        self.foodImg.layer.borderWidth = 0.2
        self.foodImg.layer.borderColor = UIColor.lightGray.cgColor
        self.baseView.layer.borderWidth = 0.2
        self.baseView.layer.borderColor = UIColor.lightGray.cgColor
        self.baseView.layer.cornerRadius = 5.0
        self.choicesStackView.subviews.forEach({ $0.removeFromSuperview() })
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configData(index:Int, section:Int)
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
        setupAllChoices()
        self.tag = section
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        choicesStackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupAllChoices() {
        let itemCartChoices: [CartItemChoice] = Singleton.sharedInstance.MyCartModel.data.cartDetails[mainSection].addedItemDetails[mainIndex].cartChoices.map {
            CartItemChoice(name: $0.choiceName,
                           price: Double($0.choiceAmount) ?? 0,
                           id: $0.choiceId,
                           type: .one)
        }
        itemCartChoices.forEach { cartItemChoice in
            let view = CartItemChoiceView(frame: .zero)
            view.choice = cartItemChoice
            view.onTap = { [weak self] cartItemChoice in
                self?.removeChoice(choice: cartItemChoice)
            }
            choicesStackView.addArrangedSubview(view)
        }
    }
    
    private func removeChoice(choice: CartItemChoice) {
        let HeaderSection = self.tag
        let section = mainIndex
        self.delegate?.showBGLoader()
        let cartId =  String(Singleton.sharedInstance.MyCartModel.data.cartDetails[HeaderSection].addedItemDetails[section].cartId)
        let productId = String(Singleton.sharedInstance.MyCartModel.data.cartDetails[HeaderSection].addedItemDetails[section].productId)
        
        let Parse = CommomParsing()
        Parse.removeChoiceFromCart(lang: login_session.value(forKey: "Language") as? String ?? "es", cart_id: cartId,product_id: productId, choice_id: [choice.id], onSuccess: { [weak self] response in
            print (response)
            self?.delegate?.hideBGLoader()
            if response.object(forKey: "code") as! Int == 200{
                self?.delegate?.reloadCartData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                //self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                
            }
        }, onFailure: {errorResponse in})
    }
}
