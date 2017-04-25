//
//  NetworkProtocols.swift
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//
//

import Foundation
import SystemConfiguration

public func isHostReachable(_ host:String) -> Bool
{
    let reachabilityRef =
        SCNetworkReachabilityCreateWithName(nil,
                                            (host as NSString).utf8String!)
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachabilityRef!, &flags)
    
    let reachable: Bool = (flags.rawValue & SCNetworkReachabilityFlags.reachable.rawValue) != 0
    
    //print(host, "is", (reachable ? "reachable" : "NOT reachable"))
    return reachable
}

public protocol APIHandler {
    var urlRequest:URLRequest?{get}
    var dataFromApi:Data?{get set}
    var parsedData:Any?{get}
}

public protocol UrlRequestGenerator{
    var urlString:String {get}
    var httpMethod:String {get}
    
}

public enum ApiError: Error {
    case badURL
    case timeout
    case invalidSession
    case noInternet
    case incorrectResponseType(response:String)
    case badHttpResponse(code:Int, description:String)
    case parseError
    case badData
    case unknown(error:String)
}

public extension UrlRequestGenerator{
    
    func toNSMutableURLRequest() -> NSMutableURLRequest?{
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return nil }
        
        guard let url = URL(string: encodedString) else{ return nil }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod
        
        return request
    }
    
    func encodedBodyForParams(_ params:[String:AnyObject]) -> String{
        var paramsString = ""
        do{
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            paramsString = String(data:json, encoding: String.Encoding.utf8) ?? ""
        } catch {
            //      print("Error converting params to JSON")
        }
        
        return paramsString
    }
}


//////////////////////////////////////////////////////////////////


public struct HttpMethod {
    public static let GET = "GET"
    public static let POST = "POST"
}

public struct HttpHeader {
    public static let CacheControl = "Cache-Control"
    public static let ContentType = "Content-Type"
    public static let ContentLength = "Content-Length"
    public static let ContentLanguage = "Content-Language"
    public static let Accept = "Accept"
}

public struct HttpHeaderValue {
    public static let NoCache = "no-cache"
    public static let AppJson = "application/json"
    public static let EnUs = "en-US"
}
