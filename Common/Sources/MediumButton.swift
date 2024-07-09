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

enum MediumState {
  case active
  case deactive
}

class MediumButton: UIButton {
  
  var mediumState: MediumState = .deactive {
    didSet {
      mediumButtonAppearance()
    }
  }
  override init(frame: CGRect){
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI(){
    layer.cornerRadius = 8
    titleLabel?.font = RecordyFont.button2.font
    mediumButtonAppearance()
  }
  
  private func mediumButtonAppearance(){
    switch mediumState {
    case .active:
      backgroundColor = CommonAsset.recordyMain.color
      setTitleColor(CommonAsset.recordyGrey09.color, for: .normal)
    case .deactive:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(CommonAsset.recordyGrey01.color, for: .normal)
    }
  }
}
