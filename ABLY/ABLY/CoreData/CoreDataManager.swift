//
//  GoodsCoreDataManager.swift
//  ABLY
//
//  Created by apple on 2021/06/20.
//

import Foundation
import CoreData
import Network

class CoreDataManager: NSObject {
    static let sharedManager = CoreDataManager()
    
    enum Constant {
        static let modelName = "Goods"
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.modelName)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func performBackgroundTask(_ completion: @escaping (NSManagedObjectContext) -> Void) {
        let context = backgroundContext
        context.perform {
            completion(context)
        }
    }
    
    func saveContext(context backgroundContext: NSManagedObjectContext) {
        let context = backgroundContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func insert(goods: GoodsResult, context: NSManagedObjectContext) {
        
        var myGoods = Goods(context: context)
        
        if let id = goods.id {
            myGoods.id = Int32(id)
        }
        if let isNew = goods.isNew {
            myGoods.isNew = isNew
        }
        if let image = goods.image {
            myGoods.image = image
        }
        if let name = goods.name {
            myGoods.name = name
        }
        if let price = goods.price {
            myGoods.price = Int32(price)
        }
        if let sellCount = goods.sellCount {
            myGoods.sellCount = Int32(sellCount)
        }
        if let actualPrice = goods.actualPrice {
            myGoods.actualPrice = Int32(actualPrice)
        }
        
        saveContext(context: context)
    }
    
    func delete(id: Int, context: NSManagedObjectContext) {
        guard let deleteGroups = fetch(predicate: id, context: context) else {
            return
        }
        
        for deleteGroup in deleteGroups {
            context.delete(deleteGroup)
        }
        saveContext(context: context)
    }
    
    func fetch(predicate id: Int?, context: NSManagedObjectContext) -> [Goods]? {
        let fetchRequest =
            NSFetchRequest<Goods>(entityName: Constant.modelName)
        
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.fetchLimit = 1
        }
        
        guard let groupList = try? context.fetch(fetchRequest),
              groupList.isEmpty == false else {
            return nil
        }
        return groupList
    }
    
    func fetch(
        context: NSManagedObjectContext
    ) -> [Goods]? {
        let fetchRequest =
            NSFetchRequest<Goods>(entityName: Constant.modelName)
        
        guard let groupList = try? context.fetch(fetchRequest),
              groupList.isEmpty == false else {
            return nil
        }
        return groupList
    }
    
    func get(predicate id: Int?, context: NSManagedObjectContext) -> Goods? {
        let fetchRequest = NSFetchRequest<Goods>(entityName: Constant.modelName)
        
        if let id = id {
            let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
        }
        
        guard let goodsList = try? context.fetch(fetchRequest),
              goodsList.isEmpty == false else {
            return nil
        }
        return goodsList.first
    }
}
