//
//  FavouriteMovie+CoreDataProperties.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 8.08.2022.
//
//

import Foundation
import CoreData


extension FavouriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteMovie> {
        return NSFetchRequest<FavouriteMovie>(entityName: "FavouriteMovie")
    }

    @NSManaged public var movieId: Int32
    @NSManaged public var rating: Double
    @NSManaged public var date: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?

}

extension FavouriteMovie : Identifiable {

}
