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
  case deactive
}

class ChipKeyWordButton: UIButton {
  var chipstate: ChipState = .deactive{
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
  private func setUI(){
    self.cornerRadius(15)
    titleLabel?.font = RecordyFont.body2.font
    updateChipAppearance()
  }
  
  private func updateChipAppearance() {
    switch chipstate {
    case .active:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(CommonAsset.recordyMain.color, for: .normal)
      layer.borderColor = CommonAsset.recordyMain.color.cgColor
      layer.borderWidth = 1

    case .deactive:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(CommonAsset.recordyGrey04.color, for: .normal)
    }
  }
}
