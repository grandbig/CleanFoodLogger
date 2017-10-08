//
//  Restaurant.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/08.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation

struct Restaurant: Equatable {
    
    var id: String
    var name: String
    var category: String
    var imageURL: String
    var latitude: Double
    var longitude: Double
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.category == rhs.category
        && lhs.imageURL == rhs.imageURL
        && lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
}
