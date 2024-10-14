//
//  CompleteView.swift
//  Presentation
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class CompleteView: UIView {
  
  let gradientView = RecordyGradientView()
  let completeImage = UIImageView()
  let primaryCompleteText = UILabel()
  let secondaryCompleteText = UILabel()
  let completeButton = RecordyButton()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    completeImage.do {
      $0.image = CommonAsset.signupComplete.image
    }
    
    primaryCompleteText.do {
      $0.text = "회원가입이 완료되었어요!"
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    secondaryCompleteText.do {
      $0.text = "지금 영상을 둘러보고 나만의 공간 취향을 발견해 보세요"
      $0.font = RecordyFont.body2.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
    
    completeButton.do {
      $0.setTitle("완료", for: .normal)
    }
  }
  
  func setUI() {
    addSubviews(
      gradientView,
      completeImage,
      primaryCompleteText,
      secondaryCompleteText,
      completeButton
    )
  }
  
  func setAutoLayout() {
    gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
    }
    
    completeImage.snp.makeConstraints {
      $0.top.equalToSuperview().offset(294)
      $0.width.equalTo(100.adaptiveWidth)
      $0.height.equalTo(100.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }
    
    primaryCompleteText.snp.makeConstraints {
      $0.top.equalTo(completeImage.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    secondaryCompleteText.snp.makeConstraints {
      $0.top.equalTo(primaryCompleteText.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
    
    completeButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }
  }
}

