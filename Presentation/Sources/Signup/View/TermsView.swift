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
  
  let termText = UILabel()
  let agreeAllTermButton = AgreeAllTermButton()
  let serviceTermButton = RecordyTermButton()
  let infoTermButton = RecordyTermButton()
  let ageTermButton = RecordyTermButton()
  let serviceMoreButton = MoreButton(url: "https://bohyunnkim.notion.site/e5c0a49d73474331a21b1594736ee0df")
  let infoMoreButton = MoreButton(url: "https://bohyunnkim.notion.site/c2bdf3572df1495c92aedd0437158cf0?pvs=74")
  let nextButton = RecordyButton()
  let indicatorImage = UIImageView()
  
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
    backgroundColor = CommonAsset.viskitBG.color
    
    termText.do {
      $0.text = "비스킷 이용을 위해\n필수 약관에 동의해 주세요."
      $0.font = ViskitFont.title1.font
      $0.textColor = CommonAsset.recordyGrey01.color
      $0.numberOfLines = 0
      $0.setLineSpacing(lineHeightMultiple: 1.3)
    }
    
    serviceTermButton.do {
      $0.agreeLabel.text = "(필수) 서비스 이용약관 동의"
    }
    
    infoTermButton.do {
      $0.agreeLabel.text = "(필수) 개인정보 수집·이용 동의"
    }
    
    ageTermButton.do {
      $0.agreeLabel.text = "(필수) 만 14세 이상입니다"
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
      $0.buttonState = .inactive
    }
    
    indicatorImage.do {
      $0.image = CommonAsset.firstIndicator.image
    }
  }
  
  func setUI() {
    addSubviews(
      termText,
      agreeAllTermButton,
      serviceTermButton,
      infoTermButton,
      ageTermButton,
      serviceMoreButton,
      infoMoreButton,
      nextButton,
      indicatorImage
    )
  }
  
  func setAutoLayout() {
    termText.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(54)
      $0.leading.equalToSuperview().offset(20)
    }
    
    agreeAllTermButton.snp.makeConstraints {
      $0.top.equalTo(termText.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(54.adaptiveHeight)
    }
    
    serviceTermButton.snp.makeConstraints {
      $0.top.equalTo(agreeAllTermButton.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(serviceMoreButton.snp.leading).offset(-10)
      $0.height.equalTo(40.adaptiveHeight)
    }
    
    infoTermButton.snp.makeConstraints {
      $0.top.equalTo(serviceTermButton.snp.bottom)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(infoMoreButton.snp.leading).offset(-10)
      $0.height.equalTo(40.adaptiveHeight)
    }
    
    ageTermButton.snp.makeConstraints {
      $0.top.equalTo(infoTermButton.snp.bottom)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40.adaptiveHeight)
    }
    
    serviceMoreButton.snp.makeConstraints {
      $0.top.equalTo(agreeAllTermButton.snp.bottom).offset(17)
      $0.trailing.equalToSuperview().offset(-40)
      $0.width.equalTo(32.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    infoMoreButton.snp.makeConstraints {
      $0.top.equalTo(serviceMoreButton.snp.bottom).offset(22)
      $0.trailing.equalToSuperview().offset(-40)
      $0.width.equalTo(32.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54.adaptiveHeight)
    }
    
    indicatorImage.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(nextButton.snp.top).offset(-14)
      $0.height.equalTo(26.adaptiveHeight)
    }
  }
}
