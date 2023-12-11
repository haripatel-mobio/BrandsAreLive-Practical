//
//  Animals+CoreDataProperties.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 09/12/23.
//
//

import Foundation
import CoreData


extension Animals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Animals> {
        return NSFetchRequest<Animals>(entityName: "Animals")
    }

    @NSManaged public var name: String?
    @NSManaged public var locations: String?
    @NSManaged public var diet: String?
    @NSManaged public var is_favorite: Bool

}

extension Animals : Identifiable {

}
