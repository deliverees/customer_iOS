//
//  RestaurantDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 14, 2019

import Foundation


class RestaurantDetail : NSObject, NSCoding{

    var restaurantDesc : String!
    var restaurantId : Int!
    var restaurantImage : String!
    var restaurantName : String!
    var restaurantRating : Int!
    var restaurantStatus : String!
    var todayWkingTime : String!
    var deliveryTime : String!
    var cat_id : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        restaurantDesc = dictionary["restaurant_desc"] as? String
        restaurantId = dictionary["restaurant_id"] as? Int
        restaurantImage = dictionary["restaurant_image"] as? String
        restaurantName = dictionary["restaurant_name"] as? String
        restaurantRating = dictionary["restaurant_rating"] as? Int
        restaurantStatus = dictionary["restaurant_status"] as? String
        todayWkingTime = dictionary["today_wking_time"] as? String
        deliveryTime = dictionary["delivery_time"] as? String
        cat_id = dictionary["cat_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if restaurantDesc != nil{
            dictionary["restaurant_desc"] = restaurantDesc
        }
        if restaurantId != nil{
            dictionary["restaurant_id"] = restaurantId
        }
        if restaurantImage != nil{
            dictionary["restaurant_image"] = restaurantImage
        }
        if restaurantName != nil{
            dictionary["restaurant_name"] = restaurantName
        }
        if restaurantRating != nil{
            dictionary["restaurant_rating"] = restaurantRating
        }
        if restaurantStatus != nil{
            dictionary["restaurant_status"] = restaurantStatus
        }
        if todayWkingTime != nil{
            dictionary["today_wking_time"] = todayWkingTime
        }
        if deliveryTime != nil{
            dictionary["delivery_time"] = deliveryTime
        }
        if cat_id != nil{
            dictionary["cat_id"] = deliveryTime
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        restaurantDesc = aDecoder.decodeObject(forKey: "restaurant_desc") as? String
        restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? Int
        restaurantImage = aDecoder.decodeObject(forKey: "restaurant_image") as? String
        restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
        restaurantRating = aDecoder.decodeObject(forKey: "restaurant_rating") as? Int
        restaurantStatus = aDecoder.decodeObject(forKey: "restaurant_status") as? String
        todayWkingTime = aDecoder.decodeObject(forKey: "today_wking_time") as? String
        deliveryTime = aDecoder.decodeObject(forKey: "delivery_time") as? String
        cat_id = aDecoder.decodeObject(forKey: "cat_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if restaurantDesc != nil{
            aCoder.encode(restaurantDesc, forKey: "restaurant_desc")
        }
        if restaurantId != nil{
            aCoder.encode(restaurantId, forKey: "restaurant_id")
        }
        if restaurantImage != nil{
            aCoder.encode(restaurantImage, forKey: "restaurant_image")
        }
        if restaurantName != nil{
            aCoder.encode(restaurantName, forKey: "restaurant_name")
        }
        if restaurantRating != nil{
            aCoder.encode(restaurantRating, forKey: "restaurant_rating")
        }
        if restaurantStatus != nil{
            aCoder.encode(restaurantStatus, forKey: "restaurant_status")
        }
        if todayWkingTime != nil{
            aCoder.encode(todayWkingTime, forKey: "today_wking_time")
        }
        if deliveryTime != nil{
            aCoder.encode(deliveryTime, forKey: "delivery_time")
        }
        if cat_id != nil{
            aCoder.encode(deliveryTime, forKey: "cat_id")
        }
    }
}
