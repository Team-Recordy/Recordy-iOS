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
