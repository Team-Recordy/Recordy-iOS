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
  
  private let profileImage = UIImageView()
  private let userName = UILabel()
  
  private let followerStackView = UIStackView()
  private let followingStackView = UIStackView()
  private let followStackView = UIStackView()
  
  private let followerButton = UIButton()
  private let followingButton = UIButton()
  
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
    addSubview(followStackView)
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
      $0.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
      let attributedText = NSMutableAttributedString(string: "2000000", attributes: [.font: RecordyFont.body2.font])
      attributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
      $0.setAttributedTitle(attributedText, for: .normal)
      $0.titleLabel?.numberOfLines = 1
      $0.titleLabel?.textAlignment = .center
    }
    
    followingButton.do {
      $0.setTitleColor(CommonAsset.recordyWhite.color, for: .normal)
      $0.titleLabel?.font = RecordyFont.body2.font
      $0.addTarget(self, action: #selector(showFollowings), for: .touchUpInside)
      let attributedText = NSMutableAttributedString(string: "0", attributes: [.font: RecordyFont.body2.font])
      attributedText.append(NSAttributedString(string: " 명의 팔로잉", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
      $0.setAttributedTitle(attributedText, for: .normal)
      $0.titleLabel?.numberOfLines = 1
      $0.titleLabel?.textAlignment = .center
    }
    
    middleDivider.do {
      $0.backgroundColor = CommonAsset.recordyGrey04.color
    }
    
    followerStackView.do {
      $0.axis = .horizontal
      $0.spacing = 4
      $0.alignment = .fill
      $0.addArrangedSubview(followerButton)
    }
    
    followingStackView.do {
      $0.axis = .horizontal
      $0.spacing = 4
      $0.alignment = .fill
      $0.addArrangedSubview(followingButton)
    }
    
    followStackView.do {
      $0.axis = .horizontal
      $0.spacing = 8
      $0.alignment = .center
      $0.addArrangedSubview(followerStackView)
      $0.addArrangedSubview(middleDivider)
      $0.addArrangedSubview(followingStackView)
    }
  }
  
  @objc private func showFollowers() {
    print("팔로워 목록 보기")
  }
  
  @objc private func showFollowings() {
    print("팔로잉 목록 보기")
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
    
    followStackView.snp.makeConstraints {
      $0.top.equalTo(userName.snp.bottom).offset(2)
      $0.leading.equalTo(profileImage.snp.trailing).offset(12)
      $0.height.equalTo(20)
    }
    
    middleDivider.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.height.equalTo(10)
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
