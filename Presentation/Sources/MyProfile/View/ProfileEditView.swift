//
//  ProfileEditView.swift
//  Presentation
//
//  Created by 송여경 on 12/23/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class ProfileEditView: UIView {
  private let profileImageView = UIImageView()
  private let cameraImageView = UIImageView()
  private let editTitle = UILabel()
  private let nicknameEditTextField = UITextField()
  private let nicknameCountLabel = UILabel()
  private let errorLabel = UILabel()
  private let nextButton = UIButton()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    backgroundColor = CommonAsset.recordyBG.color
    //TODO: viskitBG 없어서 추 후 대치 필요
    
    profileImageView.do {
      $0.image = CommonAsset.profileEdit.image
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = 120/2
      $0.clipsToBounds = true
      $0.isUserInteractionEnabled = true
    }
    
    cameraImageView.do {
      $0.image = CommonAsset.camera.image
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = 24/2
      $0.clipsToBounds = true
    }
    
    editTitle.do {
      $0.text = "닉네임 수정"
      $0.font = ViskitFont.title4.font
      $0.textColor = CommonAsset.viskitGray01.color
    }
    
    nicknameEditTextField.do {
      $0.placeholder = "닉네임 입력"
      $0.font = ViskitFont.body2.font
      $0.borderStyle = .roundedRect
      $0.clearButtonMode = .whileEditing
    }
    
    nicknameCountLabel.do {
      $0.text = "0 / 10"
      $0.textColor = CommonAsset.viskitGray06.color
      $0.font = ViskitFont.caption2Medium.font
    }
    
    errorLabel.do {
      $0.text = "ⓘ 이미 사용 중인 닉네임이에요."
      $0.textColor = CommonAsset.recordyAlert.color //TODO: Viskit Alert01 Color 존재 X 추 후 수정
      $0.font = ViskitFont.caption2Medium.font
    }
    
    nextButton.do {
      $0.setTitle("다음", for: .normal)
      $0.backgroundColor = CommonAsset.viskitGray11.color
      $0.setTitleColor(
        CommonAsset.viskitGray08.color,
        for: .normal
      )
      $0.layer.cornerRadius = 12
      $0.isEnabled = false
    }
    
  }
  
  private func setUI() {
    addSubviews(profileImageView,
                cameraImageView,
                editTitle,
                nicknameEditTextField,
                nicknameCountLabel,
                errorLabel,
                nextButton)
  }
  
  private func setAutoLayout() {
    
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(36)
      $0.centerX.equalToSuperview()
    }
    
    cameraImageView.snp.makeConstraints {
      $0.bottom.equalTo(profileImageView.snp.bottom).inset(6)
      $0.trailing.equalTo(profileImageView.snp.trailing).inset(6)
    }
    
    editTitle.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180)
      $0.leading.equalToSuperview().offset(20)
    }
    
    nicknameEditTextField.snp.makeConstraints {
      $0.top.equalTo(editTitle.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(335.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }
    
    nicknameCountLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameEditTextField.snp.bottom).offset(8)
      $0.trailing.equalTo(nicknameEditTextField.snp.trailing)
    }
    
    errorLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameEditTextField.snp.bottom).offset(8)
      $0.leading.equalTo(nicknameEditTextField.snp.leading)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(44)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(335.adaptiveWidth)
      $0.height.equalTo(54.adaptiveHeight)
    }
  }
}
