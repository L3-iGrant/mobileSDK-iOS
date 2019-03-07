//
//  WebViewViewController.swift
//  Lubax
//
//  Created by Ajeesh T S on 18/06/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

class WebViewViewController: BaseViewController, UIWebViewDelegate {
    @IBOutlet weak var webview : UIWebView!
    var urlString  = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        let backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.frame =  CGRect.init(x: 0, y: 0, width: 10, height: 40)
        backButton.setTitle(" ", for: .normal)
        //let backButtonBar = UIBarButtonItem(customView:backButton)
//        self.navigationItem.rightBarButtonItem = backButtonBar
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Policy"
        if let url =  URL.init(string: urlString){
            self.addLoadingIndicator()
            webview.loadRequest(URLRequest.init(url: url))
        }


//        webview.loadRequest(URLRequest.init(url: URL.init(string: urlString)!))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.removeLoadingIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.removeLoadingIndicator()
    }

  

}
