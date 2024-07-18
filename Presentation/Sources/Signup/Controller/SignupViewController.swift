//
//  SignupViewController.swift
//  Presentation
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//


import UIKit
import Common

public final class SignupViewController: UIViewController {
  
  var rootView: UIView = UIView()
  let progressView = RecordyProgressView()
  let totalPages = 3
  var currentPage = 0
  var textFieldState: RecordyTextFieldState = .unselected
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setAutoLayout()
    showTermsView()
    progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    self.hideKeyboard()
  }
  
  func setUI() {
    view.addSubview(progressView)
  }
  
  func setAutoLayout() {
    progressView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(6.adaptiveHeight)
    }
  }
  
  func showTermsView() {
    let termsView = TermsView()
    termsView.nextButton.addTarget(
      self,
      action: #selector(checkAndShowNicknameView),
      for: .touchUpInside
    )
    switchView(termsView)
  }
  
  @objc
  func checkAndShowNicknameView() {
    guard let termsView = rootView as? TermsView, termsView.areAllButtonsActive() else { return }
    showNicknameView()
  }
  
  @objc
  func showNicknameView() {
    currentPage += 1
    progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    let nicknameView = NicknameView()
    nicknameView.nextButton.addTarget(
      self,
      action: #selector(showCompleteView),
      for: .touchUpInside
    )
    switchView(nicknameView)
  }
  
  @objc
  func showCompleteView() {
    currentPage += 1
    progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    let completeView = CompleteView()
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
    // 추가구현
  }
  
  func switchView(_ newView: UIView) {
    rootView.removeFromSuperview()
    view.addSubview(newView)
    newView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    rootView = newView
    view.addSubview(progressView)
    progressView.snp.remakeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(6)
    }
  }
}

extension SignupViewController: RecordyTextFieldStateDelegate {
  public func state(_ currentState: Common.RecordyTextFieldState) {
    self.textFieldState = currentState
  }
}
