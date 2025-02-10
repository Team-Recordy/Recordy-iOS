//
//  FollowerEmptyView.swift
//  Presentation
//
//  Created by 송여경 on 7/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
//setStyle() -> setUI() -> setAutolayout()

import UIKit

import SnapKit
import Then

import Common

public final class FollowerEmptyView: UIView {
  
  private let emptyImage = UIImageView()
  private let noFollowerLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    emptyImage.do {
      $0.image = CommonAsset.ledyEmpty2.image
      $0.contentMode = .scaleAspectFit
    }
    
    noFollowerLabel.do {
      $0.text = "아직 팔로워가 없어요."
      $0.font = ViskitFont.title2.font
      $0.textColor = CommonAsset.viskitGray02.color
    }
  }
  
  private func setUI() {
    self.addSubviews(
      emptyImage,
      noFollowerLabel
    )
  }
  
  private func setAutolayout() {
    self.emptyImage.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    self.noFollowerLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(14)
      $0.centerX.equalToSuperview()
    }
  }
}
