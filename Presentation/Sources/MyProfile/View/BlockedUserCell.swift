//
//  BlockedUserCell.swift
//  Presentation
//
//  Created by Rama on 5/19/25.
//  Copyright © 2025 com. All rights reserved.
//

import UIKit

import Core
import Common

class BlockedUserCell: UITableViewCell {
  private var blockedUserId: Int?
  private var blockedUserNickname: String?
  
  let profileImageView = UIImageView()
  let usernameLabel = UILabel()
  let unblockButton = MediumButton()
  
  var unblockButtonEvent: ((Int, String) -> Void)?
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    profileImageView.do {
      $0.image = CommonAsset.profileEdit.image
      $0.layer.cornerRadius = 54 / 2
      $0.clipsToBounds = true
      $0.contentMode = .scaleAspectFit
    }
    
    usernameLabel.do {
      $0.font = RecordyFont.body2Bold.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    contentView.backgroundColor = CommonAsset.viskitBG.color
    
    unblockButton.do {
      $0.addTarget(self, action: #selector(unblockButtonTapped), for: .touchUpInside)
    }
  }
  
  private func setUI() {
    contentView.addSubviews(
      profileImageView,
      usernameLabel,
      unblockButton
    )
  }
  
  private func setAutoLayout() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(10)
      $0.leading.equalTo(contentView.snp.leading).offset(20)
      $0.centerY.equalTo(contentView.snp.centerY)
      $0.width.equalTo(54)
      $0.height.equalTo(54)
    }
    
    usernameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
      $0.centerY.equalTo(contentView.snp.centerY)
    }
    
    unblockButton.snp.makeConstraints {
      $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
      $0.centerY.equalTo(contentView.snp.centerY)
      $0.width.equalTo(76.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
  }
  
  public func configure(with blockedUser: UserInfoForBlock) {
    usernameLabel.text = blockedUser.nickname
    unblockButton.mediumState = .unblock
    self.blockedUserId = blockedUser.id
    self.blockedUserNickname = blockedUser.nickname
  }
  
  @objc private func unblockButtonTapped() {
    if let id = blockedUserId, let nickname = blockedUserNickname {
      self.unblockButtonEvent?(id, nickname)
    }
  }
}
