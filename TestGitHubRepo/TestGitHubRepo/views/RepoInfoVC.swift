//
//  RepoInfoVC.swift
//  TestGitHubRepo
//
//  Created by Zimma on 24/10/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import UIKit
import WebKit

class RepoInfoVC: UIViewController {
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.progress = 0.0
        progressBar.backgroundColor = .clear
        progressBar.trackTintColor = .clear
        progressBar.tintColor = GlobalColors.progressColor
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    var repoData: Repo?
    
    var repoUrl = "https://ya.ru"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: GlobalColors.darkTextColor]
        setupView()
        loadRepo()
    }
    
    private func setupView() {
        
        navigationItem.title = "\(repoData!.fullName)   ★ \(repoData!.stars)"
        view.addSubview(webView)
        
        let views = ["webView": webView, "progressBar": progressBar]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: NSKeyValueObservingOptions.new, context: nil)
        webView.addSubview(progressBar)
        
        webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progressBar]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[progressBar]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.alpha = 0.4
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressBar.alpha = 0
                }) { (finished: Bool) in
                    self.progressBar.progress = 0
                }
            }
        }
    }
    
    func loadRepo() {
        if let url = URL(string: repoData!.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
