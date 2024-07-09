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
    appearance.backgroundColor = .black
    appearance.shadowColor = UIColor.clear
    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    navigationBar.titleTextAttributes = [
//      NSAttributedString.Key.foregroundColor: CommonAsset.recordyWhite,
      NSAttributedString.Key.font: RecordyFont.title2
    ]
    navigationItem.backButtonDisplayMode = .minimal
  }
}
