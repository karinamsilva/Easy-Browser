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
    
    override func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
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
    
    
    
    


}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

