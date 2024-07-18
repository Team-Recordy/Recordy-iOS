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

public class SplashScreenViewController: UIViewController {
  
  let logoImageView = UIImageView().then {
    $0.image = CommonAsset.mypageCamera.image
    $0.contentMode = .scaleAspectFit
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = CommonAsset.recordyBG.color
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
      $0.width.equalTo(135)
      $0.height.equalTo(106)
      $0.top.equalToSuperview().offset(253)
      $0.horizontalEdges.equalToSuperview().offset(120)
    }
  }
  
  private func animateLogo() {
    UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
      self.logoImageView.frame = CGRect(x: 20, y: 50, width: 50, height: 50)
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
