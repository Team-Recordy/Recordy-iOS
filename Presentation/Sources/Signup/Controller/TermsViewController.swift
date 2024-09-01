//
//  TermsViewController.swift
//  Presentation
//
//  Created by Chandrala on 8/25/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

@available(iOS 16.0, *)
public final class TermsViewController: UIViewController {
  
  private let termsView = TermsView()
  
  private var term1State: ToggleButtonState = .deactivate
  private var term2State: ToggleButtonState = .deactivate
  private var term3State: ToggleButtonState = .deactivate
  
  private var isAllTermsAgreed: Bool {
    return term1State == .activate && term2State == .activate && term3State == .activate
  }
  
  public override func loadView() {
    self.view = termsView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setTarget()
    updateUI()
    setProgressView()
    RecordyProgressView.shared.updateProgress(currentPage: 0, totalPages: 3)
  }
  
  private func setTarget() {
    termsView.agreeAllTermButton.addTarget(self, action: #selector(agreeAllTermButtonTapped), for: .touchUpInside)
    termsView.termButton1.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.termButton2.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.termButton3.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }
  
  private func setProgressView() {
    let progressView = RecordyProgressView.shared
    self.view.addSubview(progressView)
    
    progressView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(6)
    }
  }
  
  @objc private func agreeAllTermButtonTapped() {
    toggleAllTerms()
    updateUI()
  }
  
  @objc private func termButtonTapped(_ sender: RecordyTermButton) {
    toggleTerm(for: sender)
    updateUI()
  }
  
  private func toggleAllTerms() {
    let newState: ToggleButtonState = isAllTermsAgreed ? .deactivate : .activate
    term1State = newState
    term2State = newState
    term3State = newState
  }
  
  private func toggleTerm(for button: RecordyTermButton) {
    if button == termsView.termButton1 {
      term1State = term1State == .activate ? .deactivate : .activate
    } else if button == termsView.termButton2 {
      term2State = term2State == .activate ? .deactivate : .activate
    } else if button == termsView.termButton3 {
      term3State = term3State == .activate ? .deactivate : .activate
    }
  }
  
  private func updateUI() {
    termsView.termButton1.updateState(term1State)
    termsView.termButton2.updateState(term2State)
    termsView.termButton3.updateState(term3State)
    termsView.agreeAllTermButton.updateState(isAllTermsAgreed ? .activate : .deactivate)
    termsView.nextButton.buttonState = isAllTermsAgreed ? .active : .inactive
  }
  
  @objc private func nextButtonTapped() {
    let nicknameViewController = NicknameViewController()
        self.navigationController?.pushViewController(nicknameViewController, animated: true)
  }
}
