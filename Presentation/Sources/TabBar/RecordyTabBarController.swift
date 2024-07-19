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

final class RecordyTabBar: UITabBar {
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    var size = super.sizeThatFits(size)
    size.height += 15
    return size
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // 원하는 간격과 아이템 너비를 설정합니다.
    let itemWidth: CGFloat = 75
    let itemSpacing: CGFloat = 40

    // 전체 너비에서 각 아이템의 너비와 간격을 뺀 후, 시작 위치를 계산합니다.
    let totalWidth = CGFloat(items?.count ?? 0) * itemWidth + CGFloat((items?.count ?? 0) - 1) * itemSpacing
    var xOffset: CGFloat = (self.bounds.width - totalWidth) / 2

    for item in subviews where item is UIControl {
      item.frame = CGRect(
        x: xOffset,
        y: item.frame.origin.y,
        width: itemWidth,
        height: item.frame.height
      )
      xOffset += itemWidth + itemSpacing
    }
  }
}

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
