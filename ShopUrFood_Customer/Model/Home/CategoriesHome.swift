//
//  FeaturedRestaurant.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 14, 2019

import Foundation


class CategoriesHome : NSObject, NSCoding{

    var category_id : Int!
    var category_image : String!
    var category_name : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        category_id = dictionary["category_id"] as? Int
        category_image = dictionary["category_image"] as? String
        category_name = dictionary["category_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if category_id != nil{
            dictionary["category_id"] = category_id
        }
        if category_image != nil{
            dictionary["category_image"] = category_image
        }
        if category_name != nil{
            dictionary["category_name"] = category_name
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        category_id = aDecoder.decodeObject(forKey: "category_id") as? Int
        category_image = aDecoder.decodeObject(forKey: "category_image") as? String
        category_name = aDecoder.decodeObject(forKey: "category_name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if category_id != nil{
            aCoder.encode(category_id, forKey: "category_id")
        }
        if category_image != nil{
            aCoder.encode(category_image, forKey: "category_image")
        }
        if category_name != nil{
            aCoder.encode(category_name, forKey: "category_name")
        }
    }
}
