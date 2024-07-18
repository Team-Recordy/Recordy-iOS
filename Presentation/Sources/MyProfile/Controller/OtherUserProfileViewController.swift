//
//  OtherUserProfileViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

import SnapKit
import Then
import Kingfisher

public class OtherUserProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  private let profileImage = UIImageView()
  private let userName = UILabel()
  
  private let followerButton = UIButton()
  private let followingButton = MediumButton()
  
  private let countLabel = UILabel()
  private var collectionView: UICollectionView?
  private var feeds: [Feed] = []
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    followingButton.addTarget(self, action: #selector(followButtonTap), for: .touchUpInside)
    followerButton.addTarget(self, action: #selector(showOtherFollowers), for: .touchUpInside)
    
    setUpCollectionView()
    setStyle()
    setUI()
    setAutoLayout()
    getOtherRecordList()
  }
  
  private func setStyle() {
    self.view.backgroundColor = .black
    profileImage.do {
      $0.image = CommonAsset.profileImage.image
      $0.contentMode = .scaleAspectFit
      $0.layer.cornerRadius = 52/2
      $0.clipsToBounds = true
    }
    userName.do {
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyWhite.color
      $0.text = "공간수집가열글자아"
    }
    followingButton.do {
      $0.setTitle("팔로잉", for: .normal)
      $0.addTarget(self, action: #selector(followButtonTap), for: .touchUpInside)
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
    countLabel.do {
      $0.text = "• 0 개의 기록"
      $0.textColor = .white
      $0.font = RecordyFont.caption1.font
      $0.numberOfLines = 1
      $0.textAlignment = .right
    }
    
    collectionView!.do {
      $0.backgroundColor = .clear
    }
  }
  
  private func setUI() {
    self.view.addSubview(profileImage)
    self.view.addSubview(userName)
    self.view.addSubview(followerButton)
    self.view.addSubview(followingButton)
    self.view.addSubview(countLabel)
    self.view.addSubview(collectionView!)
  }
  
  private func setAutoLayout() {
    profileImage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
      $0.leading.equalToSuperview().inset(20)
      $0.width.height.equalTo(52)
    }
    userName.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(21)
      $0.leading.equalTo(profileImage.snp.trailing).offset(12)
      $0.height.equalTo(28)
      $0.trailing.equalToSuperview().inset(20)
    }
    followerButton.snp.makeConstraints {
      $0.top.equalTo(userName.snp.bottom).offset(2)
      $0.leading.equalTo(profileImage.snp.trailing).offset(12)
      $0.width.equalTo(101.adaptiveWidth)
      $0.height.equalTo(20.adaptiveHeight)
    }
    followingButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.equalTo(76.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
    countLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(96)
      $0.leading.equalToSuperview().offset(194)
      $0.width.equalTo(161.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    collectionView!.snp.makeConstraints {
      $0.top.equalTo(countLabel.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 170, height: 288)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView!.dataSource = self
    collectionView!.delegate = self
    collectionView!.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier)
  }
  
  private func setCountLabelText() {
    let whiteText = "• \(feeds.count)"
    let greyText = " 개의 기록"
    let attributedText = NSMutableAttributedString(string: whiteText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    attributedText.append(NSAttributedString(string: greyText, attributes: [NSAttributedString.Key.foregroundColor: CommonAsset.recordyGrey03.color]))
    countLabel.attributedText = attributedText
  }
  
  func othersRecordList(feeds: [Feed]) {
    self.feeds.append(contentsOf: feeds)
    self.collectionView!.reloadData()
    setCountLabelText()
  }
  
  @objc private func followButtonTap() {
    self.followingButton.mediumState = self.followingButton.mediumState == .active ? .inactive : .active
  }
  
  @objc private func showOtherFollowers() {
    print("팔로워 목록 출력")
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feeds.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? ThumbnailCollectionViewCell else {
      return UICollectionViewCell()
    }
    let thumbnailUrl = URL(string: String(feeds[indexPath.row].thumbnailLink.dropLast(1)))
    cell.backgroundImageView.kf.setImage(with: thumbnailUrl)
    cell.locationText.text = feeds[indexPath.row].location
    return cell
  }
  
  func getOtherRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetUserRecordListRequest(otherUserId: 2, cursorId: 0, size: 10)
    apiProvider.requestResponsable(.getUserRecordList(request), DTO.GetUserRecordListResponse.self) {[weak self]
      result in
      guard let self = self else {return}
      switch result {
      case .success(let response):
        let feeds = response.content.map {
          Feed(
            id: $0.recordInfo.id,
            location: $0.recordInfo.location,
            nickname: $0.recordInfo.uploaderNickname,
            description: $0.recordInfo.content,
            bookmarkCount: $0.recordInfo.bookmarkCount,
            isBookmarked: $0.isBookmark,
            videoLink: $0.recordInfo.fileUrl.videoUrl,
            thumbnailLink: $0.recordInfo.fileUrl.thumbnailUrl
          )
        }
        self.othersRecordList(feeds: feeds)
      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }
}
