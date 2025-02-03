//
//  ReviewWebViewController.swift
//  Presentation
//
//  Created by Chandrala on 1/14/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit
import WebKit

@available(iOS 16.0, *)
class ReviewWebViewController: UIViewController {
  private var webView: WKWebView!
  private var url: URL
  
  init(platformId: String) {
    guard let url = URL(string: "https://place.map.kakao.com/m/\(platformId)#review") else {
      fatalError("Invalid URL")
    }
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setWebView()
    setSwipeGesture()
    loadURL()
    configureSheetPresentation()
  }
  
  private func setWebView() {
    let configuration = WKWebViewConfiguration()
    configuration.defaultWebpagePreferences.allowsContentJavaScript = true

    webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = self
    webView.uiDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.allowsLinkPreview = true
    webView.isUserInteractionEnabled = true
    view.addSubview(webView)
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func setSwipeGesture() {
    let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
    swipeGesture.edges = .left
    view.addGestureRecognizer(swipeGesture)
  }
  
  @objc private func handleSwipeGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
    if gesture.state == .recognized {
      if webView.canGoBack {
        webView.goBack()
      }
    }
  }
  
  private func loadURL() {
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  private func configureSheetPresentation() {
    if let sheet = self.sheetPresentationController {
      sheet.prefersGrabberVisible = true
      
      let smallDetent = UISheetPresentationController.Detent.custom { context in
        570
      }
      
      let fullScreenDetent = UISheetPresentationController.Detent.custom { context in
        context.maximumDetentValue
      }
      
      sheet.detents = [smallDetent, fullScreenDetent]
      sheet.largestUndimmedDetentIdentifier = .large
    }
  }
}

@available(iOS 16.0, *)
extension ReviewWebViewController: WKNavigationDelegate {
  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (
      WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
      }
}

@available(iOS 16.0, *)
extension ReviewWebViewController: WKUIDelegate {
  func webView(
    _ webView: WKWebView,
    createWebViewWith configuration: WKWebViewConfiguration,
    for navigationAction: WKNavigationAction,
    windowFeatures: WKWindowFeatures
  ) -> WKWebView? {
    webView.load(navigationAction.request)
    return nil
  }
}
