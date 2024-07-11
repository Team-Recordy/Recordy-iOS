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

enum ButtonState {
  case active
  case inactive
}

public class RecordyButton: UIButton {
  
  var buttonState: ButtonState = .inactive {
    didSet {
      updateButtonAppearance()
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
    titleLabel?.font = RecordyFont.button1.font
    updateButtonAppearance()
  }
  
  private func updateButtonAppearance() {
    switch buttonState {
    case .active:
      backgroundColor = CommonAsset.recordyMain.color
      setTitleColor(CommonAsset.recordyGrey09.color, for: .normal)
    case .inactive:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(CommonAsset.recordyGrey04.color, for: .normal)
    }
  }
}
