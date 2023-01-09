//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 18, 2019

import Foundation


class  RestaurantDetailsData: NSObject, NSCoding{

    var categoryList : [CategoryList]!
    var restaurantInfo : RestaurantInfo!
    var restaurantReview : [RestaurantReview]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let restaurantInfoData = dictionary["restaurant_info"] as? [String:Any]{
            restaurantInfo = RestaurantInfo(fromDictionary: restaurantInfoData)
        }
        categoryList = [CategoryList]()
        if let categoryListArray = dictionary["category_list"] as? [[String:Any]]{
            for dic in categoryListArray{
                let value = CategoryList(fromDictionary: dic)
                categoryList.append(value)
            }
        }
        restaurantReview = [RestaurantReview]()
        if let restaurantReviewArray = dictionary["restaurant_review"] as? [[String:Any]]{
            for dic in restaurantReviewArray{
                let value = RestaurantReview(fromDictionary: dic)
                restaurantReview.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if restaurantInfo != nil{
            dictionary["restaurantInfo"] = restaurantInfo.toDictionary()
        }
        if categoryList != nil{
            var dictionaryElements = [[String:Any]]()
            for categoryListElement in categoryList {
                dictionaryElements.append(categoryListElement.toDictionary())
            }
            dictionary["categoryList"] = dictionaryElements
        }
        if restaurantReview != nil{
            var dictionaryElements = [[String:Any]]()
            for restaurantReviewElement in restaurantReview {
                dictionaryElements.append(restaurantReviewElement.toDictionary())
            }
            dictionary["restaurantReview"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryList = aDecoder.decodeObject(forKey: "category_list") as? [CategoryList]
        restaurantInfo = aDecoder.decodeObject(forKey: "restaurant_info") as? RestaurantInfo
        restaurantReview = aDecoder.decodeObject(forKey: "restaurant_review") as? [RestaurantReview]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryList != nil{
            aCoder.encode(categoryList, forKey: "category_list")
        }
        if restaurantInfo != nil{
            aCoder.encode(restaurantInfo, forKey: "restaurant_info")
        }
        if restaurantReview != nil{
            aCoder.encode(restaurantReview, forKey: "restaurant_review")
        }
    }
}
