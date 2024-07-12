//
//  ChipKeyWordButton.swift
//  Common
//
//  Created by 송여경 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum ChipState {
  case active
  case inactive
}

class ChipKeyWordButton: UIButton {
  var chipstate: ChipState = .inactive {
    didSet {
      updateChipAppearance()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.cornerRadius(16)
    titleLabel?.font = RecordyFont.caption1.font
    updateChipAppearance()
  }

  func setState(state: ChipState) {
    self.chipstate = state
  }

  private func updateChipAppearance() {
    switch chipstate {
    case .active:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(
        CommonAsset.recordyMain.color,
        for: .normal
      )
      layer.borderColor = CommonAsset.recordyMain.color.cgColor
      layer.borderWidth = 1

    case .inactive:
      backgroundColor = CommonAsset.recordyGrey09.color
      setTitleColor(
        CommonAsset.recordyGrey04.color,
        for: .normal
      )
      layer.borderColor = UIColor.clear.cgColor
      layer.borderWidth = 0
    }
  }
}
