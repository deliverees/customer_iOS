//
//  RestaurantReview.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 18, 2019

import Foundation


class RestaurantReview : NSObject, NSCoding{

    var reviewComments : String!
    var reviewCustomerName : String!
    var reviewCustomerProfile : String!
    var reviewRating : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        reviewComments = dictionary["review_comments"] as? String
        reviewCustomerName = dictionary["review_customer_name"] as? String
        reviewCustomerProfile = dictionary["review_customer_profile"] as? String
        reviewRating = dictionary["review_rating"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if reviewComments != nil{
            dictionary["review_comments"] = reviewComments
        }
        if reviewCustomerName != nil{
            dictionary["review_customer_name"] = reviewCustomerName
        }
        if reviewCustomerProfile != nil{
            dictionary["review_customer_profile"] = reviewCustomerProfile
        }
        if reviewRating != nil{
            dictionary["review_rating"] = reviewRating
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        reviewComments = aDecoder.decodeObject(forKey: "review_comments") as? String
        reviewCustomerName = aDecoder.decodeObject(forKey: "review_customer_name") as? String
        reviewCustomerProfile = aDecoder.decodeObject(forKey: "review_customer_profile") as? String
        reviewRating = aDecoder.decodeObject(forKey: "review_rating") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if reviewComments != nil{
            aCoder.encode(reviewComments, forKey: "review_comments")
        }
        if reviewCustomerName != nil{
            aCoder.encode(reviewCustomerName, forKey: "review_customer_name")
        }
        if reviewCustomerProfile != nil{
            aCoder.encode(reviewCustomerProfile, forKey: "review_customer_profile")
        }
        if reviewRating != nil{
            aCoder.encode(reviewRating, forKey: "review_rating")
        }
    }
}