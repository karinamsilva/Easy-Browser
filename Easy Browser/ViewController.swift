//
//  ViewController.swift
//  Easy Browser
//
//  Created by Karina on 04/10/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView?
    var progressView: UIProgressView?
    
    override func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        setToolbar()
        addObserverOnWebview()
    }
    
    @objc func openTapped() {
        let alert = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openLink))
        alert.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openLink))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    func openLink(action: UIAlertAction) {
        guard let title = action.title,
        let url = URL(string: "https://\(title)")  else { return }
        webView?.load(URLRequest(url: url))
    }
    
    func addObserverOnWebview() {
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func setToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView?.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.sizeToFit()
        guard let progressViewUnwrapped = progressView  else { return }
        let progressButton = UIBarButtonItem(customView: progressViewUnwrapped)
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            guard let webView = webView else { return }
            progressView?.progress = Float(webView.estimatedProgress)
        }
    }

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

