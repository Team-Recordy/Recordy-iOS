//
//  TermButton.swift
//  Common
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public enum ToggleButtonState {
  case activate
  case deactivate
}

public class RecordyTermButton: UIButton {
  
  public let agreeImageView = UIImageView()
  public let agreeLabel = UILabel()
  
  public var currentState: ToggleButtonState = .deactivate
  
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
    addSubviews(
      agreeImageView,
      agreeLabel
    )
  }
  
  private func setAutolayout() {
    agreeImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.width.height.equalTo(16)
      $0.centerY.equalToSuperview()
    }
    
    agreeLabel.snp.makeConstraints {
      $0.leading.equalTo(agreeImageView.snp.trailing).offset(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  public func updateState(_ state: ToggleButtonState) {
    currentState = state
    updateToggleButton()
  }
  
  private func updateToggleButton() {
    agreeImageView.image = (currentState == .activate) ? CommonAsset.activateCheck.image : CommonAsset.deactivateCheck.image
  }
}
