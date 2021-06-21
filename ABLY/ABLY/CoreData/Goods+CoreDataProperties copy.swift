//
//  Goods+CoreDataProperties.swift
//  
//
//  Created by apple on 2021/06/20.
//
//

import Foundation
import CoreData


extension Goods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goods> {
        return NSFetchRequest<Goods>(entityName: "Goods")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var actualPrice: Int32
    @NSManaged public var price: Int32
    @NSManaged public var isNew: Bool
    @NSManaged public var sellCount: Int32

}
