//
//  DetailsViewController.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import Foundation
import WebKit
import UIKit

class DetailsViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var res_id: Int = 0
    
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
       webView.uiDelegate = self
       view = webView
        self.navigationController?.navigationBar.backItem?.title = ""
        self.title = "Reserve a table"
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        let urlstr = "\(details_url)\(res_id)"
       let myURL = URL(string:urlstr)
       let myRequest = URLRequest(url: myURL!)
       webView.load(myRequest)
    }

}
