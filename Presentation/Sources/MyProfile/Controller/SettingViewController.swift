//
//  SettingViewController.swift
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
public class SettingViewController: UIViewController, ProfileEditViewControllerDelegate {
  
  private var loginType: String = "APPLE"
  private var user: User
  
  init(user: User) {
    self.user = user
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var accountTableView: CustomTableView = {
    return CustomTableView(
      type: .account,
      list: [
        "프로필 수정",
        "로그인 연동"
      ],
      headerTitle: "계정",
      footerView: nil,
      cellArrowImages: [
        CommonAsset.indicator.image,
        loginType == "KAKAO" ? CommonAsset.kakao.image : CommonAsset.apple.image
      ]
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
      $0.backgroundColor = .clear
      $0.textColor = CommonAsset.viskitGray01.color
      $0.font = ViskitFont.caption2Medium.font
      $0.text = "앱 버전 1.0.0"
    }
    let footerView = UIView()
    footerView.backgroundColor = .clear
    
    footerView.addSubview(footerLabel)
    footerLabel.snp.makeConstraints {
      $0.top.equalTo(footerView.snp.top).offset(4)
      $0.leading.equalToSuperview().inset(20)
    }
    
    return CustomTableView(
      type: .etc,
      list: [
        "로그아웃",
        "탈퇴"
      ],
      headerTitle: "기타",
      footerView: footerView,
      cellArrowImages: [
        CommonAsset.indicator.image,
        CommonAsset.indicator.image
      ]
    )
  }()
  
  private lazy var firstDivider = createDivider()
  private lazy var secondDivider = createDivider()
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
    getLoginPlatformType()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
    setDelegate()
      
    accountTableView.reloadAndUpdateHeight()
    helpTableView.reloadAndUpdateHeight()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleProfileUpdate(_:)),
      name: .updateDidComplete,
      object: nil
    )
  }
  
  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitBG.color
    configureNavigationBar()
    setupCustomBackButton()
  }
  
  private func setUI() {
    view.addSubviews(
      accountTableView,
      helpTableView,
      firstDivider,
      secondDivider,
      extraTableView
    )
  }
  
  private func setAutoLayout() {
    accountTableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    firstDivider.snp.makeConstraints {
      $0.top.equalTo(accountTableView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(4.adaptiveHeight)
    }
    
    helpTableView.snp.makeConstraints {
      $0.top.equalTo(firstDivider.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    secondDivider.snp.makeConstraints {
      $0.top.equalTo(helpTableView.snp.bottom).offset(10)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(4.adaptiveHeight)
    }
    
    extraTableView.snp.makeConstraints {
      $0.top.equalTo(secondDivider.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  @objc private func handleProfileUpdate(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let updatedNickname = userInfo["nickname"] as? String,
          let updatedProfileImageUrl = userInfo["profileImageUrl"] as? String else { return }
    
    user.nickname = updatedNickname
    user.profileImage = updatedProfileImageUrl
  }
  
  func didUpdateProfile(nickname: String, profileImageUrl: String) {
    print(
      "✅ SettingViewController received profile update: \(nickname), \(profileImageUrl)"
    )
    
    user.nickname = nickname
    user.profileImage = profileImageUrl
    
    NotificationCenter.default.post(
      name: .updateDidComplete,
      object: nil,
      userInfo: [
        "nickname": nickname,
        "profileImageUrl": profileImageUrl
      ]
    )
  }
  
  private func setDelegate() {
    extraTableView.signOutDelegate = self
    extraTableView.withDrawDelegate = self
    accountTableView.accountActionDelegate = self
  }
  
  private func createDivider() -> UIView {
    let divider = UIView()
    divider.backgroundColor = CommonAsset.viskitGray11.color
    return divider
  }
  
  private func configureNavigationBar() {
    navigationItem.title = "설정"
    navigationItem.backButtonTitle = ""
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.tintColor = .white
      navigationBar.titleTextAttributes = [
        .foregroundColor: CommonAsset.viskitGray01.color,
        .font: ViskitFont.title3.font
      ]
    }
  }
  
  private func getLoginPlatformType() {
    if let savedPlatform = UserDefaults.standard.string(forKey: "PlatformType") {
      self.loginType = savedPlatform
    } else {
      self.loginType = "APPLE"
    }
    print("로그인 타입: \(self.loginType)")
    
    DispatchQueue.main.async {
      self.updateLoginIcon()
    }
  }
  
  private func updateLoginIcon() {
    accountTableView.cellArrowImages[1] = loginType == "KAKAO" ? CommonAsset.kakao.image : CommonAsset.apple.image
    
    if let tableView = accountTableView.subviews.first(where: { $0 is UITableView }) as? UITableView {
      tableView.reloadData()
    } else {
      print("error")
    }
  }
}

@available(iOS 16.0, *)
extension SettingViewController: SignOutDelegate {
  func signOut() {
    self.showPopUp(type: .signOut) {
      let apiProvider = APIProvider<APITarget.Users>()
      
      apiProvider.justRequest(.signOut) { result in
        switch result {
        case .success:
          KeychainManager.shared.delete(token: .AccessToken)
          KeychainManager.shared.delete(token: .RefreshToken)
          UserDefaults.standard.removeObject(forKey: "PlatformType")
          
          self.dismiss(animated: false)
          let loginViewController = SplashScreenViewController()
          loginViewController.modalPresentationStyle = .fullScreen
          self.present(loginViewController, animated: false)
        case .failure(let error):
          print("\(error)")
        }
      }
    }
  }
}

@available(iOS 16.0, *)
extension SettingViewController: WithDrawDelegate {
  func withDraw() {
    self.showPopUp(type: .withdraw) {
      let apiProvider = APIProvider<APITarget.Users>()
      
      apiProvider.justRequest(.withdraw) { result in
        switch result {
        case .success:
          KeychainManager.shared.delete(token: .AccessToken)
          KeychainManager.shared.delete(token: .RefreshToken)
          UserDefaults.standard.removeObject(forKey: "PlatformType")
          
          self.dismiss(animated: false)
          let loginViewController = SplashScreenViewController()
          loginViewController.modalPresentationStyle = .fullScreen
          self.present(loginViewController, animated: false)
        case .failure(let error):
          print("\(error)")
        }
      }
    }
  }
}

@available(iOS 16.0, *)
extension SettingViewController: AccountActionDelegate {
  func didTapProfileEdit() {
    let profileEditVC = ProfileEditViewController(
      id: user.id,
      currentNickname: user.nickname,
      currentProfileImage: user.profileImage
    )
    profileEditVC.delegate = self
    navigationController?.pushViewController(
      profileEditVC,
      animated: true
    )
  }
}
