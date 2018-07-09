//
//  ApiCallSwift.swift
//  ApiCallTestProject
//
//  Created by Issa Al Zayed on 9/7/16.
//  Copyright © 2016 ITX. All rights reserved.
//

import UIKit
import AVFoundation
import SystemConfiguration

typealias ComplitionBlock=(String, AnyObject, Int,NSData?, NSError?) -> Void

class ApiCallSwift: NSObject, URLSessionDelegate, URLSessionTaskDelegate
{
    let RechabilityInstance:Reachability! = Reachability()
    let delegate = AppDelegate.getDelegate()
    
    func getResponseForURL(builtURL:NSString,JsonToPost jsonString:NSString,isAuthenticationRequired authrequired:Bool,method:NSString,errorTitle:NSString,optionalValue:String,AndCompletionHandler completionHandler:@escaping ComplitionBlock){
        var MainResponse:NSDictionary=NSDictionary()
        let _block:ComplitionBlock=completionHandler
        //If internet available
        if self.isInternetAvailable()==true{
            //If API reachable
            if self.isAPIReachable()==true{
                let url:NSURL=NSURL(string: builtURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!
                //URL Session config
                let defaultConfigObject:URLSessionConfiguration = URLSessionConfiguration.default
                defaultConfigObject.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                //URL Session Headers
                let sessionHeaders:NSMutableDictionary=NSMutableDictionary()
                sessionHeaders.setValue("application/x-www-form-urlencoded",forKey:"Content-Type")

                if authrequired {
                    if(method.uppercased=="GET"){
                        sessionHeaders.setValue(Constants.BagJourneyAPIKeyhistory,forKey:"api_key")
                    }
                    else if(method.uppercased=="POST"){
                        if let BagJourneyAPIKeytracking=UserDefaultsManager().getLoginResponse()["api_key"]{
                            sessionHeaders.setValue(BagJourneyAPIKeytracking,forKey:"api_key")
                        }
                    }
                }
                
                if optionalValue != "" {
                    if let BagJourneyAPIKey=UserDefaultsManager().getLoginResponse()["api_key"]{
                        sessionHeaders.setValue(BagJourneyAPIKey,forKey:"api_key")
                    }
                }
                
                //Timeout value
                let timeOut:TimeInterval=60
                //URL Session config
                defaultConfigObject.httpAdditionalHeaders=sessionHeaders as [NSObject : AnyObject]
                defaultConfigObject.allowsCellularAccess=true
                defaultConfigObject.timeoutIntervalForRequest=timeOut
                defaultConfigObject.timeoutIntervalForResource=timeOut
                //URL Session
                let defaultSession = URLSession(configuration: defaultConfigObject,delegate: self,delegateQueue:OperationQueue.main)
                //If no JSON to post
                if(jsonString==""){
                    //If method of type GET
                    if(method.uppercased=="GET"){
                        let dataTask = defaultSession.dataTask(with: url as URL) {
                            (Rootdata: Data?, Rootresponse: URLResponse?, error: Error?) -> Void in
                            if (Rootdata != nil || Rootresponse != nil){
                                var data:NSData=Rootdata! as NSData
                                let response:URLResponse=Rootresponse!
                                let statusCode = response as! HTTPURLResponse
                                if error == nil {
                                    let stringData = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
                                    if stringData!.range(of: "callback(").location != NSNotFound {
                                        let jsonData = stringData!.replacingOccurrences(of: "callback(", with: "")
                                        data=jsonData.data(using: String.Encoding.utf8)! as NSData
                                    }
                                    do {
                                        try MainResponse = JSONSerialization.jsonObject(with: data as Data,options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                    }
                                    catch{print("response Error")}
                                    _block(optionalValue as String, MainResponse, statusCode.statusCode, data, error as NSError?)
                                }else{
                                    _block(optionalValue as String, response, statusCode.statusCode, data, error! as NSError?)
                                }
                            }else{
                                print("timeOut")
                                _block(optionalValue as String,MainResponse,1234567890, nil, error! as NSError?)
                            }
                        }
                        dataTask.resume()
                    }else{
                        let request = NSMutableURLRequest(url: url as URL)
                        request.httpBody = jsonString.data(using: String.Encoding.utf8.rawValue)
                        request.httpMethod = method as String
                        let dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data,Rootresponse, error) in
                            if (Rootresponse != nil){
                                let statusCode = Rootresponse as! HTTPURLResponse
                                if error == nil {
                                    do {
                                        try MainResponse = JSONSerialization.jsonObject(with: data!,options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                    }
                                    catch{print("response Error")}
                                    _block(builtURL as String, MainResponse, statusCode.statusCode, data! as NSData?, error! as NSError?)
                                }else{
                                    _block(builtURL as String, MainResponse, statusCode.statusCode, data! as NSData?, error! as NSError?)
                                }
                            }else{
                                _block(builtURL as String, MainResponse,0, NSData(), error! as NSError?)
                            }
                        })
                        dataTask.resume()
                    }
                }else{
                    let request = NSMutableURLRequest(url:url as URL)
                    
                    request.httpBody = jsonString.data(using: String.Encoding.utf8.rawValue)
                    request.httpMethod = method as String
                    
                    
                    
                    let dataTask = defaultSession.dataTask(with: request as URLRequest) {
                        (data, response, error) -> Void in
                        if (response != nil){
                            let statusCode = response as! HTTPURLResponse
                            if error == nil {
                                do {
                                    try MainResponse = JSONSerialization.jsonObject(with: data! as Data,options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                }
                                catch{print("response Error")}
                                _block(builtURL as String, MainResponse, statusCode.statusCode, data as NSData?, error as NSError?)
                            }else{
                                _block(builtURL as String, response!, statusCode.statusCode, data as NSData?, error! as NSError?)
                            }
                        }else{
                            _block(builtURL as String, MainResponse,0, nil, nil)
                        }
                    }
                    dataTask.resume()
                }
            }else{
                _block(builtURL as String,MainResponse,-1,nil,nil)
            }
        }else{
            _block(builtURL as String, MainResponse,-1,nil,nil)
        }
    }
    
    func GetResponseForLogin(JsonToPost:String,AndCompletionHandler completionHandler:@escaping ComplitionBlock) {
        
        let URL:NSURL=NSURL(string:(Constants.BagJourneyHost + Constants.LogInEndPoint).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!
        let _block:ComplitionBlock=completionHandler
        let defaultConfigObject:URLSessionConfiguration = URLSessionConfiguration.default
        let sessionHeaders:NSMutableDictionary=NSMutableDictionary()
        let timeOut:TimeInterval=60
        let request = NSMutableURLRequest(url: URL as URL)
        
        var MainResponse:NSDictionary=NSDictionary()
        
        if isInternetAvailable() && isAPIReachable(){
            
            defaultConfigObject.httpAdditionalHeaders=sessionHeaders as [NSObject : AnyObject]
            defaultConfigObject.allowsCellularAccess=true
            defaultConfigObject.timeoutIntervalForRequest=timeOut
            defaultConfigObject.timeoutIntervalForResource=timeOut
            defaultConfigObject.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            let defaultSession = URLSession(configuration: defaultConfigObject,delegate: self,delegateQueue:OperationQueue.main)
            
            request.httpBody = JsonToPost.data(using: String.Encoding.utf8)
            request.httpMethod = "POST"
            
            sessionHeaders.setValue("application/x-www-form-urlencoded",forKey:"Content-Type")
            
            let dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data,Rootresponse, error) in
                if (Rootresponse != nil){
                    let statusCode = Rootresponse as! HTTPURLResponse
                    if error == nil {
                        do {
                            try MainResponse = JSONSerialization.jsonObject(with: data!,options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        }
                        catch{print("response Error")}
                        _block("url", MainResponse, statusCode.statusCode, data! as NSData?, error! as NSError?)
                    }else{
                        _block("url", MainResponse, statusCode.statusCode, data! as NSData?, error! as NSError?)
                    }
                }else{
                    _block("url", MainResponse,0, NSData(), error! as NSError?)
                }
            })
            dataTask.resume()
        }else{
            _block("url",NSDictionary(),0,NSData(),NSError())
        }
    }
    
    func isInternetAvailable() -> Bool{
        return RechabilityInstance.isReachable
    }
    
    func isAPIReachable()->Bool{
        var success = false
        let host_name = Constants.BagJourneyHost.cString(using: String.Encoding.ascii)
        let reachability = SCNetworkReachabilityCreateWithName(nil,host_name!)
        var flags = SCNetworkReachabilityFlags()
        success = SCNetworkReachabilityGetFlags(reachability!, &flags)
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let isAPIReachable = success && isReachable && !needsConnection
        return isAPIReachable
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential.init(trust:challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
}
