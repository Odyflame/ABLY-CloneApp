//
//  HomeViewModel.swift
//  ABLY
//
//  Created by apple on 2021/06/18.
//

import Foundation
import Network
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
    func getBannerAndShoppingData()
    func getNextShoppingData(id: Int)
}

protocol HomeViewModelOutput {
    var banners: BehaviorRelay<[BannerResult]> { get }
    var goods: BehaviorRelay<[GoodsResult]> { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

public class HomeViewModel: HomeViewModelType, HomeViewModelOutput, HomeViewModelInput {
    var input: HomeViewModelInput { return self }
    
    var output: HomeViewModelOutput { return self }
    
    var banners: BehaviorRelay<[BannerResult]>
    
    var goods: BehaviorRelay<[GoodsResult]>
    let disposeBag = DisposeBag()
    
    init() {
        banners = BehaviorRelay<[BannerResult]>(value: [])
        goods = BehaviorRelay<[GoodsResult]>(value: [])
    }
    
    func getBannerAndShoppingData() {
        HomeController.shared.getBannerAndShoppingData()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] result in
                
                guard let self = self,
                      let element = result.element else {
                    print("하하 안되넹")
                    return
                }
                
                self.goods.accept([])
                self.banners.accept([])
                self.goods.accept(element.goods)
                self.banners.accept(element.banners ?? [])
                
            }.disposed(by: disposeBag)
    }
    
    func getNextShoppingData(id: Int) {
        HomeController.shared.getNextShoppingData(id: id)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] result in
                
                guard let self = self,
                      let element = result.element,
                      !element.goods.isEmpty else {
                    print("하하 왜안되지?")
                    return
                }
                
                self.goods.accept(self.goods.value + element.goods)
                
            }.disposed(by: disposeBag)
    }
}
