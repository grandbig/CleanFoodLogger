//
//  HotpepperAPI.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/08.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 ホットペッパーAPI
 */
class HotpepperAPI: HotpepperProtocol {
    
    /// API Key
    private var apiKey: String = String()
    /// Geocoding APIのベースURL
    private let baseURL: String = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    
    /// 初期化処理
    init() {
        if let path = Bundle.main.path(forResource: "key", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let apiKey = dic["hotpepperApiKey"] as? String {
                    self.apiKey = apiKey
                }
            }
        }
    }
    
    func fetchRestaurants(latitude: Double, longitude: Double, completionHandler: @escaping ([Restaurant], HotpepperError?) -> Void) {
        let parameters = ["key": self.apiKey, "format": "json", "lat": latitude, "lng": longitude, "range": 3] as [String : Any]
        Alamofire.SessionManager.default.requestWithoutCache(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            var restaurants: [Restaurant] = [Restaurant]()
            
            if response.result.isFailure {
                let defaultErrorMessage = "レストラン情報を取得できませんでした。"
                completionHandler([], HotpepperError.cannotFetch(response.result.error?.localizedDescription ?? defaultErrorMessage))
                return
            }
            
            let json = JSON(response.result.value as Any)
            guard let shops = json["results"]["shop"].array else {
                let defaultErrorMessage = "レストラン情報を取得できませんでした。"
                completionHandler([], HotpepperError.cannotFetch(response.result.error?.localizedDescription ?? defaultErrorMessage))
                return
            }
            
            for shop in shops {
                let id = shop["id"].string ?? "ID不明"
                let name = shop["name"].string ?? "ショップ名不明"
                let category = shop["genre"]["name"].string ?? "カテゴリ不明"
                let imageURL = shop["photo"]["mobile"]["l"].string ?? ""
                let latitude = atof(shop["lat"].string ?? "0")
                let longitude = atof(shop["lng"].string ?? "0")
                let restaurantURL = shop["urls"]["pc"].string ?? ""
                let restaurant = Restaurant(id: id, name: name, category: category, imageURL: imageURL, latitude: latitude, longitude: longitude, restaurantURL: restaurantURL)
                restaurants.append(restaurant)
            }
            
            completionHandler(restaurants, nil)
        }
    }
    
    func fetchRestaurant(id: String, completionHandler: @escaping (Restaurant?, HotpepperError?) -> Void) {
        let parameters = ["key": self.apiKey, "format": "json", "id": id] as [String : Any]
        Alamofire.SessionManager.default.requestWithoutCache(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            var restaurant: Restaurant?
            
            if response.result.isFailure {
                let defaultErrorMessage = "レストラン情報を取得できませんでした。"
                completionHandler(nil, HotpepperError.cannotFetch(response.result.error?.localizedDescription ?? defaultErrorMessage))
                return
            }
            
            let json = JSON(response.result.value as Any)
            guard let shop = json["results"]["shop"].array?.first else {
                let defaultErrorMessage = "レストラン情報を取得できませんでした。"
                completionHandler(nil, HotpepperError.cannotFetch(response.result.error?.localizedDescription ?? defaultErrorMessage))
                return
            }
            
            let id = shop["id"].string ?? "ID不明"
            let name = shop["name"].string ?? "ショップ名不明"
            let category = shop["genre"]["name"].string ?? "カテゴリ不明"
            let imageURL = shop["photo"]["mobile"]["l"].string ?? ""
            let latitude = atof(shop["lat"].string ?? "0")
            let longitude = atof(shop["lng"].string ?? "0")
            let restaurantURL = shop["urls"]["pc"].string ?? ""
            restaurant = Restaurant(id: id, name: name, category: category, imageURL: imageURL, latitude: latitude, longitude: longitude, restaurantURL: restaurantURL)
            
            completionHandler(restaurant, nil)
        }
    }
}

extension Alamofire.SessionManager {
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest {
            do {
                var urlRequest = try URLRequest(url: url, method: method, headers: headers)
                urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
                let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
                return request(encodedURLRequest)
            } catch {
                print(error)
                return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
            }
    }
}
