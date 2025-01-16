//
//  ProfileEditViewController.swift
//  Presentation
//
//  Created by 송여경 on 10/23/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

@available(iOS 16.0, *)
public final class ProfileEditViewController: UIViewController {
  
  private let profileEditView = ProfileEditView()
  private let currentNickname: String = "레코디"
  private let maxNicknameLength: Int = 10
  
  public override func loadView() {
    self.view = profileEditView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    profileEditView.setNickname(currentNickname)
    setUI()
  }
  
  private func setUI() {
    buttonAction()
    configureNavigationBar()
  }
  
  private func configureNavigationBar() {
    navigationItem.title = "프로필 수정"
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.tintColor = .white
      navigationBar.titleTextAttributes = [
        .foregroundColor: CommonAsset.viskitGray01.color,
        .font: ViskitFont.title3.font
      ]
    }
    navigationItem.backButtonTitle = ""
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
    
    profileEditView.profileImageView.addGestureRecognizer(tapGesture)
    
    profileEditView.nextButton.addTarget(
      self,
      action: #selector(nextButtonDidTap),
      for: .touchUpInside
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
  
  @available(iOS 16.0, *)
  @objc private func nextButtonDidTap() {
    let profileViewController = ProfileViewController()
    navigationController?.pushViewController(profileViewController, animated: true)
  }
  
  @objc private func profileImageViewDidTap() {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
      let selectImage = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
        
      }
      let deleteImage = UIAlertAction(title: "프로필 사진 삭제", style: .default) { [weak self] _ in
        
      }

      alert.addAction(selectImage)
      alert.addAction(deleteImage)
      
      present(alert, animated: true)
  }
}
