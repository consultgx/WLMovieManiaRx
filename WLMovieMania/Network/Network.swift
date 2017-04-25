//
//  Network.swift
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//
//

import Foundation
import SystemConfiguration

public class Network:NSObject, URLSessionDelegate{
    
    var sessionConfig = URLSessionConfiguration.ephemeral
    
    var sessionDelegate:URLSessionDelegate?
    
    lazy var session: Foundation.URLSession = {
        var delegate:URLSessionDelegate = self as URLSessionDelegate
        if self.sessionDelegate != nil{
            delegate = self.sessionDelegate!
        }
        let s = Foundation.URLSession(configuration: self.sessionConfig, delegate: delegate,
                                      delegateQueue: nil )
        return s
    }()
    
    override init() {
        super.init()
    }
    class var instance:Network{
        struct Singleton{
            static let instance = Network()
        }
        return Singleton.instance
    }
    
    class func sharedInstance(
        _ sessionConfig:URLSessionConfiguration? = nil,
        sessionDelegate:URLSessionDelegate? = nil) -> Network {
        
        instance.sessionConfig.timeoutIntervalForRequest = 500
        instance.sessionConfig.timeoutIntervalForResource = 500
        
        if let sessionConfig = sessionConfig{
            instance.sessionConfig = sessionConfig
        }
        
        if let sessionDelegate = sessionDelegate{
            instance.sessionDelegate = sessionDelegate
        }
        
        return instance
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (@escaping (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void))
    {
        completionHandler(.performDefaultHandling, nil)
    }
    
    public func perform(
        _ handler:APIHandler,
        completion:@escaping (_ remoteData: () throws -> Data)->())
    {
        guard let request = handler.urlRequest else{
            completion{throw ApiError.badURL}
            return
        }
        
        guard let host = request.url?.host, isHostReachable(host) else{
            completion{throw ApiError.noInternet}
            return
        }

        session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                completion{throw ApiError.unknown(error: "\(String(describing: error))")}
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                completion{throw ApiError.incorrectResponseType(response:"\(String(describing: response))")}
                return
            }
            
            guard httpResponse.statusCode == 200 else{
                completion{throw ApiError.badHttpResponse(code: httpResponse.statusCode, description: "\(httpResponse)")}
                return
            }
            
            guard let data = data else{
                completion{ throw ApiError.badData }
                return
            }
            
            completion{ return data }
            
            }.resume()
    }
}
