//
//  NicknameViewController.swift
//  Presentation
//
//  Created by Chandrala on 8/25/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Combine
import UIKit

import Common
import Core

@available(iOS 16.0, *)
public final class NicknameViewController: UIViewController {
  
  private var userNickname: String?
  private let nicknameView = NicknameView()
  private var cancellables = Set<AnyCancellable>()
  private let textSubject = PassthroughSubject<String, Never>()
  
  private var currentState: RecordyTextFieldState = .unselected {
    didSet {
      nicknameView.updateUI(state: currentState)
      nicknameView.nicknameTextField.updateTextFieldStyle(for: currentState)
    }
  }
  
  private var errorMessage: String?
  
  public override func loadView() {
    view = nicknameView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    bindTextField()
    
    nicknameView.nicknameTextField.delegate = self
  }
  
  private func setStyle() {
    title = "닉네임 설정"
    setupCustomBackButton()
    
    nicknameView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
  }
  
  private func bindTextField() {
    nicknameView.nicknameTextField.textPublisher
      .sink { [weak self] text in
        guard let self = self else { return }
        let count = text.count
        self.nicknameView.textFieldCountLabel.text = "\(count) / 10"
      }
      .store(in: &cancellables)
    
    nicknameView.nicknameTextField.textPublisher
      .removeDuplicates()
      .sink { [weak self] text in
        guard let self = self else { return }
        self.updateState(for: text)
      }
      .store(in: &cancellables)
  }
  
  private func updateState(for text: String?) {
    guard let text = text, !text.isEmpty else {
      currentState = .valid
      return
    }
    
    if text.isNicknamePatternValid(text) {
      checkNickname(text: text)
    } else {
      currentState = .invalidPattern
    }
  }
  
  private func checkNickname(text: String) {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.CheckNicknameRequest(nickname: text)
    
    apiProvider.request(
      .checkNickname(request)
    ) { [weak self] result in
      guard let self = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          if response.statusCode == 200 {
            self.currentState = .valid
            self.userNickname = text
          }
        case .failure(let error):
          if let response = error.response {
            if response.statusCode == 409 {
              self.currentState = .duplicated
            }
          } else {
            self.currentState = .error
          }
        }
      }
    }
  }
  
  @objc private func nextButtonTapped() {
    if currentState == .valid {
      guard let userNickname else { return }
      nicknameView.isHidden = true
      let completeViewController = CompleteViewController(nickname: userNickname)
      self.navigationController?.pushViewController(completeViewController, animated: true)
    }
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
    return updatedText.count <= 10
  }
  
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    if let textField = textField as? RecordyTextField {
      textField.placeholder = nil
      self.currentState = .selected
    }
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text?.isEmpty ?? true {
      textField.placeholder = "닉네임 (한글, 숫자, 밑줄 및 마침표만 사용 가능)"
    } else if currentState == .valid {
      nicknameView.nextButton.buttonState = .active
    } else {
      self.currentState = .unselected
    }
  }
}
