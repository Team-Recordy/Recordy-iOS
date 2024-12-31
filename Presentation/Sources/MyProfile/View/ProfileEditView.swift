//
//  ProfileEditView.swift
//  Presentation
//
//  Created by 송여경 on 12/23/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

import SnapKit
import Then

public final class ProfileEditView: UIView {
  private let profileImageView = UIImageView()
  private let cameraImageView = UIImageView()
  private let editTitle = UILabel()
  let nicknameEditTextField = UITextField()
  let nicknameCountLabel = UILabel()
  let errorLabel = UILabel()
  let successLabel = UILabel()
  let nextButton = UIButton()
  
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
    backgroundColor = CommonAsset.viskitBG.color
    
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
      $0.textColor = CommonAsset.viskitAlert01.color
      $0.font = ViskitFont.caption2Medium.font
      $0.isHidden = true
    }
    
    successLabel.do {
      $0.text = "사용 가능한 닉네임이에요!"
      $0.textColor = CommonAsset.viskitYellow80.color
      $0.font = ViskitFont.caption2Medium.font
      $0.isHidden = true
    }
    
    nextButton.do {
      $0.setTitle("완료", for: .normal)
      $0.backgroundColor = CommonAsset.viskitGray11.color
      $0.setTitleColor(
        CommonAsset.viskitGray08.color,
        for: .normal
      )
      $0.layer.cornerRadius = 12
      $0.isEnabled = false
      $0.titleLabel?.font = RecordyFont.button1.font //TODO: Viskit Button Font 적용 X 추 후 반영
    }
    
  }
  
  private func setUI() {
    addSubviews(profileImageView,
                cameraImageView,
                editTitle,
                nicknameEditTextField,
                nicknameCountLabel,
                errorLabel,
                successLabel,
                nextButton)
  }
  
  private func setAutoLayout() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(36)
      $0.centerX.equalToSuperview()
    }
    
    cameraImageView.snp.makeConstraints {
      $0.bottom.equalTo(profileImageView.snp.bottom).inset(6)
      $0.trailing.equalTo(profileImageView.snp.trailing).inset(6)
    }
    
    editTitle.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(24)
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
    
    successLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameEditTextField.snp.bottom).offset(8)
      $0.leading.equalTo(nicknameEditTextField.snp.leading)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(335.adaptiveWidth)
      $0.height.equalTo(54.adaptiveHeight)
    }
  }
}

extension ProfileEditView {
  public func updateButtonState(isEnabled: Bool) {
    nextButton.isEnabled = isEnabled
    nextButton.backgroundColor = isEnabled ? CommonAsset.viskitYellow400.color : CommonAsset.viskitGray11.color
    nextButton.titleLabel?.textColor = isEnabled ? CommonAsset.recordyBG.color : CommonAsset.viskitGray08.color
  }
  
  public func setNickname(_ nickname: String) {
      nicknameEditTextField.placeholder = nickname
  }
  
  public func updateTextFieldBorderColor(to color: UIColor?) {
    if let borderColor = color {
      nicknameEditTextField.layer.borderColor = borderColor.cgColor
      nicknameEditTextField.layer.borderWidth = 1
      nicknameEditTextField.layer.cornerRadius = 8
    } else {
      nicknameEditTextField.layer.borderWidth = 0
    }
  }
  
  public func showErrorLabel(withMessage message: String) {
    errorLabel.text = message
    errorLabel.isHidden = false
    successLabel.isHidden = true
    updateTextFieldBorderColor(to: CommonAsset.viskitAlert01.color)
  }
  
  public func showSuccessLabel() {
    successLabel.isHidden = false
    errorLabel.isHidden = true
    updateTextFieldBorderColor(to: CommonAsset.viskitYellow80.color)
  }
  
  public func baseSetting() {
    errorLabel.isHidden = true
    successLabel.isHidden = true
    updateTextFieldBorderColor(to: nil)
  }
}


