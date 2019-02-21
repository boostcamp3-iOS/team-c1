//
//  WebViewController.swift
//  CoCo
//
//  Created by 최영준 on 08/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import WebKit

/**
 상품의 link를 웹 뷰로 띄워주는 컨트롤러
 
 sendData(_:) 메서드의 인자로 MyGoodsData를 전달해주어야 한다.
 ```
 func sendData(_ data: MyGoodsData)
 ```
 - Author: [최영준](https://github.com/0jun0815)
 */
class WebViewController: UIViewController {
    // MARK: - Private properties
    private var service: WebViewService?
    private var isFavorite = false
    private let webViewKeyPaths = [
        #keyPath(WKWebView.estimatedProgress)
    ]

    // MARK: - IBOutlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var favoriteButton: UIBarButtonItem!

    // MARK: - Required call methods
    /// 웹 뷰 호출시 데이터를 전달한다. (필수)
    func sendData(_ data: MyGoodsData) {
        service = WebViewService(data: data)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = service?.myGoodsData else {
            let message = getErrorMessage(MyGoodsDataError.lostData)
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
        extendedLayoutIncludesOpaqueBars = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service?.fetchData()
        service?.insert()
        if let favorite = service?.myGoodsData.isFavorite {
            isFavorite = favorite
        }
        setFavoriteButton()
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isFavorite != service?.myGoodsData.isFavorite {
            service?.updateFavorite(isFavorite)
        }
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    // MARK: - Observer related methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        // webView.estimatedProgress 값 변경에 따라 progressView를 업데이트한다.
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        if let title = service?.myGoodsData.shoppingmall {
            navigationItem.title = title
        }
        let backButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .plain, target: self, action: #selector(popViewController))
        backButton.tintColor = AppColor.purple
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - WebView related methods
    private func setWebView() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        guard let urlString = service?.myGoodsData.link, let url = URL(string: urlString) else {
            let message = getErrorMessage(MyGoodsDataError.invalidLink)
            alert(message) { [weak self] in
                guard let self = self else {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        loadWebView(url)
        addObserversToWebView()
    }

    private func loadWebView(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - ProgressView related methods
    private func setProgressView() {
        progressView.backgroundColor = AppColor.purple
    }

    /// ProgressView 업데이트 메서드
    private func updateProgressView(_ value: CGFloat) {
        progressView.frame.size.width = value * view.frame.width
    }

    // MARK: - Button related methods
    private func setFavoriteButton() {
        favoriteButton.image = (isFavorite) ?
            UIImage(named: "like_fill") : UIImage(named: "like")
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
        isFavorite = !isFavorite
        setFavoriteButton()
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            // 웹뷰 로딩이 시작되면 progressView와 네트워크 인디케이터를 보여준다.
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.progressView.isHidden = false
            self.view.bringSubviewToFront(self.progressView)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            // 웹뷰 로딩이 안료되면 progressView와 네트워크 인디케이터를 숨긴다.
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.progressView.isHidden = true
        }
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

// MARK: - UIGestureRecognizerDelegate
extension WebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - ErrorHandlerType
extension WebViewController: ErrorHandlerType { }
