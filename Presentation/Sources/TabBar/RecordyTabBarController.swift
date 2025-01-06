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
    appearance.backgroundColor = CommonAsset.viskitBlack.color
    let font = ViskitFont.title3.font
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .font: font
    ]
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
    tabBar.backgroundColor = .clear
    tabBar.tintColor = .clear
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
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

    let itemWidth: CGFloat = 32
    let itemSpacing: CGFloat = 39

    let totalWidth = CGFloat(items?.count ?? 0) * itemWidth + CGFloat((items?.count ?? 0) - 1) * itemSpacing
    var xOffset: CGFloat = (self.bounds.width - totalWidth) / 2

    for (index, tabBarItem) in items!.enumerated() {
        guard let itemView = subviews.first(where: { $0 is UIControl && $0.tag == index }) else { continue }

        itemView.frame = CGRect(
            x: xOffset,
            y: itemView.frame.origin.y,
            width: itemWidth,
            height: itemView.frame.height
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
