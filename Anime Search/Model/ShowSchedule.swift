//
//  ShowSchedule.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/24.
//

import Foundation

struct ShowSchedule:Codable{
    var sunday : [SundayProgram]?
    var monday : [MondayProgram]?
    var tuesday : [TuesdayProgram]?
    var wednesday : [WednesdayProgram]?
    var thursday : [ThursdayProgram]?
    var friday : [FridayProgram]?
    var saturday : [SaturdayProgram]?
}

struct SundayProgram:Codable{
    var title:String
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}

struct MondayProgram:Codable{
    var title:String
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}

struct TuesdayProgram:Codable{
    var title:String
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}

struct WednesdayProgram:Codable{
    var title:String
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}


struct ThursdayProgram:Codable{
    var title:String
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}

struct FridayProgram:Codable{
    var title:String
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}

struct SaturdayProgram:Codable{
    var title:String 
    var imageUrl:String

    enum CodingKeys :String,CodingKey{
        case title
        case imageUrl = "image_url"
    }
}
