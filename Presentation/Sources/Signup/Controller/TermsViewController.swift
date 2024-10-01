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
  
  private var firstTermButtonState: ToggleButtonState = .deactivate
  private var secondTermButtonState: ToggleButtonState = .deactivate
  private var thirdTermButtonState: ToggleButtonState = .deactivate
  
  private var isAllTermsAgreed: Bool {
    return term1State == .activate && term2State == .activate && term3State == .activate
  }
  
  public override func loadView() {
    view = termsView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
  }
  
  private func setStyle() {
    termsView.agreeAllTermButton.addTarget(self, action: #selector(agreeAllTermButtonTapped), for: .touchUpInside)
    termsView.termButton1.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.termButton2.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.termButton3.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }
  
  @objc private func agreeAllTermButtonTapped() {
    toggleAllTerms()
    updateButtonState()
  }
  
  @objc private func termButtonTapped(_ sender: RecordyTermButton) {
    toggleTerm(for: sender)
    updateButtonState()
  }
  
  private func toggleAllTerms() {
    let newState: ToggleButtonState = isAllTermsAgreed ? .deactivate : .activate
    firstTermButtonState = newState
    secondTermButtonState = newState
    thirdTermButtonState = newState
  }
  
  private func toggleTerm(for button: RecordyTermButton) {
    if button == termsView.termButton1 {
      firstTermButtonState = firstTermButtonState == .activate ? .deactivate : .activate
    } else if button == termsView.termButton2 {
      secondTermButtonState = secondTermButtonState == .activate ? .deactivate : .activate
    } else if button == termsView.termButton3 {
      thirdTermButtonState = thirdTermButtonState == .activate ? .deactivate : .activate
    }
  }
  
  private func updateButtonState() {
    termsView.termButton1.updateUI(firstTermButtonState)
    termsView.termButton2.updateUI(secondTermButtonState)
    termsView.termButton3.updateUI(thirdTermButtonState)
    termsView.agreeAllTermButton.updateUI(isAllTermsAgreed ? .activate : .deactivate)
    termsView.nextButton.buttonState = isAllTermsAgreed ? .active : .inactive
  }
  
  @objc private func nextButtonTapped() {
    let nicknameViewController = NicknameViewController()
    self.navigationController?.pushViewController(nicknameViewController, animated: true)
  }
}
