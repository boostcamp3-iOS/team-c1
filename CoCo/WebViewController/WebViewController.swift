//
//  WebViewController.swift
//  CoCo
//
//  Created by 최영준 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import WebKit

// TODO: WKWebView 로드시 메모리 누수 발생: JavaScriptCore 원인 찾아보기
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
    @IBOutlet private weak var favoriteButton: UIBarButtonItem!

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = myGoodsData?.link, let url = URL(string: urlString) else {
            let message = getErrorMessage(MyGoodsDataError.invalidLink)
            alert(message) { [weak self] in
                guard let self = self else {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        setWebView()
        setNavigationBar()
        setProgressView()
        loadWebView(url)
        addObserversToWebView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavoriteButton()
    }

    // MARK: - Observer related methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            updateProgressView(CGFloat(webView.estimatedProgress))
        }
    }

    private func addObserversToWebView() {
        for keyPath in webViewKeyPaths {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
    }

    // MARK: - Navigation related methods
    private func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        if let title = myGoodsData?.shoppingmall {
            navigationItem.title = title
        }
        let backButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .plain, target: self, action: #selector(popViewController))
        backButton.tintColor = AppColor.purple
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: false)
    }

    // MARK: - WebView related methods
    private func setWebView() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    private func loadWebView(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - ProgressView related methods
    private func setProgressView() {
        progressView.backgroundColor = AppColor.purple
    }

    private func updateProgressView(_ value: CGFloat) {
        progressView.frame.size.width = value * view.frame.width
    }

    // MARK: - Button related methods
    private func setFavoriteButton() {
        guard let isFavorite = myGoodsData?.isFavorite else {
            return
        }
        favoriteButton.image =
            (isFavorite) ? UIImage(named: "like_fill") : UIImage(named: "like")
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
            let message = getErrorMessage(MyGoodsDataError.invalidLink)
            alert(message)
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @IBAction private func actionFavorite(_ sender: Any) {
        // TODO: 서비스에서 즐겨찾기 반영 로직 구현
        if let isFavorite = myGoodsData?.isFavorite {
            myGoodsData?.isFavorite = !isFavorite
        }
        setFavoriteButton()
    }
}

// MARK: - ErrorHandlerType
extension WebViewController: ErrorHandlerType { }

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
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension WebViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
