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

    // MARK: - IBOutlets
    @IBOutlet private weak var webView: WKWebView!

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
    }

    // MARK: - WebView related methods
    private func loadWebView(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
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
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}
