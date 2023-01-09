//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 22, 2019

import Foundation


class ItemDetailData : NSObject, NSCoding{

    var choices : [Choice]!
    var itemReviews : [AnyObject]!
    var itemtInfo : ItemtInfo!
    var relatedItems : [RelatedItem]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let itemtInfoData = dictionary["itemt_info"] as? [String:Any]{
            itemtInfo = ItemtInfo(fromDictionary: itemtInfoData)
        }
        choices = [Choice]()
        if let choicesArray = dictionary["choices"] as? [[String:Any]]{
            for dic in choicesArray{
                let value = Choice(fromDictionary: dic)
                choices.append(value)
            }
        }
        relatedItems = [RelatedItem]()
        if let relatedItemsArray = dictionary["related_items"] as? [[String:Any]]{
            for dic in relatedItemsArray{
                let value = RelatedItem(fromDictionary: dic)
                relatedItems.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if itemtInfo != nil{
            dictionary["itemtInfo"] = itemtInfo.toDictionary()
        }
        if choices != nil{
            var dictionaryElements = [[String:Any]]()
            for choicesElement in choices {
                dictionaryElements.append(choicesElement.toDictionary())
            }
            dictionary["choices"] = dictionaryElements
        }
        if relatedItems != nil{
            var dictionaryElements = [[String:Any]]()
            for relatedItemsElement in relatedItems {
                dictionaryElements.append(relatedItemsElement.toDictionary())
            }
            dictionary["relatedItems"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        choices = aDecoder.decodeObject(forKey: "choices") as? [Choice]
        itemReviews = aDecoder.decodeObject(forKey: "item_reviews") as? [AnyObject]
        itemtInfo = aDecoder.decodeObject(forKey: "itemt_info") as? ItemtInfo
        relatedItems = aDecoder.decodeObject(forKey: "related_items") as? [RelatedItem]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if choices != nil{
            aCoder.encode(choices, forKey: "choices")
        }
        if itemReviews != nil{
            aCoder.encode(itemReviews, forKey: "item_reviews")
        }
        if itemtInfo != nil{
            aCoder.encode(itemtInfo, forKey: "itemt_info")
        }
        if relatedItems != nil{
            aCoder.encode(relatedItems, forKey: "related_items")
        }
    }
}
