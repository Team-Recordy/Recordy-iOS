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
  let completeText = UILabel()
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
    completeText.text = "\(nicknameForText ?? "Unknown")님,\n가입이 완료되었어요!"
  }
  
  func setStyle() {
    completeImage.do {
      $0.image = CommonAsset.viskitCheck.image
    }
    
    indicatorImage.do {
      $0.image = CommonAsset.thirdIndicator.image
    }
    
    completeText.do {
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.textAlignment = .center
      $0.numberOfLines = 0
      $0.setLineSpacing(lineHeightMultiple: 1.3)
    }
    
    completeButton.do {
      $0.setTitle("완료", for: .normal)
    }
  }
  
  func setUI() {
    addSubviews(
      completeImage,
      completeText,
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
    
    completeText.snp.makeConstraints {
      $0.top.equalTo(completeImage.snp.bottom).offset(21)
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

