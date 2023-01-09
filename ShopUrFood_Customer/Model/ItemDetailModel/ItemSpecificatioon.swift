//
//  ItemSpecificatioon.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 22, 2019

import Foundation


class ItemSpecificatioon : NSObject, NSCoding{

    var specificationDescription : String!
    var specificationTitle : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        specificationDescription = dictionary["specification_description"] as? String
        specificationTitle = dictionary["specification_title"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if specificationDescription != nil{
            dictionary["specification_description"] = specificationDescription
        }
        if specificationTitle != nil{
            dictionary["specification_title"] = specificationTitle
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        specificationDescription = aDecoder.decodeObject(forKey: "specification_description") as? String
        specificationTitle = aDecoder.decodeObject(forKey: "specification_title") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if specificationDescription != nil{
            aCoder.encode(specificationDescription, forKey: "specification_description")
        }
        if specificationTitle != nil{
            aCoder.encode(specificationTitle, forKey: "specification_title")
        }
    }
}