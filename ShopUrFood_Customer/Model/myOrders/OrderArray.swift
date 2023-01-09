//
//  OrderArray.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 1, 2019

import Foundation


class OrderArray : NSObject, NSCoding{

    var ordCurrency : String!
    var orderAmount : String!
    var orderDate : String!
    var orderId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        ordCurrency = dictionary["ordCurrency"] as? String
        orderAmount = dictionary["orderAmount"] as? String
        orderDate = dictionary["orderDate"] as? String
        orderId = dictionary["orderId"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if ordCurrency != nil{
            dictionary["ordCurrency"] = ordCurrency
        }
        if orderAmount != nil{
            dictionary["orderAmount"] = orderAmount
        }
        if orderDate != nil{
            dictionary["orderDate"] = orderDate
        }
        if orderId != nil{
            dictionary["orderId"] = orderId
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        ordCurrency = aDecoder.decodeObject(forKey: "ordCurrency") as? String
        orderAmount = aDecoder.decodeObject(forKey: "orderAmount") as? String
        orderDate = aDecoder.decodeObject(forKey: "orderDate") as? String
        orderId = aDecoder.decodeObject(forKey: "orderId") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if ordCurrency != nil{
            aCoder.encode(ordCurrency, forKey: "ordCurrency")
        }
        if orderAmount != nil{
            aCoder.encode(orderAmount, forKey: "orderAmount")
        }
        if orderDate != nil{
            aCoder.encode(orderDate, forKey: "orderDate")
        }
        if orderId != nil{
            aCoder.encode(orderId, forKey: "orderId")
        }
    }
}