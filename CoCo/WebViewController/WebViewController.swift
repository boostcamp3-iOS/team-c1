//
//  WebViewController.swift
//  CoCo
//
//  Created by 최영준 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    // MARK: - Properties
    var myGoodsData: MyGoodsData?

    // MARK: - Private properties
    private let webViewKeyPaths = [
        #keyPath(WKWebView.estimatedProgress)
    ]

    // MARK: - IBOutlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIView!

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = myGoodsData?.link, let url = URL(string: urlString) else {
            let message = getErrorMessage(WebViewControllerError.invalidLink)
            alert(message) { [weak self] in
                guard let self = self else {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        webView.navigationDelegate = self
        loadWebView(url)
        addObserversToWebView()
        setNavigationBar()
    }

    // MARK: - Observer related methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        if keyPath == "estimatedProgress" {
            updateProgressView(CGFloat(webView.estimatedProgress))
        }
    }

    private func addObserversToWebView() {
        for keyPath in webViewKeyPaths {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
    }

    // MARK: - WebView related methods
    private func loadWebView(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - Navigation related methods
    private func setNavigationBar() {
        if let title = myGoodsData?.shoppingmall {
            navigationItem.title = title
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        // TODO: 이미지 추가
        let backButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(popViewController))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - ProgressView related methods
    private func updateProgressView(_ value: CGFloat) {
        progressView.frame.size.width = value * view.frame.width
    }

    // MARK: - Action methods
    @IBAction private func actionGoForward(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    @IBAction private func actionGoBack(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction private func actionReload(_ sender: Any) {
        webView.reload()
    }

    @IBAction private func actionShare(_ sender: Any) {
        guard let url = webView.url else {
            let message = getErrorMessage(WebViewControllerError.invalidLink)
            alert(message)
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @IBAction private func actionFavorite(_ sender: Any) {
        // TODO: 즐겨찾기 반영 로직 구현
    }
}

// MARK: - ErrorHandlerType
extension WebViewController: ErrorHandlerType {
    func getErrorMessage(_ error: ErrorType) -> String {
        guard let webVCError = error as? WebViewControllerError else {
            return error.unknownError
        }
        return webVCError.rawValue
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // 웹뷰 로딩이 시작되면 progressView를 보여준다.
        progressView.isHidden = false
        view.bringSubviewToFront(progressView)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 웹뷰 로딩이 안료되면 progressView를 숨긴다.
        progressView.isHidden = true
    }
}
