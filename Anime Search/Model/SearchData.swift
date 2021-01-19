//
//  SearchData.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/5.
//

import Foundation


struct  SearchData:Codable{
  var results : [SearchResults]?
}


struct SearchResults:Codable{
  var identity: Int
  var url : String
  var imageURL:String
  var title:String?
  var name :String?
  var type :String?
  var score:Double?
  var startDate: String?
  var endDate: String?
  var rated:String?


  enum CodingKeys : String,CodingKey{
      case identity = "mal_id"
      case url
      case imageURL = "image_url"
      case title
      case name
      case type
      case score
      case startDate = "start_date"
      case endDate = "end_date"
      case rated
   }
}
