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
        NSAttributedString.Key.foregroundColor: CommonAsset.recordyWhite.color,
        NSAttributedString.Key.font: RecordyFont.title3.font
    ]
    appearance.buttonAppearance.normal.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: CommonAsset.recordyWhite.color
    ]

    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance

    navigationBar.tintColor = .white
    navigationItem.backButtonDisplayMode = .minimal
  }
}
