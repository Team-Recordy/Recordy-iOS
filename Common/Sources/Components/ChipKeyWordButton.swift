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

public enum ChipState {
  case active
  case inactive
}

public class ChipKeyWordButton: UIButton {
  public var chipstate: ChipState = .inactive {
    didSet {
      updateChipUI()
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.cornerRadius(16.adaptiveHeight)
    titleLabel?.font = RecordyFont.caption1.font
    updateChipUI()
  }

  public func setState(state: ChipState) {
    self.chipstate = state
  }

  private func updateChipUI() {
    switch chipstate {
    case .active:
      backgroundColor = CommonAsset.viskitGray01.color
      setTitleColor(
        CommonAsset.viskitBlack.color,
        for: .normal
      )

    case .inactive:
      backgroundColor = CommonAsset.viskitGray09.color
      setTitleColor(
        CommonAsset.viskitGray03.color,
        for: .normal
      )
    }
  }
}
