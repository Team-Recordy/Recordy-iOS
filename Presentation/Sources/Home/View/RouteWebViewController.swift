//
//  RouteWebViewController.swift
//  Presentation
//
//  Created by Chandrala on 1/14/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit
import WebKit

final class RouteWebViewController: UIViewController {
    private var webView: WKWebView!
    private var url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }

    private func setupWebView() {
        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }

    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
