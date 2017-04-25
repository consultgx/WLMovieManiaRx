//
//  MovieSearchResponse.swift
//  WLMovieMania
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//

import Foundation

struct MovieDBAPIService{
    
    var page:Int = 0
    var total_pages:Int = 0
    var total_results:Int = 0
    var results = [Movie]()
    var success:Bool = false

    init() {}
    
    
    init(_ dict:Dictionary<String,AnyObject>) {
        success = true
        page = dict["page"] as! Int
        total_pages = dict["total_pages"] as! Int
        total_results = dict["total_results"] as! Int
        let resultsDict = dict["results"] as! [Dictionary<String,AnyObject>]
        for val in resultsDict
        {
            results.append(Movie(val))
        }
    }
    
    
    static func searchRequest(_ txt:String, page:Int = 1, completion:@escaping (_ remoteData: () -> MovieDBAPIService)->()) {
        
        let constructedUrl = searchUrl + "&page=" + String(page) + "&query=" + txt
        let dataHandler = ServiceHandler(url: constructedUrl, httpMethod: HttpMethod.GET)
        dataHandler.fetch { (finalData) in
            do
            {
                var dict = Dictionary<String,AnyObject>()
                try dict = finalData() as Dictionary<String,AnyObject>
                completion{ MovieDBAPIService(dict)}
            }
            catch{
                completion{ MovieDBAPIService()}
                return
            }
        }
    }
    
}
