//
//  TermsView.swift
//  Presentation
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class TermsView: UIView {
  
  let gradientView = RecordyGradientView()
  let termImage = UIImageView()
  let termText = UILabel()
  
  let agreeToAllButton = AgreeToAllButton()
  let termButton1 = TermButton()
  let termButton2 = TermButton()
  let termButton3 = TermButton()
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
    
    termImage.do {
      $0.image = CommonAsset.signupImage.image
      $0.contentMode = .scaleAspectFit
    }
    termText.do {
      $0.text = "유영하러 오신 것을\n환영합니다!"
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.recordyGrey01.color
      $0.numberOfLines = 0
    }
    
    agreeToAllButton.do {
      $0.addTarget(self, action: #selector(agreeToAllButtonTapped), for: .touchUpInside)
    }
    
    termButton1.do {
      $0.agreeLabel.text = "(필수) 서비스 이용약관 동의"
      $0.addTarget(self, action: #selector(termButtonTapped), for: .touchUpInside)
    }
    
    termButton2.do {
      $0.agreeLabel.text = "(필수) 개인정보 수집·이용 동의"
      $0.addTarget(self, action: #selector(termButtonTapped), for: .touchUpInside)
    }
    
    termButton3.do {
      $0.agreeLabel.text = "(필수) 만 14세 이상입니다"
      $0.addTarget(self, action: #selector(termButtonTapped), for: .touchUpInside)
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
      $0.buttonState = .inactive
    }
  }
  
  func setUI() {
    self.addSubviews(
      gradientView,
      termImage,
      termText,
      agreeToAllButton,
      termButton1,
      termButton2,
      termButton3,
      nextButton
    )
  }
  
  func setAutoLayout() {
    gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
    }

    termImage.snp.makeConstraints {
      $0.top.equalToSuperview().offset(148)
      $0.leading.equalToSuperview().offset(20)
      $0.height.equalTo(92.adaptiveHeight)
      $0.width.equalTo(92.adaptiveWidth)
    }
    
    termText.snp.makeConstraints {
      $0.top.equalTo(termImage.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
    }
    
    agreeToAllButton.snp.makeConstraints {
      $0.top.equalTo(termText.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(48)
    }
    
    termButton1.snp.makeConstraints {
      $0.top.equalTo(agreeToAllButton.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(40)
    }
    
    termButton2.snp.makeConstraints {
      $0.top.equalTo(termButton1.snp.bottom)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(40)
    }
    
    termButton3.snp.makeConstraints {
      $0.top.equalTo(termButton2.snp.bottom)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(40)
    }
    
    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }
  }
  
  @objc private func agreeToAllButtonTapped(_ sender: AgreeToAllButton) {
    print("약관 동의 버튼 터치됨")
    sender.toggleState()
    print("약관 동의함")
    updateAllTermButtonsState(sender.currentState == .agree)
    updateNextButtonState()
  }
  
  @objc private func termButtonTapped(_ sender: TermButton) {
    print("약관 동의 버튼 터치됨")
    sender.toggleState()
    print("약관 동의함")
    updateAgreeToAllButtonState()
    updateNextButtonState()
  }
  
  private func updateAllTermButtonsState(_ isActive: Bool) {
    let state: TermButtonState = isActive ? .agree : .disagree
    termButton1.updateState(state)
    termButton2.updateState(state)
    termButton3.updateState(state)
  }
  
  private func updateAgreeToAllButtonState() {
    if termButton1.currentState == .agree && termButton2.currentState == .agree && termButton3.currentState == .agree {
      agreeToAllButton.currentState = .agree
    } else {
      agreeToAllButton.currentState = .disagree
    }
    agreeToAllButton.updateAgreeToggleButton()
  }
  
  private func updateNextButtonState() {
    let allTermsAgreed = termButton1.currentState == .agree && termButton2.currentState == .agree && termButton3.currentState == .agree
    nextButton.buttonState = allTermsAgreed ? .active : .inactive
    print("updatenextButtonState")
  }
  
  func areAllButtonsActive() -> Bool {
    return termButton1.currentState == .agree && termButton2.currentState == .agree && termButton3.currentState == .agree && nextButton.buttonState == .active
  }
}
