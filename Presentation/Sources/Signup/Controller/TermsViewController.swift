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
  
  private var serviceTermButtonState: ToggleButtonState = .deactivate
  private var infoTermButtonState: ToggleButtonState = .deactivate
  private var ageTermButtonState: ToggleButtonState = .deactivate
  
  private var isAllTermsAgreed: Bool {
    return serviceTermButtonState == .activate && infoTermButtonState == .activate && ageTermButtonState == .activate
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
    termsView.serviceTermButton.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.infoTermButton.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
    termsView.ageTermButton.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
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
    serviceTermButtonState = newState
    infoTermButtonState = newState
    ageTermButtonState = newState
  }
  
  private func toggleTerm(for button: RecordyTermButton) {
    if button == termsView.serviceTermButton {
      serviceTermButtonState = serviceTermButtonState == .activate ? .deactivate : .activate
    } else if button == termsView.infoTermButton {
      infoTermButtonState = infoTermButtonState == .activate ? .deactivate : .activate
    } else if button == termsView.ageTermButton {
      ageTermButtonState = ageTermButtonState == .activate ? .deactivate : .activate
    }
  }
  
  private func updateButtonState() {
    termsView.serviceTermButton.updateUI(serviceTermButtonState)
    termsView.infoTermButton.updateUI(infoTermButtonState)
    termsView.ageTermButton.updateUI(ageTermButtonState)
    termsView.agreeAllTermButton.updateUI(isAllTermsAgreed ? .activate : .deactivate)
    termsView.nextButton.buttonState = isAllTermsAgreed ? .active : .inactive
  }
  
  @objc private func nextButtonTapped() {
    let nicknameViewController = NicknameViewController()
    self.navigationController?.pushViewController(nicknameViewController, animated: true)
  }
}
