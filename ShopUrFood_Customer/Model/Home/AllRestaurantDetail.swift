//
//  AllRestaurantDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 14, 2019

import Foundation


class AllRestaurantDetail : NSObject, NSCoding{

    var categoryId : Int!
    var categoryName : String!
    var restaurantDetails : [RestaurantDetail]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categoryId = dictionary["category_id"] as? Int
        categoryName = dictionary["category_name"] as? String
        restaurantDetails = [RestaurantDetail]()
        if let restaurantDetailsArray = dictionary["restaurant_details"] as? [[String:Any]]{
            for dic in restaurantDetailsArray{
                let value = RestaurantDetail(fromDictionary: dic)
                restaurantDetails.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if categoryName != nil{
            dictionary["category_name"] = categoryName
        }
        if restaurantDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for restaurantDetailsElement in restaurantDetails {
                dictionaryElements.append(restaurantDetailsElement.toDictionary())
            }
            dictionary["restaurantDetails"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        restaurantDetails = aDecoder.decodeObject(forKey: "restaurant_details") as? [RestaurantDetail]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "category_name")
        }
        if restaurantDetails != nil{
            aCoder.encode(restaurantDetails, forKey: "restaurant_details")
        }
    }
}