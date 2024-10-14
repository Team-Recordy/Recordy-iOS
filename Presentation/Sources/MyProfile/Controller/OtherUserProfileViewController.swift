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
  private var user: User?
  private let id: Int
  private var cursorId: Int = 0

  init(id: Int) {
    self.id = id
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    followingButton.addTarget(self, action: #selector(followButtonTap), for: .touchUpInside)
    followerButton.addTarget(self, action: #selector(showOtherFollowers), for: .touchUpInside)

    setUpCollectionView()
    setStyle()
    setUI()
    setAutoLayout()
    getOtherRecordList()
    getUserInfo()
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
      $0.titleLabel?.textAlignment = .left  // 좌측 정렬
      $0.contentHorizontalAlignment = .left  // 버튼 전체 텍스트 좌측 정렬
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

  private func setUserProfile() {
    guard let user = user else { return }
    let attributedText = NSMutableAttributedString(string: "\(user.followerCount)", attributes: [.font: RecordyFont.body2.font])
    attributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    self.followerButton.setAttributedTitle(attributedText, for: .normal)
    self.userName.text = user.nickname
    let url = URL(string: user.profileImage)!
    self.profileImage.kf.setImage(with: url)
    self.followingButton.mediumState = user.isFollowing ? .active : .inactive
  }

  func getUserInfo() {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.GetProfileRequest(otherUserId: id)
    apiProvider.requestResponsable(.getProfile(request), DTO.GetProfileResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.user = User(
          isMine: response.id,
          id: response.nickname,
          nickname: response.followerCount,
          follower: response.followingCount,
          following: response.isFollowing,
          isFollowing: response.profileImageUrl
        )
        self.setUserProfile()
      case .failure(let failure):
        print(failure)
      }
    }
  }

  func getOtherRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetUserRecordListRequest(
      otherUserId: id,
      cursorId: cursorId,
      size: 100
    )
    apiProvider.requestResponsable(.getUserRecordList(request), DTO.GetUserRecordListResponse.self) { [weak self]
      result in
      guard let self = self else {return}
      switch result {
      case .success(let response):
        let feeds = response.content.map {
          Feed(
            id: $0.recordInfo.id,
            userId: $0.recordInfo.uploaderId,
            location: $0.recordInfo.location, placeInfo: <#PlaceInfo#>,
            nickname: $0.recordInfo.uploaderNickname,
            description: $0.recordInfo.content,
            isBookmarked: $0.isBookmark, bookmarkCount: $0.recordInfo.bookmarkCount,
            videoLink: $0.recordInfo.fileUrl.videoUrl,
            thumbnailLink: $0.recordInfo.fileUrl.thumbnailUrl,
            isMine: $0.recordInfo.isMine
          )
        }
        self.feeds += feeds
        DispatchQueue.main.async {
          self.collectionView!.reloadData()
          self.setCountLabelText()
        }
      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }

  @objc private func followButtonTap() {
    self.followingButton.mediumState = self.followingButton.mediumState == .active ? .inactive : .active
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.FollowRequest(followingId: id)
    apiProvider.justRequest(.follow(request)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.getUserInfo()
      case .failure:
        print("failure")
      }
    }
  }

  @objc private func showOtherFollowers() {
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feeds.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? ThumbnailCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.configure(feed: feeds[indexPath.row])
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let videoFeedViewController = VideoFeedViewController(
      type: .userProfile,
      currentId: feeds[indexPath.row].id,
      userId: feeds[indexPath.row].userId
    )
    self.navigationController?.pushViewController(videoFeedViewController, animated: true)
  }
}
