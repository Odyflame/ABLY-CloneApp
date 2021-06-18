//
//  HomeController.swift
//  Network
//
//  Created by apple on 2021/06/18.
//

import Foundation
import Moya
import RxSwift

public class HomeController {
    public static let shared = HomeController()
    private let serviceManager = HomeServiceManger()
    
    public func getBannerAndShoppingData() -> Observable<HomeResult>{
        serviceManager.provider.rx
            .request(HomeService.getBannerAndShoppingData)
            .map(HomeResult.self)
            .asObservable()
    }
    
    public func getNextShoppingData(id: Int) -> Observable<GoodsResult> {
        serviceManager.provider.rx
            .request(HomeService.getNextShoppingData(id: id))
            .map(GoodsResult.self)
            .asObservable()
    }
}


