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
    let font = UIFont.systemFont(ofSize: 0)
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
    
    guard let tabBarItems = items else { return }
    
    let itemWidth: CGFloat = 32
    let itemSpacing: CGFloat = 39
    let totalWidth = CGFloat(tabBarItems.count) * itemWidth + CGFloat(tabBarItems.count - 1) * itemSpacing
    var xOffset: CGFloat = (self.bounds.width - totalWidth) / 2
    
    let sortedTabBarViews = subviews.compactMap { $0 as? UIControl }
      .sorted { $0.frame.minX < $1.frame.minX }
    
    for (index, tabBarItemView) in sortedTabBarViews.enumerated() {
      guard index < tabBarItems.count else { continue }
      
      tabBarItemView.frame = CGRect(
        x: xOffset,
        y: tabBarItemView.frame.origin.y,
        width: itemWidth,
        height: tabBarItemView.frame.height
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
      title: "",
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
