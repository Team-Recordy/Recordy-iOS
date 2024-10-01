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
  
  override func loadView() {
    view = completeView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
  }
  
  private func setStyle() {
    completeView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
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
        present(tabBarController, animated: false)
      case .failure:
        print("failed to login")
      }
    }
  }
}
