//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 15, 2019

import Foundation


class ProfileData : NSObject, NSCoding{

    var userAddress : String!
    var userAvatar : String!
    var userEmail : String!
    var userId : Int!
    var userLatitude : String!
    var userLongitude : String!
    var userName : String!
    var userPhone : String!
    var userPhone2 : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        userAddress = dictionary["user_address"] as? String
        userAvatar = dictionary["user_avatar"] as? String
        userEmail = dictionary["user_email"] as? String
        userId = dictionary["user_id"] as? Int
        userLatitude = dictionary["user_latitude"] as? String
        userLongitude = dictionary["user_longitude"] as? String
        userName = dictionary["user_name"] as? String
        userPhone = dictionary["user_phone"] as? String
        userPhone2 = dictionary["user_phone2"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if userAddress != nil{
            dictionary["user_address"] = userAddress
        }
        if userAvatar != nil{
            dictionary["user_avatar"] = userAvatar
        }
        if userEmail != nil{
            dictionary["user_email"] = userEmail
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userLatitude != nil{
            dictionary["user_latitude"] = userLatitude
        }
        if userLongitude != nil{
            dictionary["user_longitude"] = userLongitude
        }
        if userName != nil{
            dictionary["user_name"] = userName
        }
        if userPhone != nil{
            dictionary["user_phone"] = userPhone
        }
        if userPhone2 != nil{
            dictionary["user_phone2"] = userPhone2
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        userAddress = aDecoder.decodeObject(forKey: "user_address") as? String
        userAvatar = aDecoder.decodeObject(forKey: "user_avatar") as? String
        userEmail = aDecoder.decodeObject(forKey: "user_email") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
        userLatitude = aDecoder.decodeObject(forKey: "user_latitude") as? String
        userLongitude = aDecoder.decodeObject(forKey: "user_longitude") as? String
        userName = aDecoder.decodeObject(forKey: "user_name") as? String
        userPhone = aDecoder.decodeObject(forKey: "user_phone") as? String
        userPhone2 = aDecoder.decodeObject(forKey: "user_phone2") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if userAddress != nil{
            aCoder.encode(userAddress, forKey: "user_address")
        }
        if userAvatar != nil{
            aCoder.encode(userAvatar, forKey: "user_avatar")
        }
        if userEmail != nil{
            aCoder.encode(userEmail, forKey: "user_email")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userLatitude != nil{
            aCoder.encode(userLatitude, forKey: "user_latitude")
        }
        if userLongitude != nil{
            aCoder.encode(userLongitude, forKey: "user_longitude")
        }
        if userName != nil{
            aCoder.encode(userName, forKey: "user_name")
        }
        if userPhone != nil{
            aCoder.encode(userPhone, forKey: "user_phone")
        }
        if userPhone2 != nil{
            aCoder.encode(userPhone2, forKey: "user_phone2")
        }
    }
}
