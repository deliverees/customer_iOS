//
//  ItemChoice.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 26, 2019

import Foundation


class ItemChoice : NSObject, NSCoding{
    
    var choiceId : Int!
    var choiceName : String!
    var choicePrice : String!
    var choiceCurrency : String!
    var titleChoice: String = ""
    var choiceType: ChoiceType = .one
    enum ChoiceType {
        case one
        case two
        case three
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let choiceId = dictionary["choice_id"] as? Int {
            self.choiceId = choiceId
            self.choiceType = .one
        } else if let choiceId = dictionary["choiceTwo_id"] as? Int {
            self.choiceId = choiceId
            self.choiceType = .two
        } else if let choiceId = dictionary["choiceThree_id"] as? Int {
            self.choiceId = choiceId
            self.choiceType = .three
        } else {
            self.choiceId = -1
            self.choiceType = .one
            assertionFailure("Choice ID not found in dictionary")
        }
        var priceKey = "choice_price"
        var titleKey = "title_choice"
        switch choiceType {
        case .one:
            break
        case .two:
            priceKey = "choiceTwo_price"
            titleKey = "titleTwo_choice"
        case .three:
            priceKey = "choiceThree_price"
            titleKey = "titleThree_choice"
        }
        if let amountString = dictionary[priceKey] as? String {
            choicePrice = amountString
        } else if let amountInt = dictionary[priceKey] as? Int {
            choicePrice = String(amountInt)
        } else {
            choicePrice = "0.00"
        }
        titleChoice = dictionary[titleKey] as? String ?? ""
        choiceName = dictionary["choice_name"] as? String ?? ""
        choiceCurrency = dictionary["choice_currency"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var idKey = choiceType == .one ? "choice_id" : choiceType == .two ? "choiceTwo_id" : "choiceThree_id"
        var priceKey = choiceType == .one ? "choice_price" : choiceType == .two ? "choiceTwo_price" : "choiceThree_price"
        var titleKey = choiceType == .one ? "title_choice" : choiceType == .two ? "titleTwo_choice" : "titleThree_choice"
        var dictionary = [String:Any]()
        if choiceId != nil{
            dictionary[idKey] = choiceId
        }
        if choiceName != nil{
            dictionary["choice_name"] = choiceName
        }
        if choicePrice != nil{
            dictionary[priceKey] = choicePrice
        }
        if choiceCurrency != nil{
            dictionary["choice_currency"] = choiceCurrency
        }
        if !titleChoice.isEmpty {
            dictionary[titleKey] = titleChoice
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        choiceId = aDecoder.decodeObject(forKey: "choice_id") as? Int ?? aDecoder.decodeObject(forKey: "choiceTwo_id") as? Int ?? aDecoder.decodeObject(forKey: "choiceThree_id") as? Int
        choiceType = aDecoder.decodeObject(forKey: "choice_id") as? Int != nil ? .one : aDecoder.decodeObject(forKey: "choiceTwo_id") as? Int != nil ? .two : .three
        choiceName = aDecoder.decodeObject(forKey: "choice_name") as? String
        choicePrice = aDecoder.decodeObject(forKey: "choice_price") as? String ?? aDecoder.decodeObject(forKey: "choiceTwo_price") as? String ?? aDecoder.decodeObject(forKey: "choiceThree_price") as? String
        choiceCurrency = aDecoder.decodeObject(forKey: "choice_currency") as? String
        titleChoice = aDecoder.decodeObject(forKey: "title_choice") as? String ?? aDecoder.decodeObject(forKey: "titleTwo_choice") as? String ?? aDecoder.decodeObject(forKey: "titleThree_choice") as? String ?? ""
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        var idKey = choiceType == .one ? "choice_id" : choiceType == .two ? "choiceTwo_id" : "choiceThree_id"
        var priceKey = choiceType == .one ? "choice_price" : choiceType == .two ? "choiceTwo_price" : "choiceThree_price"
        var titleKey = choiceType == .one ? "title_choice" : choiceType == .two ? "titleTwo_choice" : "titleThree_choice"
        if choiceId != nil{
            aCoder.encode(choiceId, forKey: idKey)
        }
        if choiceName != nil{
            aCoder.encode(choiceName, forKey: "choice_name")
        }
        if choicePrice != nil{
            aCoder.encode(choicePrice, forKey: priceKey)
        }
        if choiceCurrency != nil{
            aCoder.encode(choiceCurrency, forKey: "choice_currency")
        }
        if !titleChoice.isEmpty {
            aCoder.encode(titleChoice, forKey: titleKey)
        }
    }
}
