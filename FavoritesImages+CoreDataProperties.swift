//
//  FavoritesImages+CoreDataProperties.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 11/12/23.
//
//

import Foundation
import CoreData


extension FavoritesImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesImages> {
        return NSFetchRequest<FavoritesImages>(entityName: "FavoritesImages")
    }

    @NSManaged public var image_id: Int64
    @NSManaged public var animal_name: String?
    @NSManaged public var image_url: String?
    @NSManaged public var width: Int64
    @NSManaged public var height: Int64
    
}

extension FavoritesImages : Identifiable {

}
