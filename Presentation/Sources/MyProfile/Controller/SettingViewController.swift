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
  
  // MARK: - ScrollView & StackView for scrolling content
  private let scrollView = UIScrollView()
  private let contentStackView = UIStackView()
  
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
        "로그인 연동",
        "차단된 계정"
      ],
      headerTitle: "계정",
      footerView: nil,
      cellArrowImages: [
        CommonAsset.indicator.image,
        loginType == "KAKAO" ? CommonAsset.kakao.image : CommonAsset.apple.image,
        CommonAsset.indicator.image
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
      $0.top.equalToSuperview().offset(4)
      $0.leading.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(4)
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
      
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.accountTableView.reloadAndUpdateHeight()
      self.helpTableView.reloadAndUpdateHeight()
      self.extraTableView.reloadAndUpdateHeight()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.contentStackView.layoutIfNeeded()
        self.scrollView.layoutIfNeeded()
      }
    }
    
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
    view.addSubview(scrollView)
    scrollView.addSubview(contentStackView)

    contentStackView.axis = .vertical
    contentStackView.spacing = 0
    contentStackView.alignment = .fill
    contentStackView.distribution = .fill

    [accountTableView, firstDivider, helpTableView, secondDivider, extraTableView].forEach {
      contentStackView.addArrangedSubview($0)
    }
    
    let bottomSpacer = UIView()
    bottomSpacer.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    contentStackView.addArrangedSubview(bottomSpacer)
  }
  
  private func setAutoLayout() {
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }

    contentStackView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
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
    accountTableView.blockedUserDelegate = self
  }
  
  private func createDivider() -> UIView {
    let divider = UIView()
    divider.backgroundColor = CommonAsset.viskitGray11.color
    divider.snp.makeConstraints {
      $0.height.equalTo(4)
     }
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
        KeychainManager.shared.delete(token: .AccessToken)
        KeychainManager.shared.delete(token: .RefreshToken)
        UserDefaults.standard.removeObject(forKey: "PlatformType")
        self.dismiss(animated: false)
        let loginViewController = SplashScreenViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: false)
      let apiProvider = APIProvider<APITarget.Users>()
      
      apiProvider.justRequest(.signOut) { result in
          print("@Log - \(result)")
      }
    }
  }
}

@available(iOS 16.0, *)
extension SettingViewController: WithDrawDelegate {
    func withDraw() {
        self.showPopUp(type: .withdraw) {
            KeychainManager.shared.delete(token: .AccessToken)
            KeychainManager.shared.delete(token: .RefreshToken)
            UserDefaults.standard.removeObject(forKey: "PlatformType")
            
            self.dismiss(animated: false)
            let loginViewController = SplashScreenViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: false)
            
            let apiProvider = APIProvider<APITarget.Users>()
            
            apiProvider.justRequest(.withdraw) { result in
                print("@Log withdraw - \(result)")
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

@available(iOS 16.0, *)
extension SettingViewController: BlockedUserDelegate {
  func didTapBlockedUser() {
    let editBlockedVC = EditBlockedViewController()
    navigationController?.pushViewController(
      editBlockedVC,
      animated: true
    )
  }
}
