//
//  CustomInfoWindow.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/09.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class CustomInfoWindow: UIView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibViewSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.xibViewSet()
    }
    
    internal func xibViewSet() {
        if let view = Bundle.main.loadNibNamed("MarkerInfoContentsView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    /**
     セットアップ処理
     
     - Parameter name: ショップ名
     - Parameter category: カテゴリ名
     - Parameter imageURL: ショップ画像
     */
    public func setup(name: String, category: String, imageURL: String) {
        nameLabel.text = name
        categoryLabel.text = category
        
        let defaultImage = UIImage(named: "NoImage")
        if let url = URL(string: imageURL) {
            imageView.af_setImage(withURL: url, placeholderImage: defaultImage)
            return
        }
        imageView.image = defaultImage
    }
}
