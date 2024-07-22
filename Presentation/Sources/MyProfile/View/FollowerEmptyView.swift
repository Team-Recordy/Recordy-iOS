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
  private let noFollowerLabel = UIImageView()
  
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
      $0.image = CommonAsset.noFollowers.image
      $0.contentMode = .scaleAspectFit
    }
    
    noFollowerLabel.do {
      $0.image = CommonAsset.text.image
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
      $0.top.equalToSuperview().offset(226.adaptiveHeight)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(100.adaptiveWidth)
      $0.height.equalTo(100.adaptiveHeight)
    }
    
    self.noFollowerLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(18)
      $0.centerX.equalToSuperview()
    }
  }
}
