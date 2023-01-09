//
//  CategoryList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 18, 2019

import Foundation


class CategoryList : NSObject, NSCoding{

    var mainCategoryId : Int!
    var mainCategoryName : String!
    var subCategoryList : [SubCategoryList]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        mainCategoryId = dictionary["main_category_id"] as? Int
        mainCategoryName = dictionary["main_category_name"] as? String
        subCategoryList = [SubCategoryList]()
        if let subCategoryListArray = dictionary["sub_category_list"] as? [[String:Any]]{
            for dic in subCategoryListArray{
                let value = SubCategoryList(fromDictionary: dic)
                subCategoryList.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if mainCategoryId != nil{
            dictionary["main_category_id"] = mainCategoryId
        }
        if mainCategoryName != nil{
            dictionary["main_category_name"] = mainCategoryName
        }
        if subCategoryList != nil{
            var dictionaryElements = [[String:Any]]()
            for subCategoryListElement in subCategoryList {
                dictionaryElements.append(subCategoryListElement.toDictionary())
            }
            dictionary["subCategoryList"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        mainCategoryId = aDecoder.decodeObject(forKey: "main_category_id") as? Int
        mainCategoryName = aDecoder.decodeObject(forKey: "main_category_name") as? String
        subCategoryList = aDecoder.decodeObject(forKey: "sub_category_list") as? [SubCategoryList]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if mainCategoryId != nil{
            aCoder.encode(mainCategoryId, forKey: "main_category_id")
        }
        if mainCategoryName != nil{
            aCoder.encode(mainCategoryName, forKey: "main_category_name")
        }
        if subCategoryList != nil{
            aCoder.encode(subCategoryList, forKey: "sub_category_list")
        }
    }
}