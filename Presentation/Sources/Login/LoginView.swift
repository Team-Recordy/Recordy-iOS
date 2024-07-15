//
//  LoginView.swift
//  Common
//
//  Created by Chandrala on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class LoginView: UIView {
  
  let recordyLogo = UIView().then {
    $0.backgroundColor = CommonAsset.recordyMain.color
  }
  
  let projectIntro = UITextField().then {
    $0.text = "내 취향의 공간 기록을 발견하는 곳"
    $0.font = RecordyFont.body1.font
    $0.textColor = CommonAsset.recordyGrey01.color
  }
  
  let kakaoStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.spacing = 4
  }
  
  let appleStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.spacing = 4
  }
  
  let kakaoLogo = UIImageView().then {
    $0.image = CommonAsset.kakaoLogo.image
  }
  
  let appleLogo = UIImageView().then {
    $0.image = CommonAsset.appleLogo.image
  }
  
  let kakaoButtonText = UILabel().then {
    $0.text = "카카오로 시작하기"
    $0.font = RecordyFont.button2.font
    $0.textColor = CommonAsset.recordyBG.color
    $0.numberOfLines = 1
    $0.adjustsFontSizeToFitWidth = true
  }
  
  let appleButtonText = UILabel().then {
    $0.text = "Apple로 시작하기"
    $0.font = RecordyFont.button2.font
    $0.textColor = CommonAsset.recordyBG.color
    $0.numberOfLines = 1
    $0.adjustsFontSizeToFitWidth = true
  }
  
  let kakaoLoginButton = UIButton().then() {
    $0.backgroundColor = CommonAsset.recordyKakao.color
  }
  
  let appleLoginButton = UIButton().then() {
    $0.backgroundColor = CommonAsset.recordyWhite.color
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // TODO: Change BackgroundColor to Gradient
  func setStyle() {
    kakaoLoginButton.cornerRadius(10)
    appleLoginButton.cornerRadius(10)
  }
  
  func setUI() {
    self.addSubviews(
      recordyLogo,
      projectIntro,
      kakaoLoginButton,
      appleLoginButton
    )
    kakaoStackView.addArrangedSubview(kakaoLogo)
    kakaoStackView.addArrangedSubview(kakaoButtonText)
    kakaoLoginButton.addSubview(kakaoStackView)
    appleStackView.addArrangedSubview(appleLogo)
    appleStackView.addArrangedSubview(appleButtonText)
    appleLoginButton.addSubview(appleStackView)
  }
  
  func setAutoLayout() {
    self.kakaoLogo.snp.makeConstraints {
      $0.width.height.equalTo(24)
    }
    
    self.appleLogo.snp.makeConstraints {
      $0.width.height.equalTo(24)
    }
    
    self.recordyLogo.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(274)
      $0.width.height.equalTo(120)
    }
    
    self.projectIntro.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(recordyLogo.snp.bottom).offset(24)
    }
    
    self.kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(projectIntro.snp.bottom).offset(152)
      $0.height.equalTo(48)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    self.kakaoStackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.appleLoginButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    self.appleStackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
