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
    var websites = ["apple.com", "hackingwithswift.com", "google.com" ]
    
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
        for website in websites {
            alert.addAction(UIAlertAction(title: website, style: .default, handler: openLink))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    func openLink(action: UIAlertAction) {
        guard let url = URL(string: "https://\(action.title!)")  else { return }
        webView?.load(URLRequest(url: url))
    }
    
    func addObserverOnWebview() {
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func setToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView?.reload))
        let left = createButtons(title: "back", action: #selector(webView?.goBack))
        let right = createButtons(title: "forward", action: #selector(webView?.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.sizeToFit()
        guard let progressViewUnwrapped = progressView  else { return }
        let progressButton = UIBarButtonItem(customView: progressViewUnwrapped)
        toolbarItems = [left, progressButton, spacer, refresh, right]
        navigationController?.isToolbarHidden = false
    }
    
    func createButtons(title: String, action: Selector?) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title, style: .plain, target: webView, action: action)
        return button
        
    }
    
    func showDenyAlert() {
        let alert = UIAlertController(title: "Acesso negado", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sair", style: .cancel))
        if presentedViewController == nil {
            self.present(alert, animated: true)
        }
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        if let host = url.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            showDenyAlert()
        }

        decisionHandler(.cancel)
    }
}
