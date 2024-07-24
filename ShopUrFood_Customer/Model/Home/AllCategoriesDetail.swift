//
//  AllCategoriesDetail.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 14, 2019

import Foundation


class AllCategoriesDetail : NSObject, NSCoding{

    var categoryId : Int!
    var categoryName : String!
    var categoryImage : String!
    var categoriesDetails : [CategoriesHome]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categoryId = dictionary["category_id"] as? Int
        categoryName = dictionary["category_name"] as? String
        categoryImage = dictionary["category_image"] as? String
        categoriesDetails = [CategoriesHome]()
        if let categoryDetailsArray = dictionary["category_list"] as? [[String:Any]]{
            for dic in categoryDetailsArray{
                let value = CategoriesHome(fromDictionary: dic)
                categoriesDetails.append(value)
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
        if categoryImage != nil{
            dictionary["category_image"] = categoryImage
        }
        if categoriesDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for categoriesDetailsElement in categoriesDetails {
                dictionaryElements.append(categoriesDetailsElement.toDictionary())
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
        categoryImage = aDecoder.decodeObject(forKey: "category_image") as? String
        categoriesDetails = aDecoder.decodeObject(forKey: "category_list") as? [CategoriesHome]
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
        if categoryImage != nil{
            aCoder.encode(categoryImage, forKey: "category_image")
        }
        if categoriesDetails != nil{
            aCoder.encode(categoriesDetails, forKey: "category_list")
        }
    }
}
