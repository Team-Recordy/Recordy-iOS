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
      nicknameView.updateUI(state: currentState, errorMessage: (currentState == .error) ? errorMessage : nil)
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
      .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] text in
        guard let self = self else { return }
        self.validateNickname(text)
      }
      .store(in: &cancellables)
  }
  
  private func validateNickname(_ text: String) {
    guard !text.isEmpty else {
      currentState = .unselected
      return
    }
    
    if !text.isNicknamePatternValid(text) {
      currentState = .error
      errorMessage = "ⓘ 한글, 숫자, 밑줄 및 마침표만 사용할 수 있어요."
      nicknameView.nextButton.buttonState = .inactive
      return
    }
    
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.CheckNicknameRequest(nickname: text)
    
    apiProvider.requestResponsable(
      .checkNickname(request),
      DTO.CheckNicknameResponse.self
    ) { [weak self] result in
      guard let self = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          if response.errorCode == nil && response.errorMessage == nil {
            self.currentState = .selected
            self.nicknameView.nextButton.buttonState = .active
            self.userNickname = text
          } else {
            self.currentState = .error
            self.errorMessage = response.errorMessage ?? "ⓘ 이미 사용 중인 닉네임이에요."
            self.nicknameView.nextButton.buttonState = .inactive
          }
        case .failure:
          self.currentState = .error
          self.errorMessage = "ⓘ 닉네임 검증 중 오류가 발생했어요."
          self.nicknameView.nextButton.buttonState = .inactive
        }
      }
    }
  }
  
  @objc private func nextButtonTapped() {
    guard let userNickname else { return }
    let completeViewController = CompleteViewController(nickname: userNickname)
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
    return updatedText.count <= 10
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if nicknameView.nextButton.buttonState == .active {
      nextButtonTapped()
    }
    return true
  }
}
