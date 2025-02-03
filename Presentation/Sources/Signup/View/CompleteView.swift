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
  private var nicknameForText: String? {
    didSet {
      updateNicknameText()
    }
  }
  
  let completeImage = UIImageView()
  let upperCompleteText = UILabel()
  let lowerCompleteText = UILabel()
  let completeButton = RecordyButton()
  private let indicatorImage = UIImageView()
  
  public var getNickname: (() -> String)?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setNickname(_ nickname: String) {
    self.nicknameForText = nickname
  }
  
  private func updateNicknameText() {
    upperCompleteText.text = "\(nicknameForText ?? "Unknown")님,"
  }
  
  func setStyle() {
    backgroundColor = CommonAsset.viskitBG.color
    
    completeImage.do {
      $0.image = CommonAsset.viskitCheck.image
    }
    
    indicatorImage.do {
      $0.image = CommonAsset.thirdIndicator.image
    }
    
    upperCompleteText.do {
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.textAlignment = .center
      $0.numberOfLines = 0
    }
    
    lowerCompleteText.do {
      $0.text = "가입이 완료되었어요!"
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.textAlignment = .center
      $0.numberOfLines = 0
    }
    
    completeButton.do {
      $0.setTitle("확인", for: .normal)
    }
  }
  
  func setUI() {
    addSubviews(
      completeImage,
      upperCompleteText,
      lowerCompleteText,
      completeButton,
      indicatorImage
    )
  }
  
  func setAutoLayout() {
    completeImage.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(183)
      $0.width.equalTo(120.adaptiveWidth)
      $0.height.equalTo(120.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }
    
    upperCompleteText.snp.makeConstraints {
      $0.top.equalTo(completeImage.snp.bottom).offset(21)
      $0.centerX.equalToSuperview()
    }
    
    lowerCompleteText.snp.makeConstraints {
      $0.top.equalTo(upperCompleteText.snp.bottom).offset(5)
      $0.centerX.equalToSuperview()
    }
    
    completeButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }
    
    indicatorImage.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(completeButton.snp.top).offset(-14)
      $0.height.equalTo(26.adaptiveHeight)
    }
  }
}

