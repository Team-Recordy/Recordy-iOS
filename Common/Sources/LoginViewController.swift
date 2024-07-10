//
//  LoginViewController.swift
//  Common
//
//  Created by Chandrala on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
  
  var rootView = LoginView()
  
  override func loadView() {
    self.view = rootView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func setTarget() {
    rootView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    rootView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
  }
  
  @objc
  private func kakaoLoginButtonTapped(_ sender: UIButton) {
  }
  
  @objc
  private func appleLoginButtonTapped(_ sender: UIButton) {
  }
  
  
}
