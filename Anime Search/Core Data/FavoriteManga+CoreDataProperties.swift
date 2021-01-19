//
//  FavoriteManga+CoreDataProperties.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/14.
//
//

import Foundation
import CoreData


extension FavoriteManga {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteManga> {
        return NSFetchRequest<FavoriteManga>(entityName: "FavoriteManga")
    }

    @NSManaged public var identity: Float
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var isSaved: Bool

}

extension FavoriteManga : Identifiable {

}
