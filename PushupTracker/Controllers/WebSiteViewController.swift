//
//  WebSiteViewController.swift
//  PushupTracker
//
//  Created by Harrison, Kyle on 10/3/19.
//  Copyright © 2019 Harrison, Kyle. All rights reserved.
//

import UIKit
import WebKit


class WebSiteViewController : UIViewController {
    
//    MARK: - Outlets
    
    @IBOutlet weak var WebView: WKWebView!
    
//    MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "https://hundredpushups.com")!
        WebView.load(URLRequest(url: url))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: WebView, action:                                   #selector(WebView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
    }
    
    
}
