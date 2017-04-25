//
//  Movie.swift
//  WLMovieMania
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//
//

import Foundation

struct Movie{
    
    var overview:String
    var poster_path:String
    var adult:Bool
    var id:Int
    var genre_ids:[Float]
    var original_title:String
    var original_language:String
    var title:String
    var backdrop_path:String
    var popularity:Float
    var vote_count:Float
    var video:Bool
    var vote_average:Float
    
    
    init(_ dict:Dictionary<String,AnyObject>) {
        overview = dict["overview"] as? String ?? ""
        poster_path = dict["poster_path"] as? String ?? ""
        adult = dict["adult"] as? Bool ?? false
        id = dict["id"] as? Int ?? 0
        original_title = dict["original_title"] as? String ?? ""
        original_language = dict["original_language"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        backdrop_path = dict["backdrop_path"] as? String ?? ""
        popularity = dict["popularity"] as? Float ?? 0.0
        vote_count = dict["vote_count"] as? Float ?? 0.0
        video = dict["video"] as? Bool ?? false
        vote_average = dict["vote_average"] as? Float ?? 0.0
        genre_ids = dict["genre_ids"] as? [Float] ?? [Float]()
    }
    
  

}
