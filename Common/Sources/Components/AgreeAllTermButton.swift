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

import UIKit
import SnapKit
import Then

public class AgreeAllTermButton: RecordyTermButton {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    self.backgroundColor = CommonAsset.recordyGrey09.color
    self.layer.cornerRadius = 8
    
    agreeLabel.do {
      $0.text = "전체동의"
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
  }
  
  private func setAutolayout() {
    self.agreeImageView.snp.makeConstraints {
      $0.leading.equalTo(self.snp.leading).offset(20)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    self.agreeLabel.snp.makeConstraints {
      $0.leading.equalTo(agreeImageView.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }
  }
}
