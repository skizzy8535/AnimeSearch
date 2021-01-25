//
//  ShowACGInformation.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/21.
//

import Foundation


struct ShowACGInformation:Codable{
    var identity:Int?
    var imageUrl:String
    var trailerUrl:String?
    var title:String?
    var chapters:Int?
    var episodes:Int?
    var status:String?
    var score:Double?
    var rank:Int?
    var synopsis:String?
    var genres:[EachGenre]?

enum CodingKeys : String,CodingKey{
    case identity = "mal_id"
    case imageUrl = "image_url"
    case trailerUrl = "trailer_url"
    case title
    case chapters
    case episodes
    case status
    case score
    case rank
    case synopsis
    case genres
 }
}


struct EachGenre:Codable{
    var name:String
}



