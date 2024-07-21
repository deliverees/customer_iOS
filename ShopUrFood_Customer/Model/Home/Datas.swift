//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 14, 2019

import Foundation


class Datas : NSObject, NSCoding{

    var allRestaurant : [AllRestaurant]!
    var allRestaurantDetails : [AllRestaurantDetail]! // They come based on category
    var featuredRestaurant : [FeaturedRestaurant]!
    var category_list : [AllCategoriesDetail]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        allRestaurant = [AllRestaurant]()
        if let allRestaurantArray = dictionary["all_restaurant"] as? [[String:Any]]{
            for dic in allRestaurantArray{
                let value = AllRestaurant(fromDictionary: dic)
                allRestaurant.append(value)
            }
            allRestaurant.reverse()
        }
        allRestaurantDetails = [AllRestaurantDetail]()
        if let allRestaurantDetailsArray = dictionary["all_restaurant_details"] as? [[String:Any]]{
            for dic in allRestaurantDetailsArray{
                let value = AllRestaurantDetail(fromDictionary: dic)
                allRestaurantDetails.append(value)
            }
            //allRestaurantDetails.reverse()
        }
        featuredRestaurant = [FeaturedRestaurant]()
        if let featuredRestaurantArray = dictionary["featured_restaurant"] as? [[String:Any]]{
            for dic in featuredRestaurantArray{
                let value = FeaturedRestaurant(fromDictionary: dic)
                featuredRestaurant.append(value)
            }
        }
        category_list = [AllCategoriesDetail]()
        do {
            var dictionary = [String:Any]()
            dictionary["category_id"] = 0
            dictionary["category_name"] = "Todos"
            dictionary["category_image"] = "ic_cat_all_en"
            let value = AllCategoriesDetail(fromDictionary: dictionary)
            category_list.append(value)
        } catch {
            print("Unexpected error: \(error).")
        }
        if let categoryListArray = dictionary["category_list"] as? [[String:Any]]{
            for dic in categoryListArray{
                let value = AllCategoriesDetail(fromDictionary: dic)
                category_list.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if allRestaurant != nil{
            var dictionaryElements = [[String:Any]]()
            for allRestaurantElement in allRestaurant {
                dictionaryElements.append(allRestaurantElement.toDictionary())
            }
            dictionary["allRestaurant"] = dictionaryElements
        }
        if allRestaurantDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for allRestaurantDetailsElement in allRestaurantDetails {
                dictionaryElements.append(allRestaurantDetailsElement.toDictionary())
            }
            dictionary["allRestaurantDetails"] = dictionaryElements
        }
        if featuredRestaurant != nil{
            var dictionaryElements = [[String:Any]]()
            for featuredRestaurantElement in featuredRestaurant {
                dictionaryElements.append(featuredRestaurantElement.toDictionary())
            }
            dictionary["featuredRestaurant"] = dictionaryElements
        }
        if category_list != nil{
            var dictionaryElements = [[String:Any]]()
            for categoryListElement in category_list {
                dictionaryElements.append(categoryListElement.toDictionary())
            }
            dictionary["category_list"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        allRestaurant = aDecoder.decodeObject(forKey: "all_restaurant") as? [AllRestaurant]
        allRestaurantDetails = aDecoder.decodeObject(forKey: "all_restaurant_details") as? [AllRestaurantDetail]
        featuredRestaurant = aDecoder.decodeObject(forKey: "featured_restaurant") as? [FeaturedRestaurant]
        category_list = aDecoder.decodeObject(forKey: "category_list") as? [AllCategoriesDetail]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if allRestaurant != nil{
            aCoder.encode(allRestaurant, forKey: "all_restaurant")
        }
        if allRestaurantDetails != nil{
            aCoder.encode(allRestaurantDetails, forKey: "all_restaurant_details")
        }
        if featuredRestaurant != nil{
            aCoder.encode(featuredRestaurant, forKey: "featured_restaurant")
        }
        if category_list != nil{
            aCoder.encode(category_list, forKey: "category_list")
        }
    }
}
