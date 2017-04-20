//
//  WebViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/20/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class WebViewContoller: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    var sourceUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: sourceUrl)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
}
