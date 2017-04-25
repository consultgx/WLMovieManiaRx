//
//  ServiceHandler.swift
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//
//

import Foundation
import UIKit

class ServiceHandler: APIHandler, UrlRequestGenerator {
    
    var urlString:String = ""
    var httpMethod:String = ""
    var parsedData:Any?
    var body:[String:AnyObject] = [:]
    var headers:[String:AnyObject] = [:]
    
    var urlRequest:URLRequest?{
        // Defaults
        return aURLRequest()
    }
    var dataFromApi:Data?{
        didSet{
            guard let data = dataFromApi else {return}
            parsedData = ServiceHandler.parser(data)
        }
    }
    convenience init(url:String,httpMethod:String)
    {
        self.init()
        self.urlString = url
        self.httpMethod = httpMethod
    }
    
    func aURLRequest() -> URLRequest? {
        guard let request = toNSMutableURLRequest() else{ return nil }
        request.setValue(HttpHeaderValue.AppJson, forHTTPHeaderField: HttpHeader.ContentType)
        request.setValue(HttpHeaderValue.AppJson, forHTTPHeaderField: HttpHeader.Accept)
        request.setValue(HttpHeaderValue.EnUs, forHTTPHeaderField: HttpHeader.ContentLanguage)
        if body.count > 0
        {
            request.httpBody = encodedBodyForParams(body).data(using: String.Encoding.utf8)
        }
        return request as URLRequest
    }
    
    class func parser(_ data:Data) -> Dictionary<String,AnyObject>
    {
        guard let json = (try? JSONSerialization.jsonObject(
            with: data, options: JSONSerialization.ReadingOptions())) as? Dictionary<String,AnyObject> else{ return Dictionary<String,AnyObject>()}
        
        return json
    }
    
    func fetch(_ completion:@escaping (_ finalData: () throws -> Dictionary<String,AnyObject>) -> ())
    {
        Network.sharedInstance().perform(self) { (remoteData) in
            do{
                self.dataFromApi = try remoteData()
                
                guard let fdata = self.parsedData as? Dictionary<String,AnyObject> else{
                    throw ApiError.badData
                }
                completion{return fdata}
            } catch {
                completion{throw error}
            }
        }
    }
}
