//
//  TermButton.swift
//  Common
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

public enum TermButtonState {
  case agree
  case disagree
}


import UIKit

import SnapKit
import Then

public class TermButton: UIButton {
  
  public let agreeImageView = UIImageView()
  public let agreeLabel = UILabel()
  
  public var currentState: TermButtonState = .disagree
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    agreeImageView.do {
      $0.image = CommonAsset.deactivateCheck.image
    }
    
    agreeLabel.do {
      $0.font = RecordyFont.caption1.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
  }
  
  private func setUI() {
    self.addSubviews(
      agreeImageView,
      agreeLabel
    )
  }
  
  private func setAutolayout() {
    self.agreeImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.width.height.equalTo(16)
      $0.centerY.equalToSuperview()
    }
    
    self.agreeLabel.snp.makeConstraints {
      $0.leading.equalTo(agreeImageView.snp.trailing).offset(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  public func toggleState() {
    currentState = (currentState == .agree) ? .disagree : .agree
    updateAgreeToggleButton()
  }
  
  public func updateAgreeToggleButton() {
    self.agreeImageView.image = (currentState == .agree) ? CommonAsset.activateCheck.image : CommonAsset.deactivateCheck.image
  }
  
  public func updateState(_ state: TermButtonState) {
    currentState = state
    updateAgreeToggleButton()
  }
}

