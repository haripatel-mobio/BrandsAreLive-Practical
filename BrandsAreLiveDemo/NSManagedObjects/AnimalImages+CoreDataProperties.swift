//
//  AnimalImages+CoreDataProperties.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 09/12/23.
//
//

import Foundation
import CoreData


extension AnimalImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnimalImages> {
        return NSFetchRequest<AnimalImages>(entityName: "AnimalImages")
    }

    @NSManaged public var animal_image: String?

}

extension AnimalImages : Identifiable {

}
