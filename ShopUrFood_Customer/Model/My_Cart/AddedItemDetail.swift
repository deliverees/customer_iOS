//
//  AddedItemDetail.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 26, 2019

import Foundation


class AddedItemDetail : NSObject, NSCoding{
    
    var availableStock : Int!
    var cartChoices : [CartChoice] = []
    var cartChoicesTwo: [CartChoice] = []
    var cartChoicesThree: [CartChoice] = []
    var itemChoices : [ItemChoice]!
    var itemTwoChoices: [ItemChoice] = []
    var itemThreeChoices: [ItemChoice] = []
    var cartCurrency : String!
    var cartHasChoice : String!
    var cartId : Int!
    var cartPreOrder : String!
    var cartSplRequest :String!
    var cartQuantity : Int!
    var cartSubTotal : String!
    var cartTax : String!
    var cartUnitPrice : String!
    var productId : Int!
    var productImage : String!
    var productName : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        availableStock = dictionary["available_stock"] as? Int
        cartCurrency = dictionary["cart_currency"] as? String
        cartHasChoice = dictionary["cart_has_choice"] as? String
        cartId = dictionary["cart_id"] as? Int
        cartPreOrder = dictionary["cart_pre_order"] as? String
        cartSplRequest = dictionary["cart_spl_request"] as? String
        cartQuantity = dictionary["cart_quantity"] as? Int
        cartSubTotal = dictionary["cart_sub_total"] as? String
        cartTax = dictionary["cart_tax"] as? String
        cartUnitPrice = dictionary["cart_unit_price"] as? String
        productId = dictionary["product_id"] as? Int
        productImage = dictionary["product_image"] as? String
        productName = dictionary["product_name"] as? String
        cartChoices = [CartChoice]()
        if let cartChoicesArray = dictionary["cart_choices"] as? [[String:Any]] {
            for dic in cartChoicesArray{
                let value = CartChoice(fromDictionary: dic)
                cartChoices.append(value)
            }
        }
        
        cartChoicesTwo = [CartChoice]()
        if let cartChoicesTwoArray = dictionary["cart_choicesTwo"] as? [[String:Any]] {
            for dic in cartChoicesTwoArray{
                let value = CartChoice(fromDictionary: dic)
                cartChoicesTwo.append(value)
            }
        }
        
        cartChoicesThree = [CartChoice]()
        if let cartChoicesThreeArray = dictionary["cart_choicesThree"] as? [[String:Any]] {
            for dic in cartChoicesThreeArray{
                let value = CartChoice(fromDictionary: dic)
                cartChoicesThree.append(value)
            }
        }
        
        itemChoices = [ItemChoice]()
        if let itemChoicesArray = dictionary["item_choices"] as? [[String:Any]] {
            for dic in itemChoicesArray{
                let value = ItemChoice(fromDictionary: dic)
                itemChoices.append(value)
            }
        }
        itemTwoChoices = [ItemChoice]()
        if let itemTwoChoicesArray = dictionary["item_choicesTwo"] as? [[String:Any]] {
            for dic in itemTwoChoicesArray{
                let value = ItemChoice(fromDictionary: dic)
                itemTwoChoices.append(value)
            }
        }
        itemThreeChoices = [ItemChoice]()
        if let itemThreeChoicesArray = dictionary["item_choicesThree"] as? [[String:Any]] {
            for dic in itemThreeChoicesArray{
                let value = ItemChoice(fromDictionary: dic)
                itemThreeChoices.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if availableStock != nil{
            dictionary["available_stock"] = availableStock
        }
        if cartCurrency != nil{
            dictionary["cart_currency"] = cartCurrency
        }
        if cartHasChoice != nil{
            dictionary["cart_has_choice"] = cartHasChoice
        }
        if cartId != nil{
            dictionary["cart_id"] = cartId
        }
        if cartPreOrder != nil{
            dictionary["cart_pre_order"] = cartPreOrder
        }
        if cartSplRequest != nil{
            dictionary["cart_spl_request"] = cartSplRequest
            
        }
        if cartQuantity != nil{
            dictionary["cart_quantity"] = cartQuantity
        }
        if cartSubTotal != nil{
            dictionary["cart_sub_total"] = cartSubTotal
        }
        if cartTax != nil{
            dictionary["cart_tax"] = cartTax
        }
        if cartUnitPrice != nil{
            dictionary["cart_unit_price"] = cartUnitPrice
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if productImage != nil{
            dictionary["product_image"] = productImage
        }
        if productName != nil{
            dictionary["product_name"] = productName
        }
        if !cartChoices.isEmpty {
            var dictionaryElements = [[String:Any]]()
            for cartChoicesElement in cartChoices {
                dictionaryElements.append(cartChoicesElement.toDictionary())
            }
            dictionary["cart_choices"] = dictionaryElements
        }
        if !cartChoicesTwo.isEmpty {
            var dictionaryElements = [[String:Any]]()
            for cartChoicesElement in cartChoicesTwo {
                dictionaryElements.append(cartChoicesElement.toDictionary())
            }
            dictionary["cart_choicesTwo"] = dictionaryElements
        }
        if !cartChoicesThree.isEmpty {
            var dictionaryElements = [[String:Any]]()
            for cartChoicesElement in cartChoicesThree {
                dictionaryElements.append(cartChoicesElement.toDictionary())
            }
            dictionary["cart_choicesThree"] = dictionaryElements
        }
        if itemChoices != nil{
            var dictionaryElements = [[String:Any]]()
            for itemChoicesElement in itemChoices {
                dictionaryElements.append(itemChoicesElement.toDictionary())
            }
            dictionary["item_choices"] = dictionaryElements
        }
        if !itemTwoChoices.isEmpty {
            dictionary["item_choicesTwo"] = itemTwoChoices.map { $0.toDictionary() }
        }
        if !itemThreeChoices.isEmpty {
            dictionary["item_choicesThree"] = itemThreeChoices.map { $0.toDictionary() }
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        availableStock = aDecoder.decodeObject(forKey: "available_stock") as? Int
        cartChoices = aDecoder.decodeObject(forKey: "cart_choices") as? [CartChoice] ?? []
        cartChoicesTwo = aDecoder.decodeObject(forKey: "cart_choicesTwo") as? [CartChoice] ?? []
        cartChoicesThree = aDecoder.decodeObject(forKey: "cart_choicesThree") as? [CartChoice] ?? []
        itemChoices = aDecoder.decodeObject(forKey: "item_choices") as? [ItemChoice]
        cartCurrency = aDecoder.decodeObject(forKey: "cart_currency") as? String
        cartHasChoice = aDecoder.decodeObject(forKey: "cart_has_choice") as? String
        cartId = aDecoder.decodeObject(forKey: "cart_id") as? Int
        cartPreOrder = aDecoder.decodeObject(forKey: "cart_pre_order") as? String
        cartSplRequest = aDecoder.decodeObject(forKey: "cart_spl_request") as? String
        cartQuantity = aDecoder.decodeObject(forKey: "cart_quantity") as? Int
        cartSubTotal = aDecoder.decodeObject(forKey: "cart_sub_total") as? String
        cartTax = aDecoder.decodeObject(forKey: "cart_tax") as? String
        cartUnitPrice = aDecoder.decodeObject(forKey: "cart_unit_price") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? Int
        productImage = aDecoder.decodeObject(forKey: "product_image") as? String
        productName = aDecoder.decodeObject(forKey: "product_name") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if availableStock != nil{
            aCoder.encode(availableStock, forKey: "available_stock")
        }
        if !cartChoices.isEmpty {
            aCoder.encode(cartChoices, forKey: "cart_choices")
        }
        if !cartChoicesTwo.isEmpty {
            aCoder.encode(cartChoicesTwo, forKey: "cart_choicesTwo")
        }
        if !cartChoicesThree.isEmpty {
            aCoder.encode(cartChoicesThree, forKey: "cart_choicesThree")
        }
        if itemChoices != nil{
            aCoder.encode(itemChoices, forKey: "item_choices")
        }
        if cartCurrency != nil{
            aCoder.encode(cartCurrency, forKey: "cart_currency")
        }
        if cartHasChoice != nil{
            aCoder.encode(cartHasChoice, forKey: "cart_has_choice")
        }
        if cartId != nil{
            aCoder.encode(cartId, forKey: "cart_id")
        }
        if cartPreOrder != nil{
            aCoder.encode(cartPreOrder, forKey: "cart_pre_order")
        }
        if cartSplRequest != nil{
            aCoder.encode(cartSplRequest, forKey: "cart_spl_request")
        }
        if cartQuantity != nil{
            aCoder.encode(cartQuantity, forKey: "cart_quantity")
        }
        if cartSubTotal != nil{
            aCoder.encode(cartSubTotal, forKey: "cart_sub_total")
        }
        if cartTax != nil{
            aCoder.encode(cartTax, forKey: "cart_tax")
        }
        if cartUnitPrice != nil{
            aCoder.encode(cartUnitPrice, forKey: "cart_unit_price")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
        }
        if productName != nil{
            aCoder.encode(productName, forKey: "product_name")
        }
    }
    
    func allChoices() -> [CartChoice] {
        cartChoices + cartChoicesTwo + cartChoicesThree
    }
}
