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

public class TermButton: UIButton {
  
  let backgroundView = UIView()
  let agreeButton = AgreeToggleButton()
  public let agreeLabel = UILabel()
  let moreButton = MoreButton()
  
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
    backgroundView.backgroundColor = .clear
    agreeLabel.do {
      $0.font = RecordyFont.caption1.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
  }
  
  private func setUI() {
    self.addSubviews(
      backgroundView,
      agreeButton,
      agreeLabel,
      moreButton
    )
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
    
    self.agreeLabel.snp.makeConstraints {
      $0.leading.equalTo(self.agreeButton.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }
    
    self.agreeButton.checkImageView.snp.makeConstraints {
      $0.width.equalTo(16.adaptiveWidth)
      $0.height.equalTo(16.adaptiveHeight)
    }
    
    self.moreButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.verticalEdges.equalToSuperview().inset(5)
      $0.width.equalTo(50.adaptiveWidth)
    }
  }
}

