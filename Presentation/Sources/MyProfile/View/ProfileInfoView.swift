//
//  ProfileInfoView.swift
//  Presentation
//
//  Created by 송여경 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit

import SnapKit
import Then

import Common

public class ProfileInfoView: UIView {
  
  let profileImage = UIImageView()
  let userName = UILabel()
  let followerButton = UIButton()
  let followingButton = UIButton()
  
  private let middleDivider = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setLayout()
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setLayout() {
    addSubview(profileImage)
    addSubview(userName)
    addSubview(followerButton)
    addSubview(middleDivider)
    addSubview(followingButton)
  }
  
  public func setStyle() {
    
    profileImage.do {
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = 52/2
      $0.clipsToBounds = true
      $0.image = CommonAsset.profileImage.image
    }
    
    userName.do {
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyWhite.color
      $0.text = "공간수집가열글자아"
    }
    
    followerButton.do {
      $0.setTitleColor(CommonAsset.recordyWhite.color, for: .normal)
      $0.titleLabel?.font = RecordyFont.body2.font
      let attributedText = NSMutableAttributedString(string: "2.5만", attributes: [.font: RecordyFont.body2.font])
      attributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
      $0.setAttributedTitle(attributedText, for: .normal)
      $0.titleLabel?.numberOfLines = 1
      $0.titleLabel?.textAlignment = .center
    }
    
    followingButton.do {
      $0.setTitleColor(CommonAsset.recordyWhite.color, for: .normal)
      $0.titleLabel?.font = RecordyFont.body2.font
      let attributedText = NSMutableAttributedString(string: "0", attributes: [.font: RecordyFont.body2.font])
      attributedText.append(NSAttributedString(string: " 명의 팔로잉", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
      $0.setAttributedTitle(attributedText, for: .normal)
      $0.titleLabel?.numberOfLines = 1
      $0.titleLabel?.textAlignment = .center
    }
    
    middleDivider.do {
      $0.backgroundColor = CommonAsset.recordyGrey04.color
    }
  }
  
  public func setUpConstraints() {
    profileImage.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
      $0.leading.equalToSuperview().inset(20)
      $0.width.height.equalTo(52)
    }
    
    userName.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(21)
      $0.leading.equalTo(profileImage.snp.trailing).offset(12)
      $0.height.equalTo(28)
      $0.trailing.equalToSuperview().inset(20)
    }
    
    followerButton.snp.makeConstraints {
      $0.top.equalTo(userName.snp.bottom).offset(2)
      $0.leading.equalTo(profileImage.snp.trailing).offset(12)
    }
    
    middleDivider.snp.makeConstraints {
      $0.leading.equalTo(followerButton.snp.trailing).offset(8)
      $0.centerY.equalTo(followerButton.snp.centerY)
      $0.width.equalTo(1)
      $0.height.equalTo(10)
    }
    
    followingButton.snp.makeConstraints {
      $0.top.equalTo(userName.snp.bottom).offset(2)
      $0.leading.equalTo(middleDivider.snp.trailing).offset(8)
    }
  }
  
  func updateView(with model: ProfileUserModel) {
    userName.text = model.name
    
    let followerAttributedText = NSMutableAttributedString(string: "\(model.followerCount)", attributes: [.font: RecordyFont.body2.font])
    followerAttributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    followerButton.setAttributedTitle(followerAttributedText, for: .normal)
    
    let followingAttributedText = NSMutableAttributedString(string: "\(model.followingCount)", attributes: [.font: RecordyFont.body2.font])
    followingAttributedText.append(NSAttributedString(string: " 명의 팔로잉", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    followingButton.setAttributedTitle(followingAttributedText, for: .normal)
  }
}
