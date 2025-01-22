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

  let viskitLogo = UIImageView().then {
    $0.image = CommonAsset.viskitLogo.image
    $0.contentMode = .scaleAspectFit
  }
  
  let projectIntro = UITextField().then {
    $0.text = "내가 찾던 공간을 먼저 만나는 곳"
    $0.font = ViskitFont.body1.font
    $0.textColor = CommonAsset.viskitWhite.color
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
    backgroundColor = CommonAsset.viskitBG.color
    kakaoLoginButton.cornerRadius(10)
    appleLoginButton.cornerRadius(10)
    
    self.bringSubviewToFront(kakaoLoginButton)
    self.bringSubviewToFront(appleLoginButton)
  }
  
  func setUI() {
    self.addSubviews(
      viskitLogo,
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
    
    kakaoLoginButton.isUserInteractionEnabled = true
    appleLoginButton.isUserInteractionEnabled = true
  }
  
  func setAutoLayout() {

    self.kakaoLogo.snp.makeConstraints {
      $0.width.height.equalTo(24)
    }
    
    self.appleLogo.snp.makeConstraints {
      $0.width.height.equalTo(24)
    }
    
    self.viskitLogo.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(308)
      $0.width.equalTo(200.adaptiveWidth)
      $0.height.equalTo(61.adaptiveHeight)
    }
    
    self.projectIntro.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(viskitLogo.snp.bottom).offset(24)
    }

    self.kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(projectIntro.snp.bottom).offset(149)
      $0.height.equalTo(54.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    self.kakaoStackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.appleLoginButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(8)
      $0.height.equalTo(54.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    self.appleStackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
