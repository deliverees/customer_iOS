//
//  StoreLocation.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 26, 2019

import Foundation


class StoreLocation : NSObject, NSCoding{

    var storeLocation : String!
    var storeName : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        storeLocation = dictionary["store_location"] as? String
        storeName = dictionary["store_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if storeLocation != nil{
            dictionary["store_location"] = storeLocation
        }
        if storeName != nil{
            dictionary["store_name"] = storeName
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        storeLocation = aDecoder.decodeObject(forKey: "store_location") as? String
        storeName = aDecoder.decodeObject(forKey: "store_name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if storeLocation != nil{
            aCoder.encode(storeLocation, forKey: "store_location")
        }
        if storeName != nil{
            aCoder.encode(storeName, forKey: "store_name")
        }
    }
}