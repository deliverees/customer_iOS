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
    
    // POST METHOD
    public func ParsingFunctionCall(subURl: NSString, params: Parameters!, encoding: ParameterEncoding = JSONEncoding.default, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: BASEURL+(subURl as String))
        let prunedParameters = prunedParameters(params: params)
        print("BASE URL : \(finalURL!)")
        print("PARAMETER : \(params!)")
        print("Pruned PARAMETERs : \(prunedParameters!)")
        //webservice call
        AF.request(finalURL!, method:.post, parameters: prunedParameters, encoding: encoding, headers: ["Content-Type": "application/json"]).responseJSON { response in
            print(response.request?.cURL(pretty: true) ?? "")
            if let error = response.error {
                failure(error)
                return
            }
            
            switch response.result {
            case .success(let value):
                if let JSON = value as? NSDictionary {
                    success(JSON)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    // POST METHOD
    public func testFunctionCall(subURl: NSString, params: Parameters!, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: "https://demo.homestaydnn.com/json/mobile_login")
        
        
        //webservice call
        AF.request(finalURL!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            //sucesss block
            if let error = response.error {
                failure(error)
                return
            }
            
            switch response.result {
            case .success(let value):
                if let JSON = value as? NSDictionary {
                    success(JSON)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    public func ParsingFunctionCallWithToken(token: NSString,subURl: NSString, params: Parameters!, encoding: ParameterEncoding = JSONEncoding.default, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: BASEURL_CUSTOMER+(subURl as String))
        let prunedParameters = prunedParameters(params: params)
        print("BASE URL : \(finalURL!)")
        print("PARAMETER : \(params!)")
        print("Pruned PARAMETERs : \(prunedParameters!)")
        //webservice call
        //let BearerStr = "Bearer " + token
        //let PostHeaders : HTTPHeaders = [
        //"Authorization" : BearerStr]
        
        if login_session.value(forKey: "user_token") == nil
        {
            let postheaders : HTTPHeaders = ["Content-Type":"application/json"]
            print(postheaders)
            let url = URL(string: BASEURL_CUSTOMER+("v1_"+(subURl as String)))
            AF.request(url!, method:.post, parameters: prunedParameters, encoding: encoding, headers: postheaders).responseJSON { response in
                print(response.request?.cURL(pretty: true) ?? "")
                //sucesss block
                if let error = response.error {
                    failure(error)
                    return
                }
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? NSDictionary {
                        success(JSON)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
        }
        else
        {
            
            let postheaders : HTTPHeaders = ["Authorization" : "Bearer " + (token as String),
                                             "Content-Type": "application/json"]
            print(postheaders)
            
            AF.request(finalURL!, method:.post, parameters: prunedParameters, encoding: encoding, headers: postheaders).responseJSON { response in
                //sucesss block
                print(response.request?.cURL(pretty: true) ?? "")
                if let error = response.error {
                    failure(error)
                    return
                }
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? NSDictionary {
                        success(JSON)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
            
        }
    }
    
    public func RawParsingFunctionCallWithToken(token: NSString,subURl: NSString, params: Parameters!, encoding: ParameterEncoding = JSONEncoding.default, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let finalURL = URL(string: BASEURL_CUSTOMER+(subURl as String))
        let prunedParameters = prunedParameters(params: params)
        print("BASE URL : \(finalURL!)")
        print("PARAMETER : \(params!)")
        print("Pruned PARAMETERs : \(prunedParameters!)")
        //webservice call
        //let BearerStr = "Bearer " + token
        //let PostHeaders : HTTPHeaders = [
        //"Authorization" : BearerStr]
        let postheaders : HTTPHeaders = ["Authorization" : "Bearer " + (token as String),
                                         "Content-Type": "application/json"]
        print(postheaders)
        
        
        AF.request(finalURL!, method: .post, parameters: prunedParameters, encoding: encoding, headers: postheaders).responseJSON{ response in
            print(response.request?.cURL(pretty: true) ?? "")
            if let error = response.error {
                failure(error)
                return
            }
            
            switch response.result {
            case .success(let value):
                if let JSON = value as? NSDictionary {
                    success(JSON)
                }
            case .failure(let error):
                failure(error)
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
    
    private func prunedParameters(params: Parameters?) -> Parameters? {
        params?.compactMapValues({ value in
            if (value as? String)?.isEmpty ?? false {
                return nil
            }
            if (value as? [Any])?.isEmpty ?? false {
                return nil
            }
            return value
        })
    }
}

private extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}
