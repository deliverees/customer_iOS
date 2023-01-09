//
//  AllRestaurant.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 14, 2019

import Foundation


class AllRestaurant : NSObject, NSCoding{

    var restaurantId : Int!
    var restaurantLogo : String!
    var restaurantName : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        restaurantId = dictionary["restaurant_id"] as? Int
        restaurantLogo = dictionary["restaurant_logo"] as? String
        restaurantName = dictionary["restaurant_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if restaurantId != nil{
            dictionary["restaurant_id"] = restaurantId
        }
        if restaurantLogo != nil{
            dictionary["restaurant_logo"] = restaurantLogo
        }
        if restaurantName != nil{
            dictionary["restaurant_name"] = restaurantName
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? Int
        restaurantLogo = aDecoder.decodeObject(forKey: "restaurant_logo") as? String
        restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if restaurantId != nil{
            aCoder.encode(restaurantId, forKey: "restaurant_id")
        }
        if restaurantLogo != nil{
            aCoder.encode(restaurantLogo, forKey: "restaurant_logo")
        }
        if restaurantName != nil{
            aCoder.encode(restaurantName, forKey: "restaurant_name")
        }
    }
}