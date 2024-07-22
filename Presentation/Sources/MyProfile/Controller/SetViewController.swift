//
//  SetViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Then
import SnapKit

import Core
import Common

@available(iOS 16.0, *)
public class SetViewController: UIViewController {
  
  let helpTableView: CustomTableView = {
    
    return CustomTableView(
      type: .help,
      list: [
        "커뮤니티 가이드라인",
        "서비스 이용약관",
        "개인정보 취급방침",
        "문의"
      ],
      headerTitle: "도움말",
      footerView: nil,
      cellArrowImages: [
        CommonAsset.indicator.image,
        CommonAsset.indicator.image,
        CommonAsset.indicator.image,
        CommonAsset.indicator.image
      ]
    )
  }()
  
  let divider = UIView()
  
  let extraTableView: CustomTableView = {
    let footerLabel = UILabel()
    footerLabel.do {
      $0.textColor = CommonAsset.recordyGrey04.color
      $0.font = RecordyFont.caption2.font
      $0.text = "앱 버전 1.1.1"
    }
    let footerView = UIView()
    footerView.backgroundColor = .black
    
    footerView.addSubview(footerLabel)
    footerLabel.snp.makeConstraints {
      $0.top.equalTo(footerView.snp.top).offset(4)
      $0.leading.equalToSuperview().inset(20)
    }
    
    return CustomTableView(
      type: .etc,
      list: [
        "로그인 연동",
        "로그아웃",
        "탈퇴하기"
      ],
      headerTitle: "기타",
      footerView: footerView,
      cellArrowImages: [
        CommonAsset.indicator.image,
        CommonAsset.indicator.image,
        CommonAsset.indicator.image
      ]
    )
  }()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    setUI()
    setAutoLayout()
    setDelegate()
  }
  
  private func setUI() {
    divider.backgroundColor = CommonAsset.recordyGrey09.color
    view.addSubview(helpTableView)
    view.addSubview(divider)
    view.addSubview(extraTableView)
  }

  private func setAutoLayout() {
    helpTableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(256.adaptiveHeight)
    }
    
    divider.snp.makeConstraints {
      $0.top.equalTo(helpTableView.snp.bottom).offset(12.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(8.adaptiveHeight)
    }
    
    extraTableView.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  } 

  private func setDelegate() {
    extraTableView.signOutDelegate = self
    extraTableView.withDrawDelegate = self
  }
}

@available(iOS 16.0, *)
extension SetViewController: SignOutDelegate {
  func signOut() {
    self.showPopUp(type: .signOut) {
      let apiProvider = APIProvider<APITarget.Users>()
      apiProvider.justRequest(.signOut) { result in
        switch result {
        case .success(let success):
          KeychainManager.shared.delete(token: .AccessToken)
          KeychainManager.shared.delete(token: .RefreshToken)
        case .failure(let failure):
          print(failure)
        }
      }
      self.dismiss(animated: false)
      let loginViewController = SplashScreenViewController()
      loginViewController.modalPresentationStyle = .fullScreen
      self.present(loginViewController, animated: false)
    }
  }
}

@available(iOS 16.0, *)
extension SetViewController: WithDrawDelegate {
  func withDraw() {
    self.showPopUp(type: .withdraw) {
      let apiProvider = APIProvider<APITarget.Users>()
      apiProvider.justRequest(.withdraw) { result in
        switch result {
        case .success(let success):
          KeychainManager.shared.delete(token: .AccessToken)
          KeychainManager.shared.delete(token: .RefreshToken)
        case .failure(let failure):
          print(failure)
        }
      }
      self.dismiss(animated: false)
      let loginViewController = SplashScreenViewController()
      loginViewController.modalPresentationStyle = .fullScreen
      self.present(loginViewController, animated: false)
    }
  }
}
