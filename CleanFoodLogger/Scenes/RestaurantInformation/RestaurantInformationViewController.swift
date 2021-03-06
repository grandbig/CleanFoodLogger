//
//  RestaurantInformationViewController.swift
//  CleanFoodLogger
//
//  Created by Takahiro Kato on 2017/10/09.
//  Copyright © 2017年 Takahiro Kato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import WebKit

protocol RestaurantInformationDisplayLogic: class {
    func displayRestaurantInformation(viewModel: RestaurantInformation.Load.ViewModel)
}

class RestaurantInformationViewController: UIViewController, RestaurantInformationDisplayLogic {
    var interactor: RestaurantInformationBusinessLogic?
    var router: (NSObjectProtocol & RestaurantInformationRoutingLogic & RestaurantInformationDataPassing)?
    private var webView: WKWebView!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = RestaurantInformationInteractor()
        let presenter = RestaurantInformationPresenter()
        let router = RestaurantInformationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RestaurantInformation"
        configuraWebView()
        loadRestaurantInformation()
    }
    
    // MARK: Configuration
    
    private func configuraWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        webView = WKWebView(frame: frame, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    }
    
    // MARK: Load restaurant information
    
    func loadRestaurantInformation() {
        let request = RestaurantInformation.Load.Request()
        interactor?.loadRestaurantInformation(request: request)
    }
    
    func displayRestaurantInformation(viewModel: RestaurantInformation.Load.ViewModel) {
        if let url = URL(string: viewModel.url) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}

extension RestaurantInformationViewController: WKUIDelegate {
    
}

extension RestaurantInformationViewController: WKNavigationDelegate {
    
}
