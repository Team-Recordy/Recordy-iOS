//
//  ProfileEditViewController.swift
//  Presentation
//
//  Created by 송여경 on 10/23/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

import Then

public final class ProfileEditViewController: UIViewController {
  
  private let profileEditView = ProfileEditView()
  private let currentNickname: String = "레코디"
  private let maxNicknameLength: Int = 10
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view = profileEditView
    profileEditView.setNickname(currentNickname)
    buttonAction()
  }
  
  private func buttonAction() {
    profileEditView.nicknameEditTextField.addTarget(
      self,
      action: #selector(textFieldDidChange),
      for: .editingChanged
    )
    
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(profileImageViewDidTap)
    )
  }
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
    
    guard let text = textField.text else { return }
    profileEditView.nicknameCountLabel.text = "\(text.count) / \(maxNicknameLength)"
    
    if text.count > maxNicknameLength {
      textField.text = String(text.prefix(maxNicknameLength))
      profileEditView.nicknameCountLabel.text = "\(maxNicknameLength) / \(maxNicknameLength)"
    }
    
    if text.isEmpty {
      profileEditView.baseSetting()
      profileEditView.updateButtonState(isEnabled: false)
      return
    }
    
    if !text.isNicknamePatternValid(text) {
      profileEditView.showErrorLabel(withMessage: "ⓘ 한글, 숫자, 밑줄 및 마침표만 사용할 수 있어요.")
      profileEditView.updateButtonState(isEnabled: false)
      return
    }
    
    if text == currentNickname {
      profileEditView.showErrorLabel(withMessage: "ⓘ 이미 사용 중인 닉네임이에요.")
      profileEditView.updateButtonState(isEnabled: false)
      
      return
    } //TODO: Server에서 존재하는 닉네임인지 확인 요청 필요, 우선은 currentNickname으로 확인
    
    profileEditView.showSuccessLabel()
    profileEditView.updateButtonState(isEnabled: true)
    
  }
  
  @objc private func profileImageViewDidTap() {
    //TODO: 프로필 이미지 선택 (추 후 구현)
  }
  
}
