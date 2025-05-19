//
//  BlockUserViewController.swift
//  Presentation
//
//  Created by Rama on 5/15/25.
//  Copyright © 2025 com. All rights reserved.
//

import UIKit

import Core
import Common

public class BlockUserViewController: UIViewController {
  private lazy var blockButton = UIButton()
  private var userId: Int
  private var userNickname: String
  
  public var onBlocked: (() -> Void)?
  
  public init(userId: Int, userNickname: String) {
    self.userId = userId
    self.userNickname = userNickname
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitGray10.color
    
    blockButton.do {
      var config = UIButton.Configuration.plain()
      config.image = CommonAsset.report.image
      config.contentInsets = NSDirectionalEdgeInsets(
        top: 12,
        leading: 20,
        bottom: 12,
        trailing: 16
      )
      config.imagePlacement = .leading
      config.imagePadding = 16
      var container = AttributeContainer()
      container.font = ViskitFont.body1.font
      container.foregroundColor = CommonAsset.viskitAlert02.color
      config.attributedTitle = AttributedString(
        "차단하기",
        attributes: container
      )
      $0.configuration = config
      $0.contentHorizontalAlignment = .left
      $0.isUserInteractionEnabled = true
      $0.configuration?.baseForegroundColor = CommonAsset.viskitAlert02.color
      $0.addTarget(
        self,
        action: #selector(blockButtonTapped),
        for: .touchUpInside
      )
    }
  }
  
  private func setUI() {
    view.addSubview(blockButton)
  }
  
  private func setAutoLayout() {
    blockButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(52.adaptiveHeight)
    }
  }
  
  private func blockButtonRightAction() {
    let blockUser = UserInfoForBlock(id: self.userId, nickname: self.userNickname)

    BlockedUserManager.addBlockedUser(blockUser)
    
    self.dismiss(animated: true) {
      self.presentingViewController?.dismiss(animated: true) {
        self.onBlocked?()
      }
    }
  }
  
  @objc private func blockButtonTapped() {
    showPopUp(
      type: .block(user: self.userNickname),
      rightButtonAction: { [weak self] in
        self?.blockButtonRightAction()
      }
    )
  }
}
