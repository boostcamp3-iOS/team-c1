//
//  PrivacyPolicyViewController.swift
//  CoCo
//
//  Created by 이호찬 on 18/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    let resource = "privacy_policy"

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = Bundle.main.url(forResource: self.resource, withExtension: "html") else {
            return
        }
        self.webView.load(URLRequest(url: url))
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}
