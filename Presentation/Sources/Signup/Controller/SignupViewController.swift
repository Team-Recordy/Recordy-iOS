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

  let totalPages = 3
  var currentPage = 0
  
  var rootView: UIView = UIView()
  let signupView = SignupView()
  let termsView = TermsView()
  let nicknameView = NicknameView()
  let completeView = CompleteView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    showTermsView()
    signupView.progressView.updateProgress(
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
    
    view.addSubview(signupView.progressView)
    signupView.progressView.snp.remakeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(6)
    }
  }
  
  @objc
  func showTermsView() {
    termsView.nextButton.addTarget(
      self,
      action: #selector(showNicknameView),
      for: .touchUpInside
    )
    self.title = "이용 약관"
    switchView(termsView)
  }
  
  @objc
  func showNicknameView() {
    if let termsView = rootView as? TermsView, termsView.areAllButtonsActive() {
      currentPage += 1
      signupView.progressView.updateProgress(
        currentPage: currentPage,
        totalPages: totalPages
      )
      nicknameView.nextButton.addTarget(
        self,
        action: #selector(showCompleteView),
        for: .touchUpInside
      )
      self.title = "닉네임 설정"
      switchView(nicknameView)
    }
  }
  
  @objc
  func showCompleteView() {
    guard nicknameView.nextButton.buttonState == .active else { return }
    currentPage += 1
    signupView.progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    completeView.completeButton.buttonState = .active
    completeView.completeButton.addTarget(
      self,
      action: #selector(completeSignup),
      for: .touchUpInside
    )
    self.title = "회원가입 완료"
    switchView(completeView)
  }
  
  @objc
  func completeSignup() {
    guard let text = nicknameView.nicknameTextField.text else { return }
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
        print("failed to login")
      }
    }
  }
}
