//
//  ProfileEditViewController.swift
//  Presentation
//
//  Created by 송여경 on 10/23/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common
import Core

import Photos
import PhotosUI

protocol ProfileEditViewControllerDelegate: AnyObject {
  func didUpdateProfile(
    nickname: String,
    profileImageUrl: String
  )
}

@available(iOS 16.0, *)
public final class ProfileEditViewController: UIViewController, CustomImagePickerDelegate {
  
  weak var delegate: ProfileEditViewControllerDelegate?
  
  private let profileEditView = ProfileEditView()
  private let currentNickname: String
  private let maxNicknameLength: Int = 10
  private let currentProfileImage: String
  
  private var isNicknameChanged = false
  private var isProfileImageChanged = false
  private let id: Int
  
  init(
    id: Int,
    currentNickname: String,
    currentProfileImage: String
  ) {
    self.id = id
    self.currentNickname = currentNickname
    self.currentProfileImage = currentProfileImage
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    self.view = profileEditView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = CommonAsset.viskitBG.color
    profileEditView.nicknameEditTextField.text = currentNickname
    profileEditView.baseSetting()
    textFieldDidChange(profileEditView.nicknameEditTextField)
    setUI()
    
    hideKeyboard()
  }
  
  private func setUI() {
    buttonAction()
    configureNavigationBar()
    setupCustomBackButton()
    updateCompleteButtonState()
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
    
    if text.isEmpty || text == currentNickname {
      profileEditView.baseSetting()
      isNicknameChanged = false
    } else if !text.isNicknamePatternValid(text) {
      profileEditView.showErrorLabel(withMessage: "ⓘ 한글, 숫자, 밑줄 및 마침표만 사용할 수 있어요.")
      profileEditView.nicknameEditTextField.textColor = CommonAsset.recordyWhite.color
      isNicknameChanged = false
    } else { // TODO: 이미 사용중 인 것 추가하기
      profileEditView.showSuccessLabel()
      profileEditView.nicknameEditTextField.textColor = CommonAsset.recordyWhite.color
      isNicknameChanged = true
    }
    updateCompleteButtonState()
  }
  
  private func updateCompleteButtonState() {
    guard let newNickname = profileEditView.nicknameEditTextField.text else {
      return
    }
    let isEnabled = (isNicknameChanged && !newNickname.isEmpty &&
                     newNickname != currentNickname) || isProfileImageChanged
    profileEditView.updateButtonState(isEnabled: isEnabled)
  }
  
  @available(iOS 16.0, *)
  @objc private func nextButtonDidTap() {
    guard let newNickname = profileEditView.nicknameEditTextField.text else {
      return
    }
    navigationController?.popViewController(animated: true)
  }
  
  private func updateUserProfile(_ newNickname: String, _ newProfileImageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.EditUserInfoRequest(nickname: newNickname, profileImageUrl: newProfileImageUrl)
    
    apiProvider.justRequest(.editProfile(request)) { result in
      completion(result)
    }
  }
  
  @objc private func profileImageViewDidTap() {
    let alert = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .actionSheet
    )
    
    let selectImage = UIAlertAction(
      title: "앨범에서 선택",
      style: .default
    ) { [weak self] _ in
      self?.requestPhotoLibraryPermission()
    }
    
    let deleteImage = UIAlertAction(
      title: "프로필 사진 삭제",
      style: .destructive
    ) { [weak self] _ in
      guard let self = self else { return }
      self.profileEditView.profileImageView.image = CommonAsset.profileEdit.image
      self.isProfileImageChanged = true
      self.updateCompleteButtonState()
    }
    
    let cancel = UIAlertAction(
      title: "취소",
      style: .cancel,
      handler: nil
    )
    
    deleteImage.setValue(UIColor.systemRed, forKey: "titleTextColor")
    
    alert.addAction(selectImage)
    alert.addAction(deleteImage)
    alert.addAction(cancel)
    
    present(alert, animated: true)
  }
  
  private func requestPhotoLibraryPermission() {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    switch status {
    case .authorized, .limited:
      presentCustomImagePicker()
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        DispatchQueue.main.async {
          if status == .authorized || status == .limited {
            self.presentCustomImagePicker()
          } else {
            self.showPermissionDeniedAlert()
          }
        }
      }
    default:
      showPermissionDeniedAlert()
    }
  }
  
  private func presentCustomImagePicker() {
    let imagePickerVC = CustomImagePickerViewController()
    imagePickerVC.delegate = self
    navigationController?.pushViewController(imagePickerVC, animated: true)
  }
  
  private func showPermissionDeniedAlert() {
    let alertController = RecordyPopUpViewController(
      type: .uploadPermission,
      rightButtonAction: { [weak self] in
        self?.openSettings()
      }
    )
    alertController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    present(
      alertController,
      animated: true
    )
  }
  
  private func openSettings() {
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(
        settingsURL,
        options: [:],
        completionHandler: nil
      )
    }
  }
  
  public func didSelectedImage(_ image: UIImage) {
    profileEditView.profileImageView.image = image
    isProfileImageChanged = true
    updateCompleteButtonState()
  }
}

@available(iOS 16.0, *)
extension ProfileEditViewController: PHPickerViewControllerDelegate {
  public func picker(
    _ picker: PHPickerViewController,
    didFinishPicking results: [PHPickerResult]
  ) {
    picker.dismiss(animated: true)
    
    guard let result = results.first else { return }
    
    if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
      result.itemProvider.loadObject(ofClass: UIImage.self) {
        image,
        error in
        DispatchQueue.main.async {
          if let image = image as? UIImage {
            self.profileEditView.profileImageView.image = image
            self.isProfileImageChanged = true
            self.updateCompleteButtonState()
          }
        }
      }
    }
  }
}
