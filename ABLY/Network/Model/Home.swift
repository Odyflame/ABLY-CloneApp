//
//  Home.swift
//  Network
//
//  Created by apple on 2021/06/18.
//

import Foundation

public struct HomeResult: Codable {
    public var banners: [BannerResult]
    public var goods: [GoodsResult]
}

public struct BannerResult: Codable {
    public var id: Int?
    public var image: String?
}

public struct GoodsResult: Codable {
    public var id: Int?
    public var name: String?
    public var image: String?
    public var isNew: Bool?
    public var sellCount: Int?
    public var actualPrice: Int?
    public var price: Int?
    
    enum CodingKeys : String, CodingKey{
        case id, name, image, price
        case isNew = "is_new"
        case sellCount = "sell_count"
        case actualPrice = "actual_price"
    }
}
