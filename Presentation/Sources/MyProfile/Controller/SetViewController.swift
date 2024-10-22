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
  
  let accountTableView: CustomTableView = {
    return CustomTableView(
      type: .account,
      list: [
        "프로필 수정",
        "로그인 연동"
      ],
      headerTitle: "계정",
      footerView: nil,
      cellArrowImages: [CommonAsset.indicator.image]
    )
  }()
  
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
  
  private func createDivider() -> UIView {
    let divider = UIView()
    divider.backgroundColor = CommonAsset.recordyGrey09.color
    return divider
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    setUI()
    setAutoLayout()
    setDelegate()
    configureNavigationBar()
    self.navigationController?.navigationBar.topItem?.title = ""
  }
  
  private lazy var firstDivider = createDivider()
  private lazy var secondDivider = createDivider()
  
  private func setUI() {
    [ accountTableView,
      helpTableView,
      firstDivider,
      secondDivider,
      extraTableView
    ].forEach { view.addSubview($0) }
  }
  
  private func setAutoLayout() {
    
    accountTableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(160.adaptiveHeight)
    }
    
    firstDivider.snp.makeConstraints {
      $0.top.equalTo(accountTableView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(4.adaptiveHeight)
    }
    
    helpTableView.snp.makeConstraints {
      $0.top.equalTo(firstDivider.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(265.adaptiveHeight)
    }
    
    secondDivider.snp.makeConstraints {
      $0.top.equalTo(helpTableView.snp.bottom).inset(10)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(4.adaptiveHeight)
    }
    
    extraTableView.snp.makeConstraints {
      $0.top.equalTo(secondDivider.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setDelegate() {
    extraTableView.signOutDelegate = self
    extraTableView.withDrawDelegate = self
    accountTableView.accountActionDelegate = self
  }
  
  private func configureNavigationBar() {
    navigationItem.title = "설정"
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.tintColor = .white
      navigationBar.titleTextAttributes = [
        .foregroundColor: CommonAsset.viskitGray01.color,
        .font: ViskitFont.title3.font
      ]
    }
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

@available(iOS 16.0, *)
extension SetViewController: AccountActionDelegate {
  func didTapProfileEdit() {
    let profileEditVC = ProfileEditViewController()
    navigationController?.pushViewController(profileEditVC, animated: true)
  }
  func didTapLoginConnection() {
    
  }
}
