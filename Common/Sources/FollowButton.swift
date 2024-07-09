//
//  FollowButton.swift
//  Common
//
//  Created by 송여경 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum FollowState{
  case follow
  case following
}

class FollowButton: UIButton {
  var followState: FollowState = .follow{
    didSet{
      updateFollowState()
    }
  }
  override init(frame: CGRect){
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    layer.cornerRadius = 8
    titleLabel?.font = RecordyFont.button2.font
    updateFollowState()
  }
  private func updateFollowState(){
    switch followState{
    case .follow:
      backgroundColor = .white
      setTitleColor(CommonAsset.recordyGrey08.color, for: .normal)
    case .following:
      backgroundColor = CommonAsset.recordyGrey08.color
      setTitleColor(.white, for: .normal)
    }
  }
}
