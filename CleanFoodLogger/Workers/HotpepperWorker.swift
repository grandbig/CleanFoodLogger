//
//  HotpepperWorker.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/08.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation

// MARK: - Hotpepper worker

class HotpepperWorker {
    var hotpepper: HotpepperProtocol
    
    init(hotpepper: HotpepperProtocol) {
        self.hotpepper = hotpepper
    }
    
    func fetchRestaurants(latitude: Double, longitude: Double, completionHandler: @escaping ([Restaurant], HotpepperError?) -> Void) {
        hotpepper.fetchRestaurants(latitude: latitude, longitude: longitude) { (restaurants, error) in
            DispatchQueue.main.async {
                completionHandler(restaurants, error)
            }
        }
    }
}

// MARK: Hotpepper API

protocol HotpepperProtocol {
    
    // MARK: CRUD operations
    
    func fetchRestaurants(latitude: Double, longitude: Double, completionHandler: @escaping ([Restaurant], HotpepperError?) -> Void)
    func fetchRestaurant(id: String, completionHandler: @escaping (Restaurant?, HotpepperError?) -> Void)
}

// MARK: - CRUD operation errors

enum HotpepperError: Equatable, Error {
    case cannotFetch(String)
}

func == (lhs: HotpepperError, rhs: HotpepperError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}
