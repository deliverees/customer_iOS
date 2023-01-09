//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 1, 2019

import Foundation


class MyOrderData : NSObject, NSCoding{

    var orderArray : [OrderArray]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        orderArray = [OrderArray]()
        if let orderArrayArray = dictionary["orderArray"] as? [[String:Any]]{
            for dic in orderArrayArray{
                let value = OrderArray(fromDictionary: dic)
                orderArray.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if orderArray != nil{
            var dictionaryElements = [[String:Any]]()
            for orderArrayElement in orderArray {
                dictionaryElements.append(orderArrayElement.toDictionary())
            }
            dictionary["orderArray"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        orderArray = aDecoder.decodeObject(forKey: "orderArray") as? [OrderArray]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if orderArray != nil{
            aCoder.encode(orderArray, forKey: "orderArray")
        }
    }
}
