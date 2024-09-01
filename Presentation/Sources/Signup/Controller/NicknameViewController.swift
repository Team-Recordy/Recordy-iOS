//
//  NicknameViewController.swift
//  Presentation
//
//  Created by Chandrala on 8/25/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

@available(iOS 16.0, *)
public final class NicknameViewController: UIViewController {
  
  private let nicknameView = NicknameView()
  private var errorMessage: String?
  
  private var currentState: RecordyTextFieldState = .unselected {
    didSet {
      nicknameView.nicknameTextField.updateTextFieldStyle(for: currentState)
      updateUI(for: currentState)
    }
  }
  
  public override func loadView() {
    self.view = nicknameView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    setTapGesture()
  }
  
  private func isNicknamePatternValid(_ nickname: String) -> Bool {
    let pattern = "^[가-힣0-9._]{1,10}$"
    return nickname.matches(pattern: pattern)
  }
  
  private func getNicknameRequest(completion: @escaping (Bool) -> Void) {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.CheckNicknameRequest(nickname: nicknameView.nicknameTextField.text!)
    apiProvider.justRequest(.checkNickname(request)) { result in
      switch result {
      case .success:
        completion(true)
      case .failure:
        completion(false)
      }
    }
  }
  
  private func bind() {
    nicknameView.nicknameTextField.delegate = self
    nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
  }
  
  private func updateTextFieldState(_ text: String) {
    if text.isEmpty {
      currentState = .unselected
    } else if isNicknamePatternValid(text) {
      getNicknameRequest { [weak self] isAvailable in
        guard let self = self else { return }
        if isAvailable {
          self.currentState = .selected
        } else {
          self.errorMessage = "이미 사용 중인 닉네임입니다."
          self.currentState = .error
        }
      }
    } else {
      self.errorMessage = "닉네임은 한글, 숫자, 밑줄, 마침표만 사용할 수 있습니다."
      self.currentState = .error
    }  }
  
  private func updateUI(for state: RecordyTextFieldState) {
    switch state {
    case .selected:
      nicknameView.errorLabel.text = "사용 가능한 닉네임입니다."
      nicknameView.errorLabel.textColor = CommonAsset.recordyMain.color
      nicknameView.nextButton.buttonState = .active
      
    case .error:
      nicknameView.errorLabel.text = errorMessage
      nicknameView.errorLabel.textColor = CommonAsset.recordyAlert.color
      nicknameView.nextButton.buttonState = .inactive
      
    case .unselected:
      nicknameView.errorLabel.text = ""
      nicknameView.nextButton.buttonState = .inactive
    }
  }
  
  private func setTapGesture() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(
        dismissKeyboard
      )
    )
    view.addGestureRecognizer(tapGesture)
  }
  
  private func nextButtonTapped() {
    let completeViewController = CompleteViewController()
        self.navigationController?.pushViewController(completeViewController, animated: true)
  }
}

@available(iOS 16.0, *)
extension NicknameViewController: UITextFieldDelegate {
  @objc public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else {
      return false
    }
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    updateTextFieldState(updatedText)
    
    return updatedText.count <= 10
  }
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
    updateTextFieldState(textField.text ?? "")
  }
  
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if nicknameView.nextButton.buttonState == .active {
      nextButtonTapped()
    }
    
    return true
  }
  
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    updateTextFieldState(textField.text ?? "")
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    updateTextFieldState(textField.text ?? "")
  }
}
