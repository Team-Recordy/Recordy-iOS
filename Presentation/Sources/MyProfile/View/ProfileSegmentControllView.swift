//
//  ProfileSegmentControllView.swift
//  Presentation
//
//  Created by 송여경 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Common

enum ControlType: String {
  case taste = "내 취향"
  case record = "내 기록"
  case bookmark = "북마크"
}

final class ProfileSegmentControllView: UIView {
  
  private var selectedTab: ControlType = .taste {
    didSet {
      setupStyle()
    }
  }
  
  private let barStack = UIStackView()
  private let tasteButton = UIButton()
  private let recordButton = UIButton()
  private let bookmarkButton = UIButton()
  private let underDivider = Divider(color: CommonAsset.recordyGrey01.color)
  
  
  
  
  private func setupStyle() {
    
  }
}
