//
//  MediumButton.swift
//  Common
//
//  Created by 송여경 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit

import Then

public enum MediumState {
  case active
  case inactive
}

public class MediumButton: UIButton {
  
  public var mediumState: MediumState = .inactive {
    didSet {
      mediumButtonAppearance()
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setUI() {
    layer.cornerRadius = 8
    titleLabel?.font = RecordyFont.button2.font
    mediumButtonAppearance()
  }
  
  public func mediumButtonAppearance(){
    switch mediumState {
    case .active:
      backgroundColor = CommonAsset.recordyWhite.color
      setTitleColor(
        CommonAsset.recordyGrey09.color,
        for: .normal
      )
    case .inactive:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(
        CommonAsset.recordyGrey01.color,
        for: .normal
      )
    }
  }
}
