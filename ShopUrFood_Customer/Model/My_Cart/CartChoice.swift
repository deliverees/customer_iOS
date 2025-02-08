//
//  CartChoice.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 26, 2019

import Foundation


class CartChoice : NSObject, NSCoding{

    var choiceAmount : String = ""
    var choiceId : Int = -1
    var choiceName : String = ""


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let choiceAmountString = dictionary["choice_amount"] as? String {
            choiceAmount = choiceAmountString
        } else if let choiceAmountInt = dictionary["choice_amount"] as? Int {
            choiceAmount = "\(choiceAmountInt)"
        } else {
            choiceAmount = ""
        }
        choiceId = dictionary["choice_id"] as? Int ?? -1
        choiceName = dictionary["choice_name"] as? String ?? ""
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if !choiceAmount.isEmpty {
            dictionary["choice_amount"] = choiceAmount
        }
        if choiceId != -1 {
            dictionary["choice_id"] = choiceId
        }
        if !choiceName.isEmpty {
            dictionary["choice_name"] = choiceName
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        choiceAmount = aDecoder.decodeObject(forKey: "choice_amount") as? String ?? ""
        choiceId = aDecoder.decodeObject(forKey: "choice_id") as? Int ?? -1
        choiceName = aDecoder.decodeObject(forKey: "choice_name") as? String ?? ""
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if !choiceAmount.isEmpty {
            aCoder.encode(choiceAmount, forKey: "choice_amount")
        }
        if choiceId != -1 {
            aCoder.encode(choiceId, forKey: "choice_id")
        }
        if !choiceName.isEmpty {
            aCoder.encode(choiceName, forKey: "choice_name")
        }
    }
}
