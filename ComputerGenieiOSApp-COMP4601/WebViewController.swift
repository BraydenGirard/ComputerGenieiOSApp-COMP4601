//
//  WebViewController.swift
//  ComputerGenieiOSApp-COMP4601
//
//  Created by Ben Sweett on 2015-04-07.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let urlRequest = NSURLRequest(URL: url)
        webview.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNSURL(url: String) {
        self.url = NSURL(string: url)
    }
    
    //MARK: - Actions
    
    @IBAction func closeWebViewPressed(sender: UIBarButtonItem) {
        self.url = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backWebViewPressed(sender: UIBarButtonItem) {
        if(webview.canGoBack) {
             webview.goBack()
        }
    }
    
    @IBAction func forwardWebViewPressed(sender: UIBarButtonItem) {
        if(webview.canGoForward) {
            webview.goForward()
        }
    }
    
    @IBAction func refreshWebViewPressed(sender: UIBarButtonItem) {
        webview.reload()
    }
    
    //MARK: - UIWebView Delegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
