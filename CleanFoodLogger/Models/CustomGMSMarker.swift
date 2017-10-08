//
//  CustomGMSMarker.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/09.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation
import GoogleMaps

/**
 GMSMarkerのカスタムクラス
 */
class CustomGMSMarker: GMSMarker {
    
    public var id: String!
    public var name: String!
    public var category: String!
    public var imageURL: String!
    
    /// 初期化
    override init() {
        super.init()
    }
}
