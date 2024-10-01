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
      nicknameView.updateUI(state: currentState, errorMessage: (currentState == .error) ? errorMessage : nil)
    }
  }
  
  public override func loadView() {
    view = nicknameView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setDelegate()
  }
  
  func setStyle() {
    nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    nicknameView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    setTapGesture()
  }
  
  private func setDelegate() {
    nicknameView.nicknameTextField.delegate = self
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
  
  private func updateTextFieldState(_ text: String) {
    if text.isEmpty {
      currentState = .unselected
    } else if isNicknamePatternValid(text) {
      getNicknameRequest { [weak self] isAvailable in
        guard let self = self else { return }
        if isAvailable {
          currentState = .selected
          nicknameView.nextButton.buttonState = .active
        } else {
          currentState = .error
          errorMessage = "ⓘ 이미 사용 중인 닉네임이에요."
          nicknameView.nextButton.buttonState = .inactive
        }
      }
    } else {
      currentState = .error
      errorMessage = "ⓘ 한글, 숫자, 밑줄 및 마침표만 사용할 수 있어요."
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
    addGestureRecognizer(tapGesture)
  }
  
  @objc private func nextButtonTapped() {
    let completeViewController = CompleteViewController()
    navigationController?.pushViewController(completeViewController, animated: true)
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
