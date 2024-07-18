//
//  RecordyPopUpView.swift
//  Common
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then


public class RecordyPopUpView: UIView {
  public let popUpType: RecordyPopUpType
  private let image = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let leftButton = UIButton()
  public let rightButton = UIButton()
  
  public init(type: RecordyPopUpType) {
    self.popUpType = type
    super.init(frame: .zero)
    self.backgroundColor = CommonAsset.recordyGrey08.color
    self.layer.cornerRadius = 20
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  private func setStyle() {
    image.do {
      $0.image = popUpType.image
    }
    
    titleLabel.do {
      $0.text = popUpType.title
      $0.font = popUpType.titleFont
      $0.textAlignment = .center
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    subtitleLabel.do {
      $0.text = popUpType.subtitle
      $0.font = popUpType.subtitleFont
      $0.textAlignment = .center
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    leftButton.do {
      $0.setTitle("취소", for: .normal)
      $0.backgroundColor = popUpType.closeButtonBackgroundColor
      $0.setTitleColor(popUpType.closeButtonTitleColor, for: .normal)
      $0.titleLabel?.font = popUpType.buttonFont
      $0.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
      $0.cornerRadius(8)
    }
    
    rightButton.do {
      $0.setTitle(popUpType.buttonTitle, for: .normal)
      $0.backgroundColor = popUpType.buttonBackgroundColor
      $0.setTitleColor(popUpType.buttonTitleColor, for: .normal)
      $0.titleLabel?.font = popUpType.buttonFont
      $0.cornerRadius(8)
      
      //      $0.addTarget(self, action: #selector(rightButtonTapped), for: .normal)
    }
    
  }
  
  private func setUI() {
    self.addSubviews(image, titleLabel, subtitleLabel, leftButton, rightButton)
  }
  
  private func setAutoLayout() {
    self.snp.makeConstraints {
      $0.width.equalTo(298.adaptiveWidth)
      $0.height.equalTo(252.adaptiveHeight)
    }
    
    image.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(113)
      $0.width.height.equalTo(72)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(image.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(6)
      $0.centerX.equalToSuperview()
    }
    
    leftButton.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(18)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().inset(153)
      $0.height.equalTo(44.adaptiveHeight)
      $0.width.equalTo(125.adaptiveWidth)
    }
    
    rightButton.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(18)
      $0.leading.equalTo(leftButton.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(44.adaptiveHeight)
      $0.width.equalTo(125.adaptiveWidth)
    }
    
  }
  
  @objc public func leftButtonTapped() {
    self.isHidden = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
