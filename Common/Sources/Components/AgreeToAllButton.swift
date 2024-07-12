//
//  AgreeToAllButton.swift
//  Common
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public class AgreeToAllButton: UIButton {
  
  let backgroundView = UIView()
  let agreeButton = AgreeToggleButton()
  let agreeToAllLabel = UILabel()
  
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
    // backgroundView를 StackView 같이 사용
    backgroundView.backgroundColor = CommonAsset.recordyGrey09.color
    self.cornerRadius(8)
    
    agreeToAllLabel.do {
      $0.text = "전체동의"
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
  }
  
  private func setUI() {
    self.addSubviews(backgroundView, agreeButton, agreeToAllLabel)
  }
  
  private func setAutolayout() {
    self.backgroundView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.bottom.equalTo(self.snp.bottom)
      $0.leading.equalTo(self.snp.leading)
      $0.trailing.equalTo(self.snp.trailing)
    }
    
    self.agreeButton.snp.makeConstraints {
      $0.leading.equalTo(self.snp.leading).offset(20)
      $0.verticalEdges.equalToSuperview().inset(12)
      $0.width.equalTo(24)
    }
    
    self.agreeToAllLabel.snp.makeConstraints {
      $0.leading.equalTo(self.agreeButton.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }
    
    self.agreeButton.checkImageView.snp.makeConstraints {
      $0.width.equalTo(24.adaptiveWidth)
      $0.height.equalTo(24.adaptiveHeight)
    }
  }
}
