//
//  TopAnime.swift
//  Anime Search
//
//  Created by 林祐辰 on 2020/12/30.
//

import Foundation

struct TopAnime: Codable {
  let top: [AnimeData]?
}

struct AnimeData: Codable{
  let identity: Int
  let rank: Int
  let title: String?
  let url: String?
  let imageUrl: String?
  let type: String?
  let startDate: String?
  let endDate: String?
  let score:Double
  
 enum CodingKeys: String, CodingKey {
    case identity = "mal_id"
    case rank
    case title
    case url
    case imageUrl = "image_url"
    case type
    case startDate = "start_date"
    case endDate = "end_date"
    case score
  }
}
