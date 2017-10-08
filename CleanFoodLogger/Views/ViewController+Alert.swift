//
//  ViewController+Alert.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/08.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /**
     警告モーダルの表示処理
     
     - parameter title: アラートのタイトル
     - parameter message: アラートのメッセージ
     - parameter completion: OKタップ時のCallback
     */
    internal func showAlert(title: String, message: String, completion: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default) { _ in
            completion()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     確認モーダルの表示処理
     
     - parameter title: アラートのタイトル
     - parameter message: アラートのメッセージ
     - parameter okCompletion: OKタップ時のCallback
     - parameter cancelCompletion: Cancelタップ時のCallback
     */
    internal func showConfirm(title: String, message: String, okCompletion: @escaping (() -> Void), cancelCompletion: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default) { _ in
            okCompletion()
        }
        let cancelAction = UIAlertAction.init(title: "キャンセル", style: UIAlertActionStyle.cancel) { _ in
            cancelCompletion()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /**
     確認アクションシートの表示処理
     
     - parameter message: アクションシートのメッセージ
     - parameter firstActionTitle: 1つ目のアクション名
     - parameter secondActionTitle: 2つ目のアクション名
     - parameter firstCompletion: 1つ目のアクションタップ時のCallback
     - parameter secondCompletion: 2つ目のアクションタップ時のCallback
     */
    internal func showActionSheet(
        message: String,
        firstActionTitle: String,
        secondActionTitle: String,
        firstCompletion: @escaping(() -> Void),
        secondCompletion: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: "確認", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        let firstAction = UIAlertAction.init(title: firstActionTitle, style: UIAlertActionStyle.default) { _ in
            firstCompletion()
        }
        let secondAction = UIAlertAction.init(title: secondActionTitle, style: UIAlertActionStyle.default) { _ in
            secondCompletion()
        }
        let cancelAction = UIAlertAction.init(title: "キャンセル", style: UIAlertActionStyle.cancel) { _ in
        }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
