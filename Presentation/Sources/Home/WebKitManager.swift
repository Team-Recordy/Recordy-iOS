//
//  WebKitManager.swift
//  Presentation
//
//  Created by Chandrala on 1/14/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation
import UIKit

final class WebViewManager {
  static func presentWebView(from viewController: UIViewController, urlString: String) {
    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      return
    }
    
    let webVC = RouteWebViewController(url: url)
    webVC.modalPresentationStyle = .pageSheet
    
    if let sheet = webVC.sheetPresentationController {
      sheet.prefersGrabberVisible = true
    }
    
    viewController.present(webVC, animated: true)
  }
  
  static func openURL(appURLString: String, webURLString: String, openInWebView: @escaping (String) -> Void) {
    if let appURL = URL(string: appURLString), UIApplication.shared.canOpenURL(appURL) {
      UIApplication.shared.open(appURL)
    } else {
      openInWebView(webURLString)
    }
  }
}
