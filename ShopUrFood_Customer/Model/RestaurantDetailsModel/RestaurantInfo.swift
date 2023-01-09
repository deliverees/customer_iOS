//
//  RestaurantInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 18, 2019

import Foundation


class RestaurantInfo : NSObject, NSCoding{

    var cancellationPolicy : String!
    var deliveryTime : String!
    var minimumOrder : Int!
    var preOrder : String!
    var refundStatus : String!
    var restaurantBanner : [String]!
    var restaurantCurrency : String!
    var restaurantDesc : String!
    var restaurantId : Int!
    var restaurantLocation : String!
    var restaurantLogo : String!
    var restaurantName : String!
    var restaurantRating : Int!
    var restaurantStatus : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cancellationPolicy = dictionary["cancellation_policy"] as? String
        deliveryTime = dictionary["delivery_time"] as? String
        minimumOrder = dictionary["minimum_order"] as? Int
        preOrder = dictionary["pre_order"] as? String
        refundStatus = dictionary["refund_status"] as? String
        restaurantCurrency = dictionary["restaurant_currency"] as? String
        restaurantDesc = dictionary["restaurant_desc"] as? String
        restaurantId = dictionary["restaurant_id"] as? Int
        restaurantLocation = dictionary["restaurant_location"] as? String
        restaurantLogo = dictionary["restaurant_logo"] as? String
        restaurantName = dictionary["restaurant_name"] as? String
        restaurantRating = dictionary["restaurant_rating"] as? Int
        restaurantStatus = dictionary["restaurant_status"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cancellationPolicy != nil{
            dictionary["cancellation_policy"] = cancellationPolicy
        }
        if deliveryTime != nil{
            dictionary["delivery_time"] = deliveryTime
        }
        if minimumOrder != nil{
            dictionary["minimum_order"] = minimumOrder
        }
        if preOrder != nil{
            dictionary["pre_order"] = preOrder
        }
        if refundStatus != nil{
            dictionary["refund_status"] = refundStatus
        }
        if restaurantCurrency != nil{
            dictionary["restaurant_currency"] = restaurantCurrency
        }
        if restaurantDesc != nil{
            dictionary["restaurant_desc"] = restaurantDesc
        }
        if restaurantId != nil{
            dictionary["restaurant_id"] = restaurantId
        }
        if restaurantLocation != nil{
            dictionary["restaurant_location"] = restaurantLocation
        }
        if restaurantLogo != nil{
            dictionary["restaurant_logo"] = restaurantLogo
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
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cancellationPolicy = aDecoder.decodeObject(forKey: "cancellation_policy") as? String
        deliveryTime = aDecoder.decodeObject(forKey: "delivery_time") as? String
        minimumOrder = aDecoder.decodeObject(forKey: "minimum_order") as? Int
        preOrder = aDecoder.decodeObject(forKey: "pre_order") as? String
        refundStatus = aDecoder.decodeObject(forKey: "refund_status") as? String
        restaurantBanner = aDecoder.decodeObject(forKey: "restaurant_banner") as? [String]
        restaurantCurrency = aDecoder.decodeObject(forKey: "restaurant_currency") as? String
        restaurantDesc = aDecoder.decodeObject(forKey: "restaurant_desc") as? String
        restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? Int
        restaurantLocation = aDecoder.decodeObject(forKey: "restaurant_location") as? String
        restaurantLogo = aDecoder.decodeObject(forKey: "restaurant_logo") as? String
        restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
        restaurantRating = aDecoder.decodeObject(forKey: "restaurant_rating") as? Int
        restaurantStatus = aDecoder.decodeObject(forKey: "restaurant_status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cancellationPolicy != nil{
            aCoder.encode(cancellationPolicy, forKey: "cancellation_policy")
        }
        if deliveryTime != nil{
            aCoder.encode(deliveryTime, forKey: "delivery_time")
        }
        if minimumOrder != nil{
            aCoder.encode(minimumOrder, forKey: "minimum_order")
        }
        if preOrder != nil{
            aCoder.encode(preOrder, forKey: "pre_order")
        }
        if refundStatus != nil{
            aCoder.encode(refundStatus, forKey: "refund_status")
        }
        if restaurantBanner != nil{
            aCoder.encode(restaurantBanner, forKey: "restaurant_banner")
        }
        if restaurantCurrency != nil{
            aCoder.encode(restaurantCurrency, forKey: "restaurant_currency")
        }
        if restaurantDesc != nil{
            aCoder.encode(restaurantDesc, forKey: "restaurant_desc")
        }
        if restaurantId != nil{
            aCoder.encode(restaurantId, forKey: "restaurant_id")
        }
        if restaurantLocation != nil{
            aCoder.encode(restaurantLocation, forKey: "restaurant_location")
        }
        if restaurantLogo != nil{
            aCoder.encode(restaurantLogo, forKey: "restaurant_logo")
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
    }
}