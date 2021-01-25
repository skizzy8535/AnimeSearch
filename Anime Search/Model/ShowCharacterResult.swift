//
//  ShowCharacterResult.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//

import Foundation

struct ShowCharacterResult:Codable{
    var identity:Int
    var name:String
    var about:String
    var imageUrl:String
    var animeography:[AnimeCharacter]
    
    
    enum CodingKeys:String,CodingKey{
        case identity = "mal_id"
        case name
        case about
        case imageUrl = "image_url"
        case animeography
    }
}


struct AnimeCharacter:Codable{
    var name:String
    var imageUrl:String
    
    enum CodingKeys:String,CodingKey{
        case name
        case imageUrl = "image_url"
    }
}

