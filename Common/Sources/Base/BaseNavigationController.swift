//
//  BaseNavigationController.swift
//  Common
//
//  Created by 한지석 on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public class BaseNavigationController: UINavigationController {
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    addObserver()
  }

  private func addObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateDidComplete), // selector 이름을 명확하게 변경
      name: .updateDidComplete,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(reportDidComplete),
      name: .reportDidComplete,
      object: nil
    )
  }

  @objc private func updateDidComplete(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let message = userInfo["message"] as? String,
          let stateString = userInfo["state"] as? String else {
      return
    }
    let status: RecordyToastStatus = stateString == "success" ? .complete : .warning
    self.showToast(status: status, message: message, height: 44)
  }

  @objc private func reportDidComplete(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let message = userInfo["message"] as? String,
          let stateString = userInfo["state"] as? String else {
      return
    }
    let status: RecordyToastStatus = stateString == "success" ? .complete : .warning
    self.showToast(status: status, message: message, height: 44)
  }

  private func configureNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .clear
    appearance.shadowColor = .clear
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: CommonAsset.viskitGray01.color,
      NSAttributedString.Key.font: ViskitFont.title3.font
    ]
    appearance.buttonAppearance.normal.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: CommonAsset.viskitGray01.color
    ]

    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance

    navigationBar.tintColor = .white
    navigationItem.backButtonDisplayMode = .minimal
    navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil,
      action: nil
    )
  }
}
