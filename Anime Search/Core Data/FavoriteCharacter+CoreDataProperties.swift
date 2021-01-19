//
//  FavoriteCharacter+CoreDataProperties.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/14.
//
//

import Foundation
import CoreData


extension FavoriteCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCharacter> {
        return NSFetchRequest<FavoriteCharacter>(entityName: "FavoriteCharacter")
    }

    @NSManaged public var identity: Float
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var isSaved: Bool

}

extension FavoriteCharacter : Identifiable {

}
