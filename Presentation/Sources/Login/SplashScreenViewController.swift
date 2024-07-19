//
//  SplashScreenViewController.swift
//  Presentation
//
//  Created by Chandrala on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Then

import Common

@available(iOS 16.0, *)
public class SplashScreenViewController: UIViewController {
  
  let logoImageView = UIImageView().then {
    $0.image = CommonAsset.loginAppLogo.image
    $0.contentMode = .scaleAspectFit
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = CommonAsset.recordyBG.color
    setUI()
    setLogoImageView()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateLogo()
  }
  
  func setUI() {
    view.addSubview(logoImageView)
  }
  
  private func setLogoImageView() {
    logoImageView.snp.makeConstraints {
      $0.width.equalTo(173)
      $0.height.equalTo(126)
      $0.top.equalToSuperview().offset(253)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func animateLogo() {
    self.logoImageView.snp.remakeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(274)
      $0.width.height.equalTo(120)
    }
    
    UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
      self.view.layoutIfNeeded()
    }) { _ in
      self.showLoginScreen()
    }
  }
  
  private func showLoginScreen() {
    let loginViewController = LoginViewController()
    loginViewController.modalTransitionStyle = .crossDissolve
    loginViewController.modalPresentationStyle = .fullScreen
    self.present(loginViewController, animated: true, completion: nil)
  }
}
