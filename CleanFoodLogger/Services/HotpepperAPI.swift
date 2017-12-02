//
//  HotpepperAPI.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/08.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

internal enum HotpepperAPITarget {
    case restaurants(lat: Double, lng: Double)
    case restaurant(id: String)
}

extension HotpepperAPITarget: TargetType {
    
    /// API Key
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "key", ofType: "plist") else {
            fatalError("key.plistが見つかりません")
        }
        
        guard let dic = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("key.plistの中身が想定通りではありません")
        }
        
        guard let apiKey = dic["hotpepperApiKey"] as? String else {
            fatalError("hotpepperAPIのKeyが設定されていません")
        }
        
        return apiKey
    }
    
    // ベースURLを文字列で定義
    private var _baseURL: String {
        return "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    }
    
    public var baseURL: URL {
        return URL(string: _baseURL)!
    }
    
    // enumの値に対応したパスを指定
    public var path: String {
        switch self {
        case .restaurants, .restaurant:
            return ""
        }
    }
    
    // enumの値に対応したHTTPメソッドを指定
    public var method: Moya.Method {
        switch self {
        case .restaurants, .restaurant:
            return .get
        }
    }
    
    // スタブデータの設定
    public var sampleData: Data {
        switch self {
        case .restaurants:
            return "Stub data".data(using: String.Encoding.utf8)!
        case .restaurant:
            return "Stub data".data(using: String.Encoding.utf8)!
        }
    }
    
    // パラメータの設定
    var task: Task {
        switch self {
        case .restaurants(let lat, let lng):
            return .requestParameters(parameters: ["key": apiKey, "format": "json", "lat": lat, "lng": lng, "range": 3],
                                      encoding: URLEncoding.default)
        case .restaurant(let id):
            return .requestParameters(parameters: ["key": apiKey, "format": "json", "id": id], encoding: URLEncoding.default)
        }
    }
    
    // ヘッダーの設定
    var headers: [String : String]? {
        switch self {
        case .restaurants, .restaurant:
            return nil
        }
    }
}

/**
 ホットペッパーAPI
 */
class HotpepperAPI: HotpepperProtocol {
    
    private var provider: MoyaProvider<HotpepperAPITarget>!
    
    init() {
        provider = MoyaProvider<HotpepperAPITarget>()
    }
    
    func fetchRestaurants(latitude: Double, longitude: Double, completionHandler: @escaping ([Restaurant], HotpepperError?) -> Void) {
        
        provider.request(.restaurants(lat: latitude, lng: longitude)) { result in
            
            switch result {
            case .success(let response):
                do {
                    var restaurants: [Restaurant] = [Restaurant]()
                    let json = try JSON(data: response.data)
                    guard let shops = json["results"]["shop"].array else {
                        completionHandler([], HotpepperError.cannotFetch("レストラン情報を取得できませんでした。"))
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
                        let restaurant = Restaurant(id: id,
                                                    name: name,
                                                    category: category,
                                                    imageURL: imageURL,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    restaurantURL: restaurantURL)
                        restaurants.append(restaurant)
                    }
                    
                    completionHandler(restaurants, nil)
                } catch {
                    completionHandler([], HotpepperError.cannotFetch("レストラン情報を取得できませんでした"))
                }
                
            case .failure(let error):
                completionHandler([], HotpepperError.cannotFetch(error.localizedDescription))
            }
        }
    }
    
    func fetchRestaurant(id: String, completionHandler: @escaping (Restaurant?, HotpepperError?) -> Void) {
        
        provider.request(.restaurant(id: id)) { result in
            
            switch result {
            case .success(let response):
                do {
                    var restaurant: Restaurant?
                    let json = try JSON(data: response.data)
                    guard let shop = json["results"]["shop"].array?.first else {
                        completionHandler(nil, HotpepperError.cannotFetch("レストラン情報を取得できませんでした。"))
                        return
                    }
                    let id = shop["id"].string ?? "ID不明"
                    let name = shop["name"].string ?? "ショップ名不明"
                    let category = shop["genre"]["name"].string ?? "カテゴリ不明"
                    let imageURL = shop["photo"]["mobile"]["l"].string ?? ""
                    let latitude = atof(shop["lat"].string ?? "0")
                    let longitude = atof(shop["lng"].string ?? "0")
                    let restaurantURL = shop["urls"]["pc"].string ?? ""
                    restaurant = Restaurant(id: id,
                                            name: name,
                                            category: category,
                                            imageURL: imageURL,
                                            latitude: latitude,
                                            longitude: longitude,
                                            restaurantURL: restaurantURL)
                    
                    completionHandler(restaurant, nil)
                } catch {
                    completionHandler(nil, HotpepperError.cannotFetch("レストラン情報を取得できませんでした。"))
                }
            case .failure(let error):
                completionHandler(nil, HotpepperError.cannotFetch(error.localizedDescription))
            }
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
