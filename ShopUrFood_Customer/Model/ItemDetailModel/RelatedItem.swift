//
//  RelatedItem.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 22, 2019

import Foundation


class RelatedItem : NSObject, NSCoding{

    var itemAvailablity : String!
    var itemContent : String!
    var itemCurrency : String!
    var itemDiscountPrice : String!
    var itemHasDiscount : String!
    var itemId : Int!
    var itemImage : String!
    var itemIsFavourite : String!
    var itemName : String!
    var itemOriginalPrice : String!
    var itemRating : Int!
    var itemType : String!
    var itemtDesc : String!
    var restaurantId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        itemAvailablity = dictionary["item_availablity"] as? String
        itemContent = dictionary["item_content"] as? String
        itemCurrency = dictionary["item_currency"] as? String
        itemDiscountPrice = dictionary["item_discount_price"] as? String
        itemHasDiscount = dictionary["item_has_discount"] as? String
        itemId = dictionary["item_id"] as? Int
        itemImage = dictionary["item_image"] as? String
        itemIsFavourite = dictionary["item_is_favourite"] as? String
        itemName = dictionary["item_name"] as? String
        itemOriginalPrice = dictionary["item_original_price"] as? String
        itemRating = dictionary["item_rating"] as? Int
        itemType = dictionary["item_type"] as? String
        itemtDesc = dictionary["itemt_desc"] as? String
        restaurantId = dictionary["restaurant_id"] as? Int
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
        if itemDiscountPrice != nil{
            dictionary["item_discount_price"] = itemDiscountPrice
        }
        if itemHasDiscount != nil{
            dictionary["item_has_discount"] = itemHasDiscount
        }
        if itemId != nil{
            dictionary["item_id"] = itemId
        }
        if itemImage != nil{
            dictionary["item_image"] = itemImage
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
        if itemRating != nil{
            dictionary["item_rating"] = itemRating
        }
        if itemType != nil{
            dictionary["item_type"] = itemType
        }
        if itemtDesc != nil{
            dictionary["itemt_desc"] = itemtDesc
        }
        if restaurantId != nil{
            dictionary["restaurant_id"] = restaurantId
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
        itemDiscountPrice = aDecoder.decodeObject(forKey: "item_discount_price") as? String
        itemHasDiscount = aDecoder.decodeObject(forKey: "item_has_discount") as? String
        itemId = aDecoder.decodeObject(forKey: "item_id") as? Int
        itemImage = aDecoder.decodeObject(forKey: "item_image") as? String
        itemIsFavourite = aDecoder.decodeObject(forKey: "item_is_favourite") as? String
        itemName = aDecoder.decodeObject(forKey: "item_name") as? String
        itemOriginalPrice = aDecoder.decodeObject(forKey: "item_original_price") as? String
        itemRating = aDecoder.decodeObject(forKey: "item_rating") as? Int
        itemType = aDecoder.decodeObject(forKey: "item_type") as? String
        itemtDesc = aDecoder.decodeObject(forKey: "itemt_desc") as? String
        restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if itemAvailablity != nil{
            aCoder.encode(itemContent, forKey: "item_availablity")
        }
        if itemContent != nil{
            aCoder.encode(itemContent, forKey: "item_content")
        }
        if itemCurrency != nil{
            aCoder.encode(itemCurrency, forKey: "item_currency")
        }
        if itemDiscountPrice != nil{
            aCoder.encode(itemDiscountPrice, forKey: "item_discount_price")
        }
        if itemHasDiscount != nil{
            aCoder.encode(itemHasDiscount, forKey: "item_has_discount")
        }
        if itemId != nil{
            aCoder.encode(itemId, forKey: "item_id")
        }
        if itemImage != nil{
            aCoder.encode(itemImage, forKey: "item_image")
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
        if itemRating != nil{
            aCoder.encode(itemRating, forKey: "item_rating")
        }
        if itemType != nil{
            aCoder.encode(itemType, forKey: "item_type")
        }
        if itemtDesc != nil{
            aCoder.encode(itemtDesc, forKey: "itemt_desc")
        }
        if restaurantId != nil{
            aCoder.encode(restaurantId, forKey: "restaurant_id")
        }
    }
}
