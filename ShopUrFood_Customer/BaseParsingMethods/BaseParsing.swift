//
//  BaseParsing.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 08/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Alamofire

public typealias Parameters = [String: Any]


class BaseParsing: NSObject {
    var blockResponse = Bool()
    
    public func ParsingFunctionCallQueryParams(subURl: NSString, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let finalURL = URL(string: BASEURL+(subURl as String))
        
        print("BASE URL : \(BASEURL+(subURl as String))")
        print("PARAMETER : \(params!)")
            //webservice call
        Alamofire.request(finalURL!, method:.post, parameters: params!, encoding: URLEncoding.queryString, headers: ["Content-Type": "application/json"]).responseJSON { response in
                //sucesss block
            if let JSON = response.result.value as? NSDictionary {
                success(JSON)
                return
            }
            let error = response.result.error
            failure(error)
        }
    }
    
    // POST METHOD
    public func ParsingFunctionCall(subURl: NSString, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: BASEURL+(subURl as String))
        
        print("BASE URL : \(BASEURL+(subURl as String))")
        print("PARAMETER : \(params!)")
            //webservice call
        Alamofire.request(finalURL!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: ["Content-Type": "application/json"]).responseJSON { response in
                //sucesss block
            if let JSON = response.result.value as? NSDictionary {
                success(JSON)
                return
            }
            let error = response.result.error
            failure(error)
        }
    }
    
    // POST METHOD
    public func testFunctionCall(subURl: NSString, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: "https://demo.homestaydnn.com/json/mobile_login")
        
       
        //webservice call
        Alamofire.request(finalURL!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            //sucesss block
            let JSON = response.result.value as? NSDictionary
            if((JSON) != nil)
            {
                success(JSON!)
            }
        }
    }
    
    public func ParsingFunctionCallWithToken(token: NSString,subURl: NSString, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: BASEURL_CUSTOMER+(subURl as String))
        print("BASE URL : \(BASEURL_CUSTOMER+(subURl as String))")
        print("PARAMETER : \(params!)")
        //webservice call
        //let BearerStr = "Bearer " + token
        //let PostHeaders : HTTPHeaders = [
            //"Authorization" : BearerStr]
        
        if login_session.value(forKey: "user_token") == nil
        {
            let postheaders : HTTPHeaders = ["Content-Type":"application/json"]
            print(postheaders)
            let url = URL(string: BASEURL_CUSTOMER+("v1_"+(subURl as String)))
            Alamofire.request(url!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: postheaders).responseJSON { response in
                //sucesss block
                switch response.result {
                case .success:
                    let JSON = response.result.value as? NSDictionary
                    if((JSON) != nil)
                    {
                        success(JSON!)
                    }
                    break
                case .failure(let error):
                    //handler(nil)
                    print(error)
                    failure(error)
                    break
                }
            }
        }
        else
        {
        
        let postheaders : HTTPHeaders = ["Authorization" : "Bearer " + (token as String),
                                         "Content-Type": "application/json"]
        print(postheaders)

        Alamofire.request(finalURL!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: postheaders).responseJSON { response in
            //sucesss block
            switch response.result {
            case .success:
                let JSON = response.result.value as? NSDictionary
                if((JSON) != nil)
                {
                    success(JSON!)
                }
                break
            case .failure(let error):
                //handler(nil)
                print(error)
                break
            }
            }
            
        }
    }
    
    public func RawParsingFunctionCallWithToken(token: NSString,subURl: NSString, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: BASEURL_CUSTOMER+(subURl as String))
        print("BASE URL : \(BASEURL_CUSTOMER+(subURl as String))")
        print("PARAMETER : \(params!)")
        //webservice call
        //let BearerStr = "Bearer " + token
        //let PostHeaders : HTTPHeaders = [
        //"Authorization" : BearerStr]
        let postheaders : HTTPHeaders = ["Authorization" : "Bearer " + (token as String),
                                         "Content-Type": "application/json"]
        print(postheaders)
    
        
        Alamofire.request(finalURL!, method: .post, parameters: params!, encoding: URLEncoding.default, headers: postheaders).responseJSON{ response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(data)
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
