//
//  SubCategoryList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 18, 2019

import Foundation


class SubCategoryList : NSObject, NSCoding{

    var subCategoryId : Int!
    var subCategoryName : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        subCategoryId = dictionary["sub_category_id"] as? Int
        subCategoryName = dictionary["sub_category_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if subCategoryId != nil{
            dictionary["sub_category_id"] = subCategoryId
        }
        if subCategoryName != nil{
            dictionary["sub_category_name"] = subCategoryName
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        subCategoryId = aDecoder.decodeObject(forKey: "sub_category_id") as? Int
        subCategoryName = aDecoder.decodeObject(forKey: "sub_category_name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if subCategoryId != nil{
            aCoder.encode(subCategoryId, forKey: "sub_category_id")
        }
        if subCategoryName != nil{
            aCoder.encode(subCategoryName, forKey: "sub_category_name")
        }
    }
}