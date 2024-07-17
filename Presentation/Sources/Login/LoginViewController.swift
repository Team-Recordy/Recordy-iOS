//
//  LoginViewController.swift
//  Common
//
//  Created by Chandrala on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import AuthenticationServices

import Core

import RxSwift
import RxCocoa

public final class LoginViewController: UIViewController {

  var rootView = LoginView()
  private var appleLoginCompletion: ((Result<String, Error>) -> Void)?
  private let disposeBag = DisposeBag()

  public override func loadView() {
    self.view = rootView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setTarget()
  }

  func setTarget() {
    rootView.kakaoLoginButton.addTarget(
      self,
      action: #selector(kakaoLoginButtonTapped),
      for: .touchUpInside
    )
    rootView.appleLoginButton.addTarget(
      self,
      action: #selector(appleLoginButtonTapped),
      for: .touchUpInside
    )
  }

  @objc
  private func kakaoLoginButtonTapped() {
    let kakaoLoginManager = KakaoLoginManager()
    kakaoLoginManager.login { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let accessToken):
        self.postSignInRequest(
          authorization: accessToken,
          platformType: .kakao
        )
      case .failure(let failure):
        print(failure)
      }
    }
  }

  @objc
  private func appleLoginButtonTapped(_ sender: UIButton) {
    loginWithApple { result in
      switch result {
      case .success(let accessToken):
        self.postSignInRequest(
          authorization: accessToken,
          platformType: .apple
        )
      case .failure(let failure):
        print(failure)
      }
    }
  }

  func postSignInRequest(
    authorization: String,
    platformType: PlatformType
  ) {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.SignInRequest(authorization: authorization,
                                    platformType: platformType)
    apiProvider.requestResponsable(
      .signIn(request),
      DTO.SignInResponse.self
    ) { result in
      switch result {
      case .success(let response):
        KeychainManager.shared.create(
          token: .AccessToken,
          value: response.accessToken
        )
        KeychainManager.shared.create(
          token: .RefreshToken,
          value: response.refreshToken
        )
      case .failure(let error):
        print("Sign in failed with error: \(error)")
      }
    }
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

  func loginWithApple(completion: @escaping (Result<String, Error>) -> Void) {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
    self.appleLoginCompletion = completion
  }

  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }

  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      if let authorizationCode = appleIDCredential.authorizationCode,
         let identityToken = appleIDCredential.identityToken,
         let authCodeString = String(data: authorizationCode, encoding: .utf8),
         let identifyTokenString = String(data: identityToken, encoding: .utf8) {
        appleLoginCompletion?(.success(identifyTokenString))
      }
    } else {
      appleLoginCompletion?(.failure(RecordyNetworkError.apple))
    }
  }


  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    // 로그인 실패(유저의 취소도 포함)
    print("login failed - \(error.localizedDescription)")
  }
}
