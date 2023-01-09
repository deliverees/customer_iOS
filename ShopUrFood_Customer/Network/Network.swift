
//  Network.swift
//  ePickMeUP
//
//  Created by POFI TECHNOLOGIES on 16/07/18.
//  Copyright © 2018 POFI TECHNOLOGIES. All rights reserved.

/* ***************
 Usage:  HTTP request and response are handles in this file.
 
 ***************** */

import Foundation
import SystemConfiguration
import UIKit

protocol HTTP_POST_STRING_REQUEST_PROTOCOL {
    func httpPostRequest(APIKEY:String,requestURL: String,responseDict: NSDictionary,errorDict: String)
}

protocol HTTP_GET_STRING_REQUEST_PROTOCOL {
    func httpGetRequest(APIKEY:String,requestURL: String,responseDict: NSDictionary,errorStr: String)
}

protocol HTTP_GET_JSON_REQUEST_PROTOCOL {
    func GetRequest(withParameterDict: NSDictionary , serviceURL: String , APIKEY: String)
}

class Network {
    
    //MARK:- SharedInstance.
    
    static var shared = Network()
    
    //MARK:- Variables.
    var HTTP_POST_STRING_REQUEST_DELEGATE : HTTP_POST_STRING_REQUEST_PROTOCOL?
    var HTTP_GET_STRING_REQUEST_DELEGATE: HTTP_GET_STRING_REQUEST_PROTOCOL?
    var HTTP_GET_JSON_REQUEST_DELEGATE: HTTP_GET_JSON_REQUEST_PROTOCOL?
    
    //MARK:- Post request with parameter String.
    func POSTRequest(withParameterString: String , serviceURL: String , APIKEY: String)
    {
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbW9iaWxlYXBwc2hvcHVyZm9vZC5teXRheGlzb2Z0LmNvbS9hcGkvdXNlcl9sb2dpbiIsImlhdCI6MTU0OTYxMDY1MSwiZXhwIjoxNTQ5NjE0MjUxLCJuYmYiOjE1NDk2MTA2NTEsImp0aSI6IlhQc1FIWGtDbnBmNXdyQU0iLCJzdWIiOjEwLCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.jdy5Jk2ty9VvGIj9RUnvwFjfZtqIAsHwNhBJmGufYkw"
        var RESPONSE_ERROR = String()
        var RESPONSE_DATA = NSDictionary()
        let Url = String(format: serviceURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        let postString = withParameterString
     //   print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
       
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //request.setValue("application/json", forHTTPHeaderField: "content-type")
        

        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if let response = response {
                print(response)
            }
            if let resdata = data {
                do {
                    
                  //  print(response)
                  
                    let json =  try JSONSerialization.jsonObject(with: resdata, options: .mutableContainers) as? NSDictionary
                    
                       if let parseJSON = json {
                        
                          //print(json)
                        if parseJSON.object(forKey: "status") as? NSInteger == 1 {
                            if error != nil {
                               RESPONSE_ERROR = (error?.localizedDescription)!
                            }
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                            }
                        } else {
                            DispatchQueue.main.async {
                                 RESPONSE_DATA = parseJSON
                                self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            RESPONSE_ERROR = "No Data"
                            self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                        }
                    }
                }catch {
                     DispatchQueue.main.async {
                    RESPONSE_ERROR = "Check your input datas"
                    self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                }
                }
            } else {
                DispatchQueue.main.async {
                    RESPONSE_ERROR = (error?.localizedDescription)!
                    self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                }
            }
        })
        task.resume()
    }
    
    //Post request with parameter dict.
    func POSTRequest(withParameterDict: NSDictionary , serviceURL: String , APIKEY: String)
    {
        var RESPONSE_ERROR = String()
        var RESPONSE_DATA = NSDictionary()
        let Url = String(format: serviceURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: withParameterDict, options: []) else {
            return
        }
        print(withParameterDict)
        request.httpBody = httpBody
        //request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if let response = response {
                print(response)
            }
            if let resdata = data {
                do {
                    let json =  try JSONSerialization.jsonObject(with: resdata, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        if parseJSON.object(forKey: "status") as! NSInteger == 1 {
                            if error != nil {
                                RESPONSE_ERROR = (error?.localizedDescription)!
                            }
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                            }
                        } else {
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            RESPONSE_ERROR = "No Data"
                            self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                        }
                    }
                } catch {
                    RESPONSE_ERROR = "Check your input datas"
                    self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                }
            } else {
                DispatchQueue.main.async {
                    RESPONSE_ERROR = (error?.localizedDescription)!
                    self.HTTP_POST_STRING_REQUEST_DELEGATE?.httpPostRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorDict: RESPONSE_ERROR)
                }
            }
        })
        task.resume()
    }
   
    //MARK:- GetRequest With Parameter.
    
    func GetRequest(withParameterString: String , serviceURL: String , APIKEY: String)
    {
        var RESPONSE_ERROR = String()
        var RESPONSE_DATA = NSDictionary()
        let Url = String(format: serviceURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        let postString = withParameterString
        print(postString)
       
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if let response = response {
                print(response)
            }
            if let resdata = data {
                do {
                    let json =  try JSONSerialization.jsonObject(with: resdata, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        if parseJSON.object(forKey: "status") as! NSInteger == 1 {
                            if error != nil {
                                RESPONSE_ERROR = (error?.localizedDescription)!
                            }
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                            }
                        } else {
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            RESPONSE_ERROR = "No Data"
                            self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                        }
                    }
                }catch {
                    RESPONSE_ERROR = "Check your input datas"
                    self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                }
            } else {
                DispatchQueue.main.async {
                    RESPONSE_ERROR = (error?.localizedDescription)!
                    self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                }
            }
        })
        task.resume()
    }
    
    
    func GetRequest(withParameterDict: NSDictionary , serviceURL: String , APIKEY: String)
    {
        var RESPONSE_ERROR = String()
        var RESPONSE_DATA = NSDictionary()
        let Url = String(format: serviceURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: withParameterDict, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if let response = response {
                print(response)
            }
            if let resdata = data {
                do {
                    let json =  try JSONSerialization.jsonObject(with: resdata, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        if parseJSON.object(forKey: "status") as! NSInteger == 1 {
                            if error != nil {
                                RESPONSE_ERROR = (error?.localizedDescription)!
                            }
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                            }
                        } else {
                            DispatchQueue.main.async {
                                RESPONSE_DATA = parseJSON
                                self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            RESPONSE_ERROR = "No Data"
                            self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                        }
                    }
                }catch {
                    RESPONSE_ERROR = "Check your input datas"
                    self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                }
            } else {
                DispatchQueue.main.async {
                    RESPONSE_ERROR = (error?.localizedDescription)!
                    self.HTTP_GET_STRING_REQUEST_DELEGATE?.httpGetRequest(APIKEY: APIKEY, requestURL: serviceURL, responseDict: RESPONSE_DATA, errorStr: RESPONSE_ERROR)
                }
            }
        })
        task.resume()
    }
    
    
    
}
