//
//  FollowerCell.swift
//  Presentation
//
//  Created by 송여경 on 8/20/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit
import SnapKit
import Then

import Core
import Common

class FollowerCell: UITableViewCell {
  
  let profileImageView = UIImageView()
  let usernameLabel = UILabel()
  let followButton = MediumButton()
  
  var followButtonEvent: (() -> Void)?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
      $0.layer.cornerRadius = 54 / 2
      $0.clipsToBounds = true
      $0.contentMode = .scaleAspectFit
    }
    
    usernameLabel.do {
      $0.font = RecordyFont.body2Bold.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    contentView.backgroundColor = .black
    
    followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
  }
  
  private func setUI() {
    contentView.addSubview(profileImageView)
    contentView.addSubview(usernameLabel)
    contentView.addSubview(followButton)
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
    
    followButton.snp.makeConstraints {
      $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
      $0.centerY.equalTo(contentView.snp.centerY)
      $0.width.equalTo(76.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
  }
  
  @objc private func followButtonTapped() {
    self.followButtonEvent?()
  }
  
  func configure(with follower: Follower) {
    let url = URL(string: follower.profileImage)
    profileImageView.kf.setImage(with: url)
    usernameLabel.text = follower.username
    followButton.isHidden = follower.username == "유영"
    updateFollowButton(isFollowed: follower.isFollowing)
  }
  
  func updateFollowButton(isFollowed: Bool) {
    followButton.mediumState = isFollowed ? .active : .inactive
  }
}
