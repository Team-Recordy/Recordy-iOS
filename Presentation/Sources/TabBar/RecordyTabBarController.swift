//
//  RecordyTabBarController.swift
//  Presentation
//
//  Created by 한지석 on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

@available(iOS 16.0, *)
public final class RecordyTabBarController: UITabBarController, UITabBarControllerDelegate {

  private var recordyTabBar = RecordyTabBar()

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setValue(recordyTabBar, forKey: "tabBar")
    setStyle()
    setTabBarItem()
    setDelegate()
  }

  private func setStyle() {
    let appearance = UITabBarAppearance()
    appearance.backgroundColor = CommonAsset.recordyBG.color
    tabBar.backgroundColor = .clear
    tabBar.tintColor = .clear
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
    tabBar.standardAppearance = appearance
  }

  private func setTabBarItem() {
    let viewControllers = RecordyTabBarType.allCases.map { createTabBarItem(type: $0) }
    setViewControllers(viewControllers, animated: false)
  }

  private func setDelegate() {
    self.delegate = self
  }
}

final class RecordyTabBar: UITabBar { }

@available(iOS 16.0, *)
extension RecordyTabBarController {
  private func createTabBarItem(
    type: RecordyTabBarType
  ) -> UIViewController {
    let tabBarItem = UITabBarItem(
      title: nil,
      image: type.inactive.withRenderingMode(.alwaysOriginal),
      selectedImage: type.active.withRenderingMode(.alwaysOriginal)
    )
    tabBarItem.imageInsets.top = 12
    tabBarItem.imageInsets.bottom = -12
    let currentViewController = type.viewController
    currentViewController.tabBarItem = tabBarItem
    return currentViewController
  }
}
