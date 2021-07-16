//
//  BaseManager.swift
//  Network
//
//  Created by apple on 2021/06/18.
//

import Foundation
import Moya
import RxSwift


public protocol ServiceManager {

    associatedtype ProviderType: TargetType

    var provider: MoyaProvider<ProviderType> { get }

    var jsonDecoder: JSONDecoder { get }
}

open class BaseManager<T>: ServiceManager where T: TargetType {
    public typealias ProviderType = T

    private var sharedProvider: MoyaProvider<T>!

    public required init() {}

    open var provider: MoyaProvider<T> {
        guard let provider = sharedProvider else {
            self.sharedProvider = MoyaProvider<T>()
            return sharedProvider
        }
        return provider
    }

    open var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    open func request<T>(_ target: ProviderType, at keyPath: String? = nil) -> Observable<T> where T: Codable {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.self, atKeyPath: keyPath, using: jsonDecoder)
            .asObservable()
    }

    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    }
}

