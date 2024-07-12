//
//  SignupViewController.swift
//  Presentation
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

public final class SignupViewController: UIViewController {
  
  var rootView: UIView = UIView()
  let progressView = RecordyProgressView()
  let totalPages = 3
  var currentPage = 0
  
  public override func loadView() {
    let termsView = TermsView()
    termsView.nextButton.addTarget(
      self,
      action: #selector(showNicknameView),
      for: .touchUpInside
    )
    self.view = termsView
    rootView = termsView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
    showTermsView()
    progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
  }
  
  func setStyle() {
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
    termsView.nextButton.addTarget(self, action: #selector(showNicknameView), for: .touchUpInside)
    switchView(termsView)
  }
  
  @objc func showNicknameView() {
    currentPage += 1
    progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    let nicknameView = NicknameView()
    nicknameView.nextButton.addTarget(self, action: #selector(showCompleteView), for: .touchUpInside)
    switchView(nicknameView)
  }
  
  @objc func showCompleteView() {
    currentPage += 1
    progressView.updateProgress(
      currentPage: currentPage,
      totalPages: totalPages
    )
    let completeView = CompleteView()
    switchView(completeView)
  }
  
  func switchView(_ newView: UIView) {
    rootView.removeFromSuperview()
    view.addSubview(newView)
    newView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    rootView = newView 
    
    view.addSubview(progressView)
    setAutoLayout()
  }
}
