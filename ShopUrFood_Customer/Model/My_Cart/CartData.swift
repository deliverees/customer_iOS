//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 26, 2019

import Foundation


class CartData : NSObject, NSCoding{

    var cartDetails : [CartDetail]!
    var cartSubTotal : String!
    var currencyCode : String!
    var deliveryFee : String!
    var minimumOrderError : [String]!
    var preOrderError : [String]!
    var storeLocations : [StoreLocation]!
    var totalCartAmount : String!
    var totalCartCount : Int!
    var cartTaxTotal : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cartSubTotal = dictionary["cart_sub_total"] as? String
        currencyCode = dictionary["currency_code"] as? String
        deliveryFee = dictionary["delivery_fee"] as? String
        totalCartAmount = dictionary["total_cart_amount"] as? String
        totalCartCount = dictionary["total_cart_count"] as? Int
        cartTaxTotal = dictionary["cart_tax_total"] as? String

        cartDetails = [CartDetail]()
        if let cartDetailsArray = dictionary["cart_details"] as? [[String:Any]]{
            for dic in cartDetailsArray{
                let value = CartDetail(fromDictionary: dic)
                cartDetails.append(value)
            }
        }
        storeLocations = [StoreLocation]()
        if let storeLocationsArray = dictionary["store_locations"] as? [[String:Any]]{
            for dic in storeLocationsArray{
                let value = StoreLocation(fromDictionary: dic)
                storeLocations.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cartSubTotal != nil{
            dictionary["cart_sub_total"] = cartSubTotal
        }
        if currencyCode != nil{
            dictionary["currency_code"] = currencyCode
        }
        if deliveryFee != nil{
            dictionary["delivery_fee"] = deliveryFee
        }
        if totalCartAmount != nil{
            dictionary["total_cart_amount"] = totalCartAmount
        }
        if totalCartCount != nil{
            dictionary["total_cart_count"] = totalCartCount
        }
        if cartTaxTotal != nil{
            dictionary["cart_tax_total"] = cartTaxTotal
        }
        if cartDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for cartDetailsElement in cartDetails {
                dictionaryElements.append(cartDetailsElement.toDictionary())
            }
            dictionary["cartDetails"] = dictionaryElements
        }
        if storeLocations != nil{
            var dictionaryElements = [[String:Any]]()
            for storeLocationsElement in storeLocations {
                dictionaryElements.append(storeLocationsElement.toDictionary())
            }
            dictionary["storeLocations"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cartDetails = aDecoder.decodeObject(forKey: "cart_details") as? [CartDetail]
        cartSubTotal = aDecoder.decodeObject(forKey: "cart_sub_total") as? String
        currencyCode = aDecoder.decodeObject(forKey: "currency_code") as? String
        deliveryFee = aDecoder.decodeObject(forKey: "delivery_fee") as? String
        minimumOrderError = aDecoder.decodeObject(forKey: "minimum_order_error") as? [String]
        preOrderError = aDecoder.decodeObject(forKey: "pre_order_error") as? [String]
        storeLocations = aDecoder.decodeObject(forKey: "store_locations") as? [StoreLocation]
        totalCartAmount = aDecoder.decodeObject(forKey: "total_cart_amount") as? String
        totalCartCount = aDecoder.decodeObject(forKey: "total_cart_count") as? Int
        cartTaxTotal = aDecoder.decodeObject(forKey: "cart_tax_total") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cartDetails != nil{
            aCoder.encode(cartDetails, forKey: "cart_details")
        }
        if cartSubTotal != nil{
            aCoder.encode(cartSubTotal, forKey: "cart_sub_total")
        }
        if currencyCode != nil{
            aCoder.encode(currencyCode, forKey: "currency_code")
        }
        if deliveryFee != nil{
            aCoder.encode(deliveryFee, forKey: "delivery_fee")
        }
        if minimumOrderError != nil{
            aCoder.encode(minimumOrderError, forKey: "minimum_order_error")
        }
        if preOrderError != nil{
            aCoder.encode(preOrderError, forKey: "pre_order_error")
        }
        if storeLocations != nil{
            aCoder.encode(storeLocations, forKey: "store_locations")
        }
        if totalCartAmount != nil{
            aCoder.encode(totalCartAmount, forKey: "total_cart_amount")
        }
        if totalCartCount != nil{
            aCoder.encode(totalCartCount, forKey: "total_cart_count")
        }
        if cartTaxTotal != nil{
            aCoder.encode(cartTaxTotal, forKey: "cart_tax_total")
        }
    }
}
