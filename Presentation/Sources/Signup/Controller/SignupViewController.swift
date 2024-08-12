//
//  SignupViewController.swift
//  Presentation
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//


import UIKit

import Core
import Common

import SnapKit

@available(iOS 16.0, *)
public final class SignupViewController: UIViewController {
  
  var rootView: UIView = UIView()
  let totalPages = 3
  var currentPage = 0
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "회원가입"
    showTermsView()
    SignupView().progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    self.hideKeyboard()
  }
  
  func switchView(_ newView: UIView) {
    rootView.removeFromSuperview()
    view.addSubview(newView)
    newView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    rootView = newView
    view.addSubview(SignupView().progressView)
    SignupView().progressView.snp.remakeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(6)
    }
  }
  
  func showTermsView() {
    let termsView = TermsView()
    termsView.nextButton.addTarget(
      self,
      action: #selector(showNicknameView),
      for: .touchUpInside
    )
    switchView(termsView)
  }
  
  @objc
  func showNicknameView() {
    if let termsView = rootView as? TermsView, termsView.areAllButtonsActive() {
      currentPage += 1
      SignupView().progressView.updateProgress(
        currentPage: currentPage,
        totalPages: totalPages
      )
      NicknameView().nextButton.addTarget(
        self,
        action: #selector(showCompleteView),
        for: .touchUpInside
      )
      NicknameView().nicknameTextField.stateDelegate = self
      switchView(NicknameView())
    }
    
  }
  
  @objc
  func showCompleteView() {
    guard NicknameView().nextButton.buttonState == .active else { return }
    currentPage += 1
    SignupView().progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    let completeView = CompleteView()
    completeView.completeButton.buttonState = .active
    completeView.completeButton.addTarget(
      self,
      action: #selector(
        completeSignup
      ),
      for: .touchUpInside
    )
    switchView(completeView)
  }
  
  @objc
  func completeSignup() {
    guard let text = NicknameView().nicknameTextField.text else { return }
    let apiProvider = APIProvider<APITarget.Users>()
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let request = DTO.SignUpRequest(
      nickname: text,
      termsAgreement: DTO.SignUpRequest.TermsAgreement()
    )
    apiProvider.justRequest(.signUp(request)) { result in
      switch result {
      case .success:
        let tabBarController = RecordyTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: false)
      case .failure:
        print("실패 팝업")
      }
    }
  }
}

@available(iOS 16.0, *)
extension SignupViewController: RecordyTextFieldStateDelegate {
  public func state(_ currentState: Common.RecordyTextFieldState) {
    self.textFieldState = currentState
    nicknameView.state(currentState)
  }
}
