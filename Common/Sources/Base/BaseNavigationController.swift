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
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    navigationBar.backgroundColor = .clear
    navigationBar.barTintColor = .white
    navigationBar.tintColor = .white
    view.backgroundColor = .clear
    navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: CommonAsset.recordyWhite.color,
      NSAttributedString.Key.font: RecordyFont.title3.font
    ]
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .clear
    appearance.shadowColor = UIColor.clear
//    navigationBar.standardAppearance = appearance
//    navigationBar.scrollEdgeAppearance = appearance

    navigationItem.backButtonDisplayMode = .minimal
  }
}
