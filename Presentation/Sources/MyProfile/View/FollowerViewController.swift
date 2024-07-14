//
//  FollowerViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//  setStyle() -> setUI() -> setAutolayout()

import UIKit
import SnapKit

import Then

import Common

public class FollowerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let viewModel = FollowerViewModel()
  private let tableView = UITableView()
  private let emptyView = UIView()
  let emptyLabel = UIImageView()
  let emptyImage = UIImageView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setEmptyViewStyle()
    bindViewModel()
    
    viewModel.fetchFollowers()
  }
  
  public func setEmptyViewStyle() {
    view.backgroundColor = .black
    
    emptyView.frame = view.bounds
    emptyView.backgroundColor = .black
    
    emptyImage.do {
      $0.image = CommonAsset.noFollowers.image
    }
    
    emptyLabel.do {
      $0.image = CommonAsset.text.image
    }
    
    emptyView.addSubview(emptyImage)
    emptyView.addSubview(emptyLabel)
    
    emptyImage.snp.makeConstraints {
      $0.top.equalToSuperview().offset(226)
      $0.leading.equalToSuperview().offset(138)
      $0.width.equalTo(100.adaptiveWidth)
      $0.height.equalTo(100.adaptiveHeight)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(18)
      $0.left.equalTo(105)
    }
    
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .black
    tableView.register(FollowerCell.self, forCellReuseIdentifier: "FollowerCell")
    
    view.addSubview(emptyView)
    view.addSubview(tableView)
  }
  
  public func bindViewModel() {
    viewModel.followers.bind { [weak self] _ in
      self?.tableView.reloadData()
    }
    
    viewModel.isEmpty.bind { [weak self] isEmpty in
      self?.emptyView.isHidden = !isEmpty
      self?.tableView.isHidden = isEmpty
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.followers.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerCell", for: indexPath) as! FollowerCell
    let follower = viewModel.followers.value[indexPath.row]
    cell.configure(with: follower)
    cell.followButtonAction = { [weak self] in
      self?.viewModel.toggleFollow(at: indexPath.row)
    }
    return cell
  }
}

public class FollowerCell: UITableViewCell {
  let profileImageView = UIImageView()
  let usernameLabel = UILabel()
  let followButton = MediumButton()
  
  var followButtonAction: (() -> Void)?
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(profileImageView)
    contentView.addSubview(usernameLabel)
    contentView.addSubview(followButton)
    
    setStyle()
    setAutoLayout()
    
    followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func followButtonTapped() {
    followButtonAction?()
  }
  
  public func setStyle() {
    usernameLabel.font = RecordyFont.body2Bold.font
    usernameLabel.textColor = CommonAsset.recordyGrey01.color
    contentView.backgroundColor = .black
  }
  
  public func setAutoLayout() {
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
  
  func configure(with follower: Follower) {
    profileImageView.image = follower.profileImage
    usernameLabel.text = follower.username
    followButton.setTitle(follower.isFollowing ? "팔로잉" : "팔로우", for: .normal)
    followButton.mediumState = follower.isFollowing ? .active : .inactive
  }
}
