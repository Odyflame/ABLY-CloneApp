//
//  HomeService.swift
//  Network
//
//  Created by apple on 2021/06/18.
//

import Foundation
import Moya

enum HomeService {
    case getBannerAndShoppingData
    case getNextShoppingData(id: Int)
}


extension HomeService: TargetType {
    var baseURL: URL {
        URL(string: BaseURL.base.rawValue)!
    }
    
    var path: String {
        switch self {
        case .getBannerAndShoppingData: return "home"
        case .getNextShoppingData: return "home/goods"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBannerAndShoppingData: return .get
        case .getNextShoppingData: return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .getBannerAndShoppingData: return .requestPlain
        case .getNextShoppingData(let id): return .requestParameters(parameters: ["lastid": id], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
}

class HomeServiceManger: BaseManager<HomeService> { }
