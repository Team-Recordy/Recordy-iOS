//
//  AgreeToAllButton.swift
//  Common
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

public enum AgreeToAllButtonState {
  case agree
  case disagree
}

import UIKit

import SnapKit
import Then

public class AgreeToAllButton: UIButton {
  
  let agreeImageView = UIImageView()
  let agreeToAllLabel = UILabel()
  
  public var currentState: AgreeToAllButtonState = .disagree
  
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
    self.backgroundColor = CommonAsset.recordyGrey09.color
    self.cornerRadius(8)
    
    agreeToAllLabel.do {
      $0.text = "전체동의"
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    agreeImageView.do {
      $0.image = CommonAsset.deactivateCheck.image
    }
  }
  
  private func setUI() {
    self.addSubviews(agreeToAllLabel, agreeImageView)
  }
  
  private func setAutolayout() {
    self.agreeImageView.snp.makeConstraints {
      $0.leading.equalTo(self.snp.leading).offset(20)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    self.agreeToAllLabel.snp.makeConstraints {
      $0.leading.equalTo(agreeImageView.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }
  }
  
  public func toggleState() {
    currentState = (currentState == .agree) ? .disagree : .agree
    print("Toggle State: \(currentState)")
    updateAgreeToggleButton()
  }
  
  public func updateAgreeToggleButton() {
    self.agreeImageView.image = (currentState == .agree) ? CommonAsset.activateCheck.image : CommonAsset.deactivateCheck.image
    print("Updated Image: \(String(describing: self.agreeImageView.image))")
  }
  
  public func updateState(_ state: AgreeToAllButtonState) {
    currentState = state
    updateAgreeToggleButton()
  }
}
