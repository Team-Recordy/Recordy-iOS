//
//  CompleteViewController.swift
//  Presentation
//
//  Created by Chandrala on 8/25/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core
import Common

@available(iOS 16.0, *)
final class CompleteViewController: UIViewController{
  
  private let completeView = CompleteView()
  private let nicknameView = NicknameView()
  
  override func loadView() {
    self.view = CompleteView()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setProgressView()
    RecordyProgressView.shared.updateProgress(currentPage: 2, totalPages: 3)
  }
  
  private func setTarget() {
    completeView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
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
  
  @objc private func completeButtonTapped() {
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
