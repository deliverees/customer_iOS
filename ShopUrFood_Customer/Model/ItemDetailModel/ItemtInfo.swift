//
//  ItemtInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 22, 2019

import Foundation


class ItemtInfo : NSObject, NSCoding{

    var itemAvailablity : String!
    var itemContent : String!
    var itemCurrency : String!
    var itemDesc : String!
    var itemDiscountPercent : Int!
    var itemDiscountPrice : String!
    var itemHasChoice : String!
    var itemHasDiscount : String!
    var itemHasTax : String!
    var itemId : Int!
    var itemImages : [String]!
    var itemIsFavourite : String!
    var itemName : String!
    var itemOriginalPrice : String!
    var itemQuantity : Int!
    var itemRating : Int!
    var itemSpecificatioon : [ItemSpecificatioon]!
    var itemTax : String!
    var itemType : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        itemAvailablity = dictionary["item_availablity"] as? String
        itemContent = dictionary["item_content"] as? String
        itemCurrency = dictionary["item_currency"] as? String
        itemDesc = dictionary["item_desc"] as? String
        itemDiscountPercent = dictionary["item_discount_percent"] as? Int
        itemDiscountPrice = dictionary["item_discount_price"] as? String
        itemHasChoice = dictionary["item_has_choice"] as? String
        itemHasDiscount = dictionary["item_has_discount"] as? String
        itemHasTax = dictionary["item_has_tax"] as? String
        itemId = dictionary["item_id"] as? Int
        itemImages = dictionary["item_image"] as? [String]
        itemIsFavourite = dictionary["item_is_favourite"] as? String
        itemName = dictionary["item_name"] as? String
        itemOriginalPrice = dictionary["item_original_price"] as? String
        itemQuantity = dictionary["item_quantity"] as? Int
        itemRating = dictionary["item_rating"] as? Int
        itemTax = dictionary["item_tax"] as? String
        itemType = dictionary["item_type"] as? String
        itemSpecificatioon = [ItemSpecificatioon]()
        if let itemSpecificatioonArray = dictionary["item_specificatioon"] as? [[String:Any]]{
            for dic in itemSpecificatioonArray{
                let value = ItemSpecificatioon(fromDictionary: dic)
                itemSpecificatioon.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if itemAvailablity != nil{
            dictionary["item_availablity"] = itemAvailablity
        }
        if itemContent != nil{
            dictionary["item_content"] = itemContent
        }
        if itemCurrency != nil{
            dictionary["item_currency"] = itemCurrency
        }
        if itemDesc != nil{
            dictionary["item_desc"] = itemDesc
        }
        if itemDiscountPercent != nil{
            dictionary["item_discount_percent"] = itemDiscountPercent
        }
        if itemDiscountPrice != nil{
            dictionary["item_discount_price"] = itemDiscountPrice
        }
        if itemHasChoice != nil{
            dictionary["item_has_choice"] = itemHasChoice
        }
        if itemHasDiscount != nil{
            dictionary["item_has_discount"] = itemHasDiscount
        }
        if itemHasTax != nil{
            dictionary["item_has_tax"] = itemHasTax
        }
        if itemId != nil{
            dictionary["item_id"] = itemId
        }
        if itemImages != nil {
            dictionary["item_image"] = itemImages
        }
        if itemIsFavourite != nil{
            dictionary["item_is_favourite"] = itemIsFavourite
        }
        if itemName != nil{
            dictionary["item_name"] = itemName
        }
        if itemOriginalPrice != nil{
            dictionary["item_original_price"] = itemOriginalPrice
        }
        if itemQuantity != nil{
            dictionary["item_quantity"] = itemQuantity
        }
        if itemRating != nil{
            dictionary["item_rating"] = itemRating
        }
        if itemTax != nil{
            dictionary["item_tax"] = itemTax
        }
        if itemType != nil{
            dictionary["item_type"] = itemType
        }
        if itemSpecificatioon != nil{
            var dictionaryElements = [[String:Any]]()
            for itemSpecificatioonElement in itemSpecificatioon {
                dictionaryElements.append(itemSpecificatioonElement.toDictionary())
            }
            dictionary["itemSpecificatioon"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        itemAvailablity = aDecoder.decodeObject(forKey: "item_availablity") as? String
        itemContent = aDecoder.decodeObject(forKey: "item_content") as? String
        itemCurrency = aDecoder.decodeObject(forKey: "item_currency") as? String
        itemDesc = aDecoder.decodeObject(forKey: "item_desc") as? String
        itemDiscountPercent = aDecoder.decodeObject(forKey: "item_discount_percent") as? Int
        itemDiscountPrice = aDecoder.decodeObject(forKey: "item_discount_price") as? String
        itemHasChoice = aDecoder.decodeObject(forKey: "item_has_choice") as? String
        itemHasDiscount = aDecoder.decodeObject(forKey: "item_has_discount") as? String
        itemHasTax = aDecoder.decodeObject(forKey: "item_has_tax") as? String
        itemId = aDecoder.decodeObject(forKey: "item_id") as? Int
        itemImages = aDecoder.decodeObject(forKey: "item_image") as? [String]
        itemIsFavourite = aDecoder.decodeObject(forKey: "item_is_favourite") as? String
        itemName = aDecoder.decodeObject(forKey: "item_name") as? String
        itemOriginalPrice = aDecoder.decodeObject(forKey: "item_original_price") as? String
        itemQuantity = aDecoder.decodeObject(forKey: "item_quantity") as? Int
        itemRating = aDecoder.decodeObject(forKey: "item_rating") as? Int
        itemSpecificatioon = aDecoder.decodeObject(forKey: "item_specificatioon") as? [ItemSpecificatioon]
        itemTax = aDecoder.decodeObject(forKey: "item_tax") as? String
        itemType = aDecoder.decodeObject(forKey: "item_type") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if itemAvailablity != nil{
            aCoder.encode(itemAvailablity, forKey: "item_availablity")
        }
        if itemContent != nil{
            aCoder.encode(itemContent, forKey: "item_content")
        }
        if itemCurrency != nil{
            aCoder.encode(itemCurrency, forKey: "item_currency")
        }
        if itemDesc != nil{
            aCoder.encode(itemDesc, forKey: "item_desc")
        }
        if itemDiscountPercent != nil{
            aCoder.encode(itemDiscountPercent, forKey: "item_discount_percent")
        }
        if itemDiscountPrice != nil{
            aCoder.encode(itemDiscountPrice, forKey: "item_discount_price")
        }
        if itemHasChoice != nil{
            aCoder.encode(itemHasChoice, forKey: "item_has_choice")
        }
        if itemHasDiscount != nil{
            aCoder.encode(itemHasDiscount, forKey: "item_has_discount")
        }
        if itemHasTax != nil{
            aCoder.encode(itemHasTax, forKey: "item_has_tax")
        }
        if itemId != nil{
            aCoder.encode(itemId, forKey: "item_id")
        }
        if itemImages != nil{
            aCoder.encode(itemImages, forKey: "item_image")
        }
        if itemIsFavourite != nil{
            aCoder.encode(itemIsFavourite, forKey: "item_is_favourite")
        }
        if itemName != nil{
            aCoder.encode(itemName, forKey: "item_name")
        }
        if itemOriginalPrice != nil{
            aCoder.encode(itemOriginalPrice, forKey: "item_original_price")
        }
        if itemQuantity != nil{
            aCoder.encode(itemQuantity, forKey: "item_quantity")
        }
        if itemRating != nil{
            aCoder.encode(itemRating, forKey: "item_rating")
        }
        if itemSpecificatioon != nil{
            aCoder.encode(itemSpecificatioon, forKey: "item_specificatioon")
        }
        if itemTax != nil{
            aCoder.encode(itemTax, forKey: "item_tax")
        }
        if itemType != nil{
            aCoder.encode(itemType, forKey: "item_type")
        }
    }
}
