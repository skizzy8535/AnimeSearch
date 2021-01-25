//
//  ShowPersonResult.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//
import Foundation

 struct ShowPersonResult:Codable{
     var identity:Int
     var imageUrl:String?
     var name:String?
     var about:String?
     var actingRoles:[ActingRoles]?

 enum CodingKeys : String,CodingKey{
     case identity = "mal_id"
     case imageUrl = "image_url"
     case name
     case about
     case actingRoles = "voice_acting_roles"
   }
 }


 struct ActingRoles:Codable{
    var anime : AnimeName?
    var character: CharacterName?
 }


struct AnimeName:Codable{
    var imageUrl:String?
    var name:String?
    
    enum CodingKeys:String,CodingKey{
        case imageUrl = "image_url"
        case name
    }
}


struct CharacterName:Codable{
    var imageUrl:String?
    var name:String?
    
    enum CodingKeys:String,CodingKey{
        case imageUrl = "image_url"
        case name
    }
}
