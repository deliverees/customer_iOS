//
//  CartChoice.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 26, 2019

import Foundation


class CartChoice : NSObject, NSCoding{
    var choiceAmount : String = ""
    var choiceId : Int = -1
    var choiceName : String = ""
    private(set) var choiceType: ChoiceType = .one
    enum ChoiceType: String {
        case one
        case two
        case three
    }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        if let choiceIdInt = dictionary["choice_id"] as? Int {
            choiceId = choiceIdInt
            choiceType = .one
        } else if let choiceIdInt = dictionary["choiceTwo_id"] as? Int {
            choiceId = choiceIdInt
            choiceType = .two
        } else if let choiceIdInt = dictionary["choiceThree_id"] as? Int {
            choiceId = choiceIdInt
            choiceType = .three
        } else {
            choiceId = -1
            assertionFailure("Invalid choice id")
        }
        
        if let choiceAmountString = dictionary["choice_amount"] as? String {
            choiceAmount = choiceAmountString
        } else if let choiceAmountInt = dictionary["choice_amount"] as? Int {
            choiceAmount = "\(choiceAmountInt)"
        } else if let choiceAmountString = dictionary["choiceTwo_amount"] as? String {
            choiceAmount = choiceAmountString
        } else if let choiceAmountInt = dictionary["choiceTwo_amount"] as? Int {
            choiceAmount = "\(choiceAmountInt)"
        } else if let choiceAmountString = dictionary["choiceThree_amount"] as? String {
            choiceAmount = choiceAmountString
        } else if let choiceAmountInt = dictionary["choiceThree_amount"] as? Int {
            choiceAmount = "\(choiceAmountInt)"
        } else {
            choiceAmount = ""
            assertionFailure("Invalid choice amount kind")
        }
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
            let key = choiceType == .one ? "choice_id" : choiceType == .two ? "choiceTwo_id" : "choiceThree_id"
            dictionary[key] = choiceId
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
        choiceAmount = aDecoder.decodeObject(forKey: "choice_amount") as? String
        ?? "\(aDecoder.decodeObject(forKey: "choice_amount") as? Int ?? 0)"
        if let idInt = aDecoder.decodeObject(forKey: "choice_id") as? Int {
            choiceId = idInt
            choiceType = .one
        } else if let idInt = aDecoder.decodeObject(forKey: "choiceTwo_id") as? Int {
            choiceId = idInt
            choiceType = .two
        } else if let idInt = aDecoder.decodeObject(forKey: "choiceThree_id") as? Int {
            choiceId = idInt
            choiceType = .three
        } else {
            choiceId = -1
            assertionFailure("Invalid choice id")
        }
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
            let key = choiceType == .one ? "choice_id" : choiceType == .two ? "choiceTwo_id" : "choiceThree_id"
            aCoder.encode(choiceId, forKey: key)
        }
        if !choiceName.isEmpty {
            aCoder.encode(choiceName, forKey: "choice_name")
        }
    }
}

extension CartChoice.ChoiceType {
    var toCartItemChoiceType: CartItemChoice.CartItemChoiceType {
        switch self {
        case .one:
            return .one
        case .two:
            return .two
        case .three:
            return .three
        }
    }
}
