//
//  SearchResultDetailViewController.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/22/21.
//

import UIKit
import WebKit

// MARK: SearchResultDetailViewController

final class SearchResultDetailViewController: NiblessViewController {
    
    private var webView: WKWebView!
    private var url: URL
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(with url: URL) {
        self.url = url
        super.init()
        
        configureLayout()
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        updateColors()
    }
    
    // MARK: Private
    
    private func configureLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateColors() {
        view.backgroundColor = .black
        activityIndicator.color = StyleGuide.Colors.alamoYellow
    }
}

// MARIK: WKNavigationDelegate

extension SearchResultDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
