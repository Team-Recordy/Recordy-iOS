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
  let agreeAllTermButton = AgreeAllTermButton()
  let termButton1 = RecordyTermButton()
  let termButton2 = RecordyTermButton()
  let termButton3 = RecordyTermButton()
  let moreButton1 = MoreButton(url: "https://bohyunnkim.notion.site/e5c0a49d73474331a21b1594736ee0df")
  let moreButton2 = MoreButton(url: "https://bohyunnkim.notion.site/c2bdf3572df1495c92aedd0437158cf0?pvs=74")
  let moreButton3 = MoreButton(url: "https://bohyunnkim.notion.site/98d0fa7eac84431ab6f6dd63be0fb8ff?pvs=74")
  let nextButton = RecordyButton()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setStyle()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    backgroundColor = CommonAsset.recordyBG.color
    
    termImage.do {
      $0.image = CommonAsset.signupImage.image
      $0.contentMode = .scaleAspectFit
    }
    
    termText.do {
      $0.text = "유영하러 오신 것을\n환영합니다!"
      $0.font = RecordyFont.title1.font
      $0.textColor = CommonAsset.recordyGrey01.color
      $0.numberOfLines = 0
      $0.setLineSpacing(lineHeightMultiple: 1.3)
    }
    
    termButton1.do {
      $0.agreeLabel.text = "(필수) 서비스 이용약관 동의"
    }
    
    termButton2.do {
      $0.agreeLabel.text = "(필수) 개인정보 수집·이용 동의"
    }
    
    termButton3.do {
      $0.agreeLabel.text = "(필수) 만 14세 이상입니다"
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
      $0.buttonState = .inactive
    }
  }
  
  func setUI() {
    addSubviews(
      gradientView,
      termImage,
      termText,
      agreeAllTermButton,
      termButton1,
      termButton2,
      termButton3,
      moreButton1,
      moreButton2,
      moreButton3,
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
    
    agreeAllTermButton.snp.makeConstraints {
      $0.top.equalTo(termText.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(48)
    }
    
    termButton1.snp.makeConstraints {
      $0.top.equalTo(agreeAllTermButton.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(moreButton1.snp.leading).offset(-10)
      $0.height.equalTo(40)
    }
    
    termButton2.snp.makeConstraints {
      $0.top.equalTo(termButton1.snp.bottom)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(moreButton2.snp.leading).offset(-10)
      $0.height.equalTo(40)
    }
    
    termButton3.snp.makeConstraints {
      $0.top.equalTo(termButton2.snp.bottom)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(moreButton3.snp.leading).offset(-10)
      $0.height.equalTo(40)
    }
    
    moreButton1.snp.makeConstraints {
      $0.top.equalTo(agreeAllTermButton.snp.bottom).offset(17)
      $0.trailing.equalToSuperview().offset(-40)
      $0.width.equalTo(32.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    moreButton2.snp.makeConstraints {
      $0.top.equalTo(moreButton1.snp.bottom).offset(22)
      $0.trailing.equalToSuperview().offset(-40)
      $0.width.equalTo(32.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    moreButton3.snp.makeConstraints {
      $0.top.equalTo(moreButton2.snp.bottom).offset(22)
      $0.trailing.equalToSuperview().offset(-40)
      $0.width.equalTo(32.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }
  }
}
