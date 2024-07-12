//
//  NicknameViewController.swift
//  Presentation
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

final class NicknameView: UIView {
  
  let nicknameText = UILabel()
  let nicknameTextField = RecordyTextField(placeholder: "EX) 레코디둥이들")
  let nextButton = RecordyButton()
  
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
    
    self.backgroundColor = CommonAsset.recordyBG.color
    
    nicknameText.do {
      $0.text = "당신의 첫 번째 기록,\n닉네임을 정해주세요"
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.recordyGrey01.color
      $0.numberOfLines = 0
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
    }
  }
  
  func setUI() {
    self.addSubviews(
      nicknameText,
      nicknameTextField,
      nextButton
    )
  }
  
  func setAutoLayout() {
    nicknameText.snp.makeConstraints {
      $0.top.equalToSuperview().offset(165)
      $0.leading.equalToSuperview().offset(20)
    }
    
    nicknameTextField.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(53.adaptiveHeight)
      $0.top.equalTo(nicknameText.snp.bottom).offset(30)
    }
    
    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }

    
  }
}


