//
//  CommomParsing.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 08/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Alamofire

class CommomParsing: BaseParsing {
    var blockStatus = Bool()
    
    
    //Login
    public func NormalEmailLoginParse(lang:String,login_id:String,cus_password:String,ios_fcm_id:String,type:String,ios_device_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(login_id, forKey: "login_id")
        requestDict.setValue(cus_password, forKey: "cus_password")
        requestDict.setValue(ios_fcm_id, forKey: "ios_fcm_id")
        requestDict.setValue(ios_device_id, forKey: "ios_device_id")
        requestDict.setValue(type, forKey: "type")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:USER_LOGIN as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Register
    public func userRegister(lang:String,cus_fname:String,cus_email:String,cus_password:String,cus_phone1:String,referral_code:String,ios_device_id:String,ios_fcm_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cus_fname, forKey: "cus_fname")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_password, forKey: "cus_password")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(referral_code, forKey: "referral_code")
        requestDict.setValue(ios_device_id, forKey: "ios_device_id")
        requestDict.setValue(ios_fcm_id, forKey: "ios_fcm_id")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:REGISTER as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Splash Screen & Icon's
    public func getSplash(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue("ios", forKey: "type")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:HOME_SCREEN as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //FB Login
    public func faceBookLogin(lang:String,facebook_id:String,email:String,name:String,type:String,ios_fcm_id:String,ios_device_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(facebook_id, forKey: "facebook_id")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(name, forKey: "name")
        requestDict.setValue(ios_fcm_id, forKey: "ios_fcm_id")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(ios_device_id, forKey: "ios_device_id")
        
        
        
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:FB_LOGIN as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Apple Login
    public func AppleLogin(lang:String,apple_id:String,email:String,name:String,type:String,ios_fcm_id:String,ios_device_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(apple_id, forKey: "apple_id")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(name, forKey: "name")
        requestDict.setValue(ios_fcm_id, forKey: "ios_fcm_id")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(ios_device_id, forKey: "ios_device_id")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:APPLE_LOGIN as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Google Login
    public func GoogleLogin(lang:String,google_id:String,email:String,name:String,type:String,ios_fcm_id:String,ios_device_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(google_id, forKey: "google_id")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(name, forKey: "name")
        requestDict.setValue(ios_fcm_id, forKey: "ios_fcm_id")
        requestDict.setValue(ios_device_id, forKey: "ios_device_id")
        requestDict.setValue(type, forKey: "type")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:GOOGLE_LOGIN as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Forget Password
    public func forgetPassword(lang:String,cus_email:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cus_email, forKey: "cus_email")
        
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:FORGET_PASSWORD as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Help Data
    public func HelpPageData(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:HELP as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Terms Data
    public func TermsPageData(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:TERMS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    
    //Resturant Home
    public func Resturant_Home_Pasre(lang:String,user_latitude:String,user_longitude:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(user_latitude, forKey: "user_latitude")
        requestDict.setValue(user_longitude, forKey: "user_longitude")
        self.blockResponse = self.blockStatus
        if let tokenStr = login_session.object(forKey: "user_token") as? String {
            //make base method call
            self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:RESTURANT_HOME as NSString, params: (requestDict as! Parameters), onSuccess: {response in
                success(response)
            }, onFailure: {errorResponse in
                failure(errorResponse)
            })
        } else {
            self.ParsingFunctionCall(subURl: RESTURANT_HOME_V1 as NSString,
                                     params: (requestDict as! Parameters),
                                     encoding: JSONEncoding.default,
                                     onSuccess: success, onFailure: failure)
        }
    }
    
    //customer profile Details
    public func userProfileInfo(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:PROFILE as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Update customer profile Details
    public func updateUserProfileInfo(lang:String,cus_name:String,cus_email:String,cus_phone1:String,cus_phone2:String,cus_address:String,cus_lat:String,cus_long:String,cus_image:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cus_name, forKey: "cus_name")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(cus_phone2, forKey: "cus_phone2")
        requestDict.setValue(cus_address, forKey: "cus_address")
        requestDict.setValue(cus_lat, forKey: "cus_lat")
        requestDict.setValue(cus_long, forKey: "cus_long")
        requestDict.setValue(cus_image, forKey: "cus_image")
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:UPDATE_PROFILE as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    
    
    //Get Restaurant Details
    public func restaurantDetails(lang:String,restaurant_id:String,review_page_no:String,search_text:String,sort_by:String,item_type:Any,search_halal:String,search_combo:String,orderBy_spl_offer:String,orderBy_top_offers:String,available_time:Any,page_no:Int,initial_loading:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(restaurant_id, forKey: "restaurant_id")
        requestDict.setValue(review_page_no, forKey: "review_page_no")
        requestDict.setValue(search_text, forKey: "search_text")
        requestDict.setValue(sort_by, forKey: "sort_by")
        requestDict.setValue(item_type, forKey: "item_type")
        requestDict.setValue(search_halal, forKey: "search_halal")
        requestDict.setValue(search_combo, forKey: "search_combo")
        requestDict.setValue(orderBy_spl_offer, forKey: "orderBy_spl_offer")
        requestDict.setValue(orderBy_top_offers, forKey: "orderBy_top_offers")
        requestDict.setValue(available_time, forKey: "available_time")
        requestDict.setValue(page_no, forKey: "page_no")
        requestDict.setValue(initial_loading, forKey: "initial_loading")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        if let tokenStr = login_session.object(forKey: "user_token") as? String {
            self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:RESTAURANT_DETAILS_API as NSString, params: (requestDict as! Parameters), encoding: URLEncoding.queryString, onSuccess: {response in
                success(response)
            }, onFailure: {errorResponse in
                failure(errorResponse)
            })
        } else {
            self.ParsingFunctionCall(subURl: RESTAURANT_DETAILS_API_V1 as NSString,
                                     params: (requestDict as! Parameters),
                                     encoding: JSONEncoding.default,
                                     onSuccess: success, onFailure: failure)
            //            self.ParsingFunctionCallQueryParams(subURl: RESTAURANT_DETAILS_API_V1 as NSString,
            //                                                params: (requestDict as! Parameters),
            //                                                onSuccess: success, onFailure: failure)
        }
    }
    
    //Get Category based items
    public func getCategoryBasedItems(lang:String,restaurant_id:String,main_category_id:String,sub_category_id:String,sort_by:String,search_text:String,page_no:Int,all:String,item_type:Any,search_halal:String,search_combo:String,orderBy_spl_offer:String,orderBy_top_offers:String,available_time:Any,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(restaurant_id, forKey: "restaurant_id")
        requestDict.setValue(main_category_id, forKey: "main_category_id")
        requestDict.setValue(sub_category_id, forKey: "sub_category_id")
        requestDict.setValue(sort_by, forKey: "sort_by")
        requestDict.setValue(search_text, forKey: "search_text")
        requestDict.setValue(page_no, forKey: "page_no")
        requestDict.setValue(all, forKey: "all")
        requestDict.setValue(item_type, forKey: "item_type")
        requestDict.setValue(search_halal, forKey: "search_halal")
        requestDict.setValue(search_combo, forKey: "search_combo")
        requestDict.setValue(orderBy_spl_offer, forKey: "orderBy_spl_offer")
        requestDict.setValue(orderBy_top_offers, forKey: "orderBy_top_offers")
        requestDict.setValue(available_time, forKey: "available_time")
        
        print("getCategoryBasedItems : ",requestDict)
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CATEGORY_BASE_ITEM as NSString, params: (requestDict as! Parameters), encoding: URLEncoding.queryString, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Item Details
    public func getItemDetails(lang:String,item_id:String,review_page_no:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(item_id, forKey: "item_id")
        requestDict.setValue(review_page_no, forKey: "review_page_no")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ITEM_DETAILS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Save Shipping Address
    public func saveShippingAddress(lang:String,search_latitude:String,search_longitude:String,zipcode:String,location:String,address:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(search_latitude, forKey: "search_latitude")
        requestDict.setValue(search_longitude, forKey: "search_longitude")
        requestDict.setValue(location, forKey: "location")
        requestDict.setValue(zipcode, forKey: "zipcode")
        requestDict.setValue(address, forKey: "address")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:SAVE_SHIPPING_ADDRESS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get AllRestaurant Details
    public func getAllRestaurantList(lang:String,user_latitude:String,user_longitude:String,page:Int,category_id:Any,search_halal:String,orderBy_delivery:String,orderBy_rating:String,orderBy_offers:String,restaurant_type:Any,prefer_time:Any,search_key:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(user_latitude, forKey: "user_latitude")
        requestDict.setValue(user_longitude, forKey: "user_longitude")
        requestDict.setValue(page, forKey: "page")
        requestDict.setValue(category_id, forKey: "category_id")
        requestDict.setValue(search_halal, forKey: "search_halal")
        requestDict.setValue(orderBy_delivery, forKey: "orderBy_delivery")
        requestDict.setValue(orderBy_rating, forKey: "orderBy_rating")
        requestDict.setValue(orderBy_offers, forKey: "orderBy_offers")
        requestDict.setValue(restaurant_type, forKey: "restaurant_type")
        requestDict.setValue(prefer_time, forKey: "prefer_time")
        requestDict.setValue(search_key, forKey: "search_key")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ALL_RESTAURANT_LIST as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Item Add To Cart
    public func itemAddToCart(lang:String,item_id:String,st_id:String,quantity:String,choices_id:[Int],special_notes:String,force_update:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        
        let emptyChoiceArray = NSMutableArray()
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(item_id, forKey: "item_id")
        requestDict.setValue(st_id, forKey: "st_id")
        requestDict.setValue(quantity, forKey: "quantity")
        if choices_id.count == 0 {
            requestDict.setValue([0], forKey: "choices_id")
        }else{
            requestDict.setValue(choices_id, forKey: "choices_id")
        }
        
        requestDict.setValue(special_notes, forKey: "special_notes")
        requestDict.setValue(force_update, forKey: "force_update")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ADD_TO_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get AllRestaurant Details
    public func getMyCartData(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:MY_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Update Cart Qunantity
    public func updateCart(lang:String,cart_id:String,quantity:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cart_id, forKey: "cart_id")
        requestDict.setValue(quantity, forKey: "quantity")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:QTY_UPDATE_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Remove choice from Cart
    public func removeChoiceFromCart(lang:String,cart_id:String,product_id:String,choice_id:[Int],onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cart_id, forKey: "cart_id")
        requestDict.setValue(product_id, forKey: "product_id")
        requestDict.setValue(choice_id, forKey: "choice_id")
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CHOICE_REMOVE_FROM_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Order Details
    public func getOrderDetails(lang:String,page_no:String,order_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        requestDict.setValue(order_id, forKey: "order_id")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ORDER_DETAILS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Remove Item From Cart
    public func removeFromCart(lang:String,cart_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cart_id, forKey: "cart_id")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:REMOVE_FROM_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Choice Remove From Cart
    public func choiceRemoveFromCart(lang:String,cart_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cart_id, forKey: "cart_id")
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:REMOVE_FROM_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Use Wallet Amount methods
    public func useWalletMethod(lang:String,ord_self_pickup:Any,use_wallet:Any,wallet_amt:Any,delivery_fee:Any,use_coupon:Any,coupon_id:Any,coupon_amount:Any,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(ord_self_pickup, forKey: "ord_self_pickup")
        requestDict.setValue(use_wallet, forKey: "use_wallet")
        requestDict.setValue(wallet_amt, forKey: "wallet_amt")
        requestDict.setValue(delivery_fee, forKey: "delivery_fee")
        requestDict.setValue(use_coupon, forKey: "use_coupon")
        requestDict.setValue(coupon_id, forKey: "coupon_id")
        requestDict.setValue(coupon_amount, forKey: "coupon_amount")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        print("useWalletMethod : ",requestDict)
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:USE_WALLET as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Use Offer Amount methods
    public func useOfferMethod(lang:String,ord_self_pickup:Any,use_wallet:Any,wallet_amt:Any,delivery_fee:Any,use_coupon:Any,coupon_id:String,coupon_amount:Any,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(ord_self_pickup, forKey: "ord_self_pickup")
        requestDict.setValue(use_wallet, forKey: "use_wallet")
        requestDict.setValue(wallet_amt, forKey: "wallet_amt")
        requestDict.setValue(delivery_fee, forKey: "delivery_fee")
        requestDict.setValue(use_coupon, forKey: "use_coupon")
        requestDict.setValue(coupon_id, forKey: "coupon_id")
        requestDict.setValue(coupon_amount, forKey: "coupon_amount")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        print("useofferMethod ---> ",requestDict)
        
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:USE_OFFER as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Use Offer Amount methods
    public func checkExistCart(lang:String,item_id:Any,st_id:Any,choices_id:Any,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(item_id, forKey: "item_id")
        requestDict.setValue(st_id, forKey: "st_id")
        requestDict.setValue(choices_id, forKey: "choices_id")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        print("checkExistCart ---> ",requestDict)
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CHECK_EXIST_CART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Available Payment methods
    public func getCountryList(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl:COUNTRY_LIST as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Available Payment methods
    public func getPaymentMethods(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:PAYMENT_METHODS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //PAY BY COD
    public func cod_paymet(lang:String,ord_self_pickup:String,cus_name:String,cus_last_name:String,cus_email:String,cus_phone1:String,cus_phone2:String,cus_address:String,cus_address1:String,cus_lat:String,cus_long:String,use_wallet:String,wallet_amt:String,use_coupon:String,coupon_id:String,coupon_amount:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(ord_self_pickup, forKey: "ord_self_pickup")
        requestDict.setValue(cus_name, forKey: "cus_name")
        requestDict.setValue(cus_last_name, forKey: "cus_last_name")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(cus_phone2, forKey: "cus_phone2")
        requestDict.setValue(cus_address, forKey: "cus_address")
        requestDict.setValue(cus_address1, forKey: "cus_address1")
        requestDict.setValue(cus_lat, forKey: "cus_lat")
        requestDict.setValue(cus_long, forKey: "cus_long")
        requestDict.setValue(use_wallet, forKey: "use_wallet")
        requestDict.setValue(wallet_amt, forKey: "wallet_amt")
        requestDict.setValue(use_coupon, forKey: "use_coupon")
        requestDict.setValue(coupon_id, forKey: "coupon_id")
        requestDict.setValue(coupon_amount, forKey: "coupon_amount")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:COD_CHECKOUT as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    //PAY BY Wallet
    public func wallet_payment(lang:String,ord_self_pickup:String,cus_name:String,cus_last_name:String,cus_email:String,cus_phone1:String,cus_phone2:String,cus_address:String,cus_address1:String,cus_lat:String,cus_long:String,use_wallet:String,wallet_amt:String,use_coupon:String,coupon_id:String,coupon_amount:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(ord_self_pickup, forKey: "ord_self_pickup")
        requestDict.setValue(cus_name, forKey: "cus_name")
        requestDict.setValue(cus_last_name, forKey: "cus_last_name")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(cus_phone2, forKey: "cus_phone2")
        requestDict.setValue(cus_address, forKey: "cus_address")
        requestDict.setValue(cus_address1, forKey: "cus_address1")
        requestDict.setValue(cus_lat, forKey: "cus_lat")
        requestDict.setValue(cus_long, forKey: "cus_long")
        requestDict.setValue(use_wallet, forKey: "use_wallet")
        requestDict.setValue(wallet_amt, forKey: "wallet_amt")
        requestDict.setValue(use_coupon, forKey: "use_coupon")
        requestDict.setValue(coupon_id, forKey: "coupon_id")
        requestDict.setValue(coupon_amount, forKey: "coupon_amount")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:WALLET_CHECKOUT as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //PAY BY COD
    public func payByStripe(lang:String,ord_self_pickup:String,cus_name:String,cus_last_name:String,cus_email:String,cus_phone1:String,cus_phone2:String,cus_address:String,cus_address1:String,cus_lat:String,cus_long:String,use_wallet:String,wallet_amt:String,card_no:String,ccExpiryMonth:String,ccExpiryYear:String,cvvNumber:String,use_coupon:String,coupon_id:String,coupon_amount:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(ord_self_pickup, forKey: "ord_self_pickup")
        requestDict.setValue(cus_name, forKey: "cus_name")
        requestDict.setValue(cus_last_name, forKey: "cus_last_name")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(cus_phone2, forKey: "cus_phone2")
        requestDict.setValue(cus_address, forKey: "cus_address")
        requestDict.setValue(cus_address1, forKey: "cus_address1")
        requestDict.setValue(cus_lat, forKey: "cus_lat")
        requestDict.setValue(cus_long, forKey: "cus_long")
        requestDict.setValue(use_wallet, forKey: "use_wallet")
        requestDict.setValue(wallet_amt, forKey: "wallet_amt")
        requestDict.setValue(card_no, forKey: "card_no")
        requestDict.setValue(ccExpiryMonth, forKey: "ccExpiryMonth")
        requestDict.setValue(ccExpiryYear, forKey: "ccExpiryYear")
        requestDict.setValue(cvvNumber, forKey: "cvvNumber")
        requestDict.setValue(use_coupon, forKey: "use_coupon")
        requestDict.setValue(coupon_id, forKey: "coupon_id")
        requestDict.setValue(coupon_amount, forKey: "coupon_amount")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:STRIPE_CHECKOUT as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //PAY BY PayPal
    public func PayPal_payment(lang:String,ord_self_pickup:String,cus_name:String,cus_last_name:String,cus_email:String,cus_phone1:String,cus_phone2:String,cus_address:String,cus_address1:String,cus_lat:String,cus_long:String,use_wallet:String,wallet_amt:String,transaction_id:String,use_coupon:String,coupon_id:String,coupon_amount:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(ord_self_pickup, forKey: "ord_self_pickup")
        requestDict.setValue(cus_name, forKey: "cus_name")
        requestDict.setValue(cus_last_name, forKey: "cus_last_name")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(cus_phone2, forKey: "cus_phone2")
        requestDict.setValue(cus_address, forKey: "cus_address")
        requestDict.setValue(cus_address1, forKey: "cus_address1")
        requestDict.setValue(cus_lat, forKey: "cus_lat")
        requestDict.setValue(cus_long, forKey: "cus_long")
        requestDict.setValue(use_wallet, forKey: "use_wallet")
        requestDict.setValue(wallet_amt, forKey: "wallet_amt")
        requestDict.setValue(transaction_id, forKey: "transaction_id")
        requestDict.setValue(use_coupon, forKey: "use_coupon")
        requestDict.setValue(coupon_id, forKey: "coupon_id")
        requestDict.setValue(coupon_amount, forKey: "coupon_amount")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:PAYPAL_CHECKOUT as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //My_Orders
    public func getMyOrderData(lang:String,order_num:String,page_no:Int,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(order_num, forKey: "order_num")
        requestDict.setValue(page_no, forKey: "page_no")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:MY_ORDERS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    
    //My_Orders
    public func setOrderToCancell(lang:String,orderId:String,reason:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(orderId, forKey: "orderId")
        requestDict.setValue(reason, forKey: "reason")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CANCEL_ORDER as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Invoice
    public func getCustomerInvoice(lang:String,order_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(order_id, forKey: "order_id")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CUSTOMER_INVOICE as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Customer Profile Information
    public func getCustomerProfileInfo(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CUSTOMER_PROFILE as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //My_wishList
    public func getWishList(lang:String,page_no:Int,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:MY_WISHLIST as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Customer Wallet Information
    public func myWalletData(lang:String,page_no:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:MY_WALLET as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Customer Wallet Information
    public func getHomeSearchData(lang:String,search_key:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(search_key, forKey: "search_key")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:HOME_SEARCH as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Customer Used wallet Information
    public func usedWalletData(lang:String,page_no:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:USED_WALLET as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Customer Total Rewards Information
    public func totRewardsWalletData(lang:String,page_no:Int,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:TOTAL_REWARDS_WALLET as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Get Offer data Information
    public func myOfferData(lang:String,page_no:Int,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:MY_OFFERS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Remove Preorder data Information
    public func removePreOrder(lang:String,store_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(store_id, forKey: "store_id")
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:REMOVE_PREORDER_DATE as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Add_to_wishList
    public func addToWishList(lang:String,product_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(product_id, forKey: "product_id")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ADD_WISHLIST as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Pre order
    public func setPreOrder(lang:String,store_id:String,pre_order_date:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(store_id, forKey: "store_id")
        requestDict.setValue(pre_order_date, forKey: "pre_order_date")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ADD_PREORDER as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Pre order
    public func getCustomerAddress(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CUSTOMER_ADDRESS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Restaurant Details
    public func getCustomerPaymentDetails(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CUSTOMER_PAYMENT_DETAILS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Update customer profile Details
    public func updateUserPaymentDetails(lang:String,stripe_status:String,stripe_clientId:String,stripe_secretId:String,paypal_status:String,paypal_clientId:String,paypal_secretId:String,netBanking_status:String,netBanking_bankName:String,netBanking_branch:String,netBanking_accNo:String,netBanking_ifsc:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(stripe_status, forKey: "stripe_status")
        requestDict.setValue(stripe_clientId, forKey: "stripe_clientId")
        requestDict.setValue(stripe_secretId, forKey: "stripe_secretId")
        requestDict.setValue(paypal_status, forKey: "paypal_status")
        requestDict.setValue(paypal_clientId, forKey: "paypal_clientId")
        requestDict.setValue(paypal_secretId, forKey: "paypal_secretId")
        requestDict.setValue(netBanking_status, forKey: "netBanking_status")
        requestDict.setValue(netBanking_bankName, forKey: "netBanking_bankName")
        requestDict.setValue(netBanking_branch, forKey: "netBanking_branch")
        requestDict.setValue(netBanking_accNo, forKey: "netBanking_accNo")
        requestDict.setValue(netBanking_ifsc, forKey: "netBanking_ifsc")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:UPDATE_CUSTOMER_PAYMENT_DETAILS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Reset Password
    public func userResetPassword(lang:String,old_password:String,new_password:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(old_password, forKey: "old_password")
        requestDict.setValue(new_password, forKey: "new_password")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:RESET_PASSWORD as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Terms and Conditions
    public func termsAndConditions(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:TERMS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Refer friend Data
    public func getReferData(lang:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:REFER_FRIENDS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Refer friend Data
    public func updateUserShippingAddress(lang:String,sh_cus_fname:String,sh_cus_lname:String,sh_cus_email:String,sh_phone1:String,sh_phone2:String,sh_location:String,sh_latitude:String,sh_longitude:String,sh_zipcode:String,sh_location1:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(sh_cus_fname, forKey: "sh_cus_fname")
        requestDict.setValue(sh_cus_lname, forKey: "sh_cus_lname")
        requestDict.setValue(sh_cus_email, forKey: "sh_cus_email")
        requestDict.setValue(sh_phone1, forKey: "sh_phone1")
        requestDict.setValue(sh_phone2, forKey: "sh_phone2")
        requestDict.setValue(sh_location, forKey: "sh_location")
        requestDict.setValue(sh_latitude, forKey: "sh_latitude")
        requestDict.setValue(sh_longitude, forKey: "sh_longitude")
        requestDict.setValue(sh_zipcode, forKey: "sh_zipcode")
        requestDict.setValue(sh_location1, forKey: "sh_location1")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:UPDATE_USER_SHIPPING as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Category Based Restaurant
    public func getCategoryBasedRestaurants(lang:String,user_latitude:String,user_longitude:String,page:Int,category_id:Any,search_halal:String,orderBy_delivery:String,orderBy_rating:String,orderBy_offers:String,restaurant_type:Any,prefer_time:Any,search_key:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(user_latitude, forKey: "user_latitude")
        requestDict.setValue(user_longitude, forKey: "user_longitude")
        requestDict.setValue(page, forKey: "page")
        requestDict.setValue(category_id, forKey: "category_id")
        requestDict.setValue(search_halal, forKey: "search_halal")
        requestDict.setValue(orderBy_delivery, forKey: "orderBy_delivery")
        requestDict.setValue(orderBy_rating, forKey: "orderBy_rating")
        requestDict.setValue(orderBy_offers, forKey: "orderBy_offers")
        requestDict.setValue(restaurant_type, forKey: "restaurant_type")
        requestDict.setValue(prefer_time, forKey: "prefer_time")
        requestDict.setValue(search_key, forKey: "search_key")
        
        print("getCategoryBasedRestaurants params : ",requestDict)
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:CATEGORY_BASE_SHOP as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Category Based Restaurant
    public func GetMyReviews(lang:String,page_no:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(page_no, forKey: "page_no")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:MY_REVIEW as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Send Mail to refer friend
    public func sendReferMail(lang:String,referral_email:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(referral_email, forKey: "referral_email")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:SEND_REFER_MAIL as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Repeat Order
    public func setRepeatOrder(lang:String,order_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(order_id, forKey: "order_id")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:REPEAT_ORDER as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Order Tracking
    public func TrackOrderStatus(lang:String,order_id:String,store_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(order_id, forKey: "order_id")
        requestDict.setValue(store_id, forKey: "store_id")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ORDER_TRACKING as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Post Item Review
    public func postItemReview(lang:String,product_id:String,review_rating:String,review_comments:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(product_id, forKey: "product_id")
        requestDict.setValue(review_rating, forKey: "review_rating")
        requestDict.setValue(review_comments, forKey: "review_comments")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ITEM_WRITE_REVIEW as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //Post Item Review
    public func postStoreReview(lang:String,store_id:String,review_rating:String,review_comments:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(store_id, forKey: "store_id")
        requestDict.setValue(review_rating, forKey: "review_rating")
        requestDict.setValue(review_comments, forKey: "review_comments")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:WIRTE_STORE_REVIEW as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Get Refund Details
    public func getRefundDetails(lang:String,order_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(order_id, forKey: "order_id")
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:REFUND_DETAILS as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    
    //Get Refund Details
    public func updateProfileWithOTP(lang:String,cus_name:String,cus_email:String,cus_phone1:String,cus_phone2:String,cus_address:String,cus_lat:String,cus_long:String,cus_image:String,otp:String,current_otp:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cus_name, forKey: "cus_name")
        requestDict.setValue(cus_email, forKey: "cus_email")
        requestDict.setValue(cus_phone1, forKey: "cus_phone1")
        requestDict.setValue(cus_phone2, forKey: "cus_phone2")
        requestDict.setValue(cus_address, forKey: "cus_address")
        requestDict.setValue(cus_lat, forKey: "cus_lat")
        requestDict.setValue(cus_long, forKey: "cus_long")
        requestDict.setValue(cus_image, forKey: "cus_image")
        requestDict.setValue(otp, forKey: "otp")
        requestDict.setValue(current_otp, forKey: "current_otp")
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:PROFILE_UPDATE_OTP as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    //Update the choice In Cart
    public func updateCartWithChoice(lang:String,cart_id:String,product_id:String,choice_id:[Int],special_request:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(cart_id, forKey: "cart_id")
        requestDict.setValue(product_id, forKey: "product_id")
        requestDict.setValue(choice_id, forKey: "choice_id")
        requestDict.setValue(special_request, forKey: "special_request")
        
        
        
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:ADD_CHOICE_TOCART as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func userLogout(lang:String,token:String,ios_device_id:String,type:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(lang, forKey: "lang")
        requestDict.setValue(token, forKey: "token")
        requestDict.setValue(ios_device_id, forKey: "ios_device_id")
        requestDict.setValue(ios_device_id, forKey: "type")
        
        guard let tokenStr = login_session.object(forKey: "user_token") as? String else {
            failure(NSError(domain: "anonymous", code: -1))
            return
        }
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCallWithToken(token:tokenStr as NSString,subURl:USER_LOGOUT as NSString, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    
}
