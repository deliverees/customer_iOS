//
//  CartDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 26, 2019

import Foundation


class CartDetail : NSObject, NSCoding{

    var addedItemDetails : [AddedItemDetail]!
    var minimumOrderAmount : String!
    var preOrderStatus : String!
    var storeId : Int!
    var storeName : String!
    var storeStatus : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        minimumOrderAmount = dictionary["minimum_order_amount"] as? String
        preOrderStatus = dictionary["pre_order_status"] as? String
        storeId = dictionary["store_id"] as? Int
        storeName = dictionary["store_name"] as? String
        storeStatus = dictionary["store_status"] as? String
        addedItemDetails = [AddedItemDetail]()
        if let addedItemDetailsArray = dictionary["added_item_details"] as? [[String:Any]]{
            for dic in addedItemDetailsArray{
                let value = AddedItemDetail(fromDictionary: dic)
                addedItemDetails.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if minimumOrderAmount != nil{
            dictionary["minimum_order_amount"] = minimumOrderAmount
        }
        if preOrderStatus != nil{
            dictionary["pre_order_status"] = preOrderStatus
        }
        if storeId != nil{
            dictionary["store_id"] = storeId
        }
        if storeName != nil{
            dictionary["store_name"] = storeName
        }
        if storeStatus != nil{
            dictionary["store_status"] = storeStatus
        }
        if addedItemDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for addedItemDetailsElement in addedItemDetails {
                dictionaryElements.append(addedItemDetailsElement.toDictionary())
            }
            dictionary["addedItemDetails"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        addedItemDetails = aDecoder.decodeObject(forKey: "added_item_details") as? [AddedItemDetail]
        minimumOrderAmount = aDecoder.decodeObject(forKey: "minimum_order_amount") as? String
        preOrderStatus = aDecoder.decodeObject(forKey: "pre_order_status") as? String
        storeId = aDecoder.decodeObject(forKey: "store_id") as? Int
        storeName = aDecoder.decodeObject(forKey: "store_name") as? String
        storeStatus = aDecoder.decodeObject(forKey: "store_status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if addedItemDetails != nil{
            aCoder.encode(addedItemDetails, forKey: "added_item_details")
        }
        if minimumOrderAmount != nil{
            aCoder.encode(minimumOrderAmount, forKey: "minimum_order_amount")
        }
        if preOrderStatus != nil{
            aCoder.encode(preOrderStatus, forKey: "pre_order_status")
        }
        if storeId != nil{
            aCoder.encode(storeId, forKey: "store_id")
        }
        if storeName != nil{
            aCoder.encode(storeName, forKey: "store_name")
        }
        if storeStatus != nil{
            aCoder.encode(storeStatus, forKey: "store_status")
        }
    }
}