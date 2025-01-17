//
//  RecordyButton.swift
//  Common
//
//  Created by 송여경 on 7/5/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

public enum ButtonState {
  case active
  case inactive
}

public class RecordyButton: UIButton {
  
  public var buttonState: ButtonState = .inactive {
    didSet {
      updateButtonStyle()
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
    layer.cornerRadius = 12
    titleLabel?.font = ViskitFont.body1.font
    updateButtonStyle()
  }
  
  private func updateButtonStyle() {
    switch buttonState {
    case .active:
      backgroundColor = CommonAsset.viskitYellow400.color
      setTitleColor(CommonAsset.viskitBG.color, for: .normal)
    case .inactive:
      backgroundColor = CommonAsset.viskitGray11.color
      setTitleColor(CommonAsset.viskitGray08.color, for: .normal)
    }
  }
}
