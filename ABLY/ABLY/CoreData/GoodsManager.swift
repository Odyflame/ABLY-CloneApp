//
//  GoodsManager.swift
//  ABLY
//
//  Created by apple on 2021/06/21.
//

import Foundation
import Network

public class GoodsManager {
    public static let shared = GoodsManager()
    
    var goods: [Goods]?
    
    private init() { }
    
    func insert(good: GoodsResult, completion: (() -> Void)? = nil) {
        CoreDataManager.sharedManager.performBackgroundTask { (context) in
            CoreDataManager.sharedManager.insert(goods: good, context: context)
            guard let completion = completion else {
                return
            }
            completion()
        }
    }
    
    public func fetch(
        completion: @escaping (([Goods]?) -> Void)
    ) {
        CoreDataManager.sharedManager.performBackgroundTask { (context) in
            guard let managedGroups = CoreDataManager.sharedManager.fetch(context: context) else {
                completion(nil)
                return
            }
            
            var goodsGroup = [Goods]()
            for managedGroup in managedGroups {
                goodsGroup.append(managedGroup)
            }
            
            self.goods = goodsGroup
            
            completion(goodsGroup)
        }
    }
    
    public func fetch(
        identifier: Int?,
        completion: @escaping (([Goods]?) -> Void)
    ) {
        CoreDataManager.sharedManager.performBackgroundTask { (context) in
            guard let managedGroups = CoreDataManager.sharedManager.fetch(predicate: identifier, context: context) else {
                completion(nil)
                return
            }
            
            var groups = [Goods]()
            for managedGroup in managedGroups {
                groups.append(managedGroup)
            }
            
            self.goods = groups
            completion(groups)
        }
    }
    
    public func fetch(
        id: Int?,
        completion: @escaping ((Goods?) -> Void)
    ) {
        CoreDataManager.sharedManager.performBackgroundTask { context in
            guard let managedGoods = CoreDataManager.sharedManager.get(predicate: id, context: context) else {
                completion(nil)
                return
            }
            completion(managedGoods)
        }
    }
    
    public func delete(good: GoodsResult, completion: (() -> Void)? = nil) {
        CoreDataManager.sharedManager.performBackgroundTask { (context) in
            guard let id = good.id else { return }
            CoreDataManager.sharedManager.delete(id: id, context: context)
            guard let completion = completion else {
                return
            }
            completion()
        }
    }
    
    public func convertGoodsToResult(good: Goods) -> GoodsResult {
        var newGoods = GoodsResult(
            id: Int(good.id),
            name: good.name,
            image: good.image,
            isNew: good.isNew,
            sellCount: Int(good.sellCount),
            actualPrice: Int(good.actualPrice),
            price: Int(good.price))
        
        return newGoods
    }
}

