//
//  ProfileViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit
import SnapKit
import Then

import Core
import Common

enum ControlType: String {
  case record = "내 기록"
  case bookmark = "북마크"
}

@available(iOS 16.0, *)
public class ProfileViewController: UIViewController {
  
  let profileInfoView = ProfileInfoView()
  let segmentControlView = ProfileSegmentControllView()
  let myRecordView = MyRecordView()
  let bookmarkView = BookmarkView()
  var user: User?
  
  var controlType: ControlType = .record {
    didSet {
      controlTypeChanged()
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
    setDelegate()
    controlTypeChanged()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateProfile()
    self.title = "프로필"
  }
  
  private func updateProfile() {
    getUserProfile()
    getMyRecordList()
    getBookmarkedRecordList()
  }
  
  func setStyle() {
    let rightButton = UIButton(type: .system)
    rightButton.setImage(CommonAsset.settingIcon.image, for: .normal)
    rightButton.addTarget(
      self,
      action: #selector(settingButtonTapped),
      for: .touchUpInside
    )
    let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    self.navigationItem.rightBarButtonItem = rightBarButtonItem
    
    profileInfoView.followerButton.addTarget(
      self,
      action: #selector(showFollowers),
      for: .touchUpInside
    )
    profileInfoView.followingButton.addTarget(
      self,
      action: #selector(showFollowings),
      for: .touchUpInside
    )
  }
  
  func setUI() {
    self.view.addSubviews(
      profileInfoView,
      segmentControlView,
      myRecordView,
      bookmarkView
    )
  }
  
  func setAutoLayout() {
    profileInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(65)
    }
    
    segmentControlView.snp.makeConstraints {
      $0.top.equalTo(profileInfoView.snp.bottom).offset(35.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(40.adaptiveHeight)
    }
    
    myRecordView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    bookmarkView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
  }
  
  func setDelegate() {
    segmentControlView.delegate = self
    bookmarkView.delegate = self
    myRecordView.delegate = self
  }
  
  func controlTypeChanged() {
    myRecordView.isHidden = controlType != .record
    bookmarkView.isHidden = controlType != .bookmark
  }
  
  private func setUserProfile() {
    guard let user = user else { return }
    let followerAttributedText = NSMutableAttributedString(string: "\(user.followerCount)", attributes: [.font: RecordyFont.body2.font])
    followerAttributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    self.profileInfoView.followerButton.setAttributedTitle(followerAttributedText, for: .normal)
    let followingAttributedText = NSMutableAttributedString(string: "\(user.followingCount)", attributes: [.font: RecordyFont.body2.font])
    followingAttributedText.append(NSAttributedString(string: " 명의 팔로잉", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    self.profileInfoView.followingButton.setAttributedTitle(followingAttributedText, for: .normal)
    self.profileInfoView.userName.text = user.nickname
    let url = URL(string: user.profileImage)!
    self.profileInfoView.profileImage.kf.setImage(with: url)
  }
    
  func getUserProfile() {
    let apiProvider = APIProvider<APITarget.Users>()
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let request = DTO.GetProfileRequest(otherUserId: userId)
    apiProvider.requestResponsable(.getProfile(request), DTO.GetProfileResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.user = User(
          isMine: true,
          id: response.id,
          nickname: response.nickname,
          follower: response.followerCount,
          following: response.followingCount,
          isFollowing: response.isFollowing,
          profileImage: response.profileImageUrl,
          feeds: response.recordCount,
          bookmarkedFeeds: response.bookmarkCount,
          loginState: .apple
        )
        DispatchQueue.main.async {
          self.setUserProfile()
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
    
  func getMyRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let request = DTO.GetUserRecordListRequest(otherUserId: userId, cursorId: 0, size: 100)
    apiProvider.requestResponsable(.getUserRecordList(request), DTO.GetUserRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let feeds = response.content.map { Feed(id: $0.id, userId: $0.uploaderId, location: $0.location, nickname: $0.uploaderNickname, description: $0.content, bookmarkCount: $0.bookmarkCount, isBookmarked: $0.isBookmarked, videoLink: $0.fileUrl.videoUrl, thumbnailLink: $0.fileUrl.thumbnailUrl, isMine: true) }
        DispatchQueue.main.async {
          self.myRecordView.getMyRecordList(feeds: feeds)
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
    
  func getBookmarkedRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetBookmarkedListRequest(cursorId: 0, size: 100)
    apiProvider.requestResponsable(.getBookmarkedRecordList(request), DTO.GetBookmarkedListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let feeds = response.content.map { Feed(id: $0.id, userId: $0.uploaderId, location: $0.location, placeInfo: <#PlaceInfo#>, nickname: $0.uploaderNickname, description: $0.content, isBookmarked: true, bookmarkCount: $0.bookmarkCount, videoLink: $0.fileUrl.videoUrl, thumbnailLink: $0.fileUrl.thumbnailUrl, isMine: false) }
        DispatchQueue.main.async {
          self.bookmarkView.getBookmarkList(feeds: feeds)
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
    
  @objc private func showFollowers() {
    let followerViewController = FollowViewController(followType: .follower)
    self.navigationController?.pushViewController(followerViewController, animated: true)
  }
  
  @objc private func showFollowings() {
    let followerViewController = FollowViewController(followType: .following)
    self.navigationController?.pushViewController(followerViewController, animated: true)
  }
  
  @objc private func settingButtonTapped() {
    let settingViewController = SetViewController()
    self.navigationController?.pushViewController(settingViewController, animated: true)
  }
}

@available(iOS 16.0, *)
extension ProfileViewController: ControlTypeDelegate {
  func sendControlType(_ type: ControlType) {
    self.controlType = type
  }
}

@available(iOS 16.0, *)
extension ProfileViewController: BookmarkDelegate {
  func bookmarkButtonTapped(feed: Feed) {
    let apiProvider = APIProvider<APITarget.Bookmark>()
    let request = DTO.PostBookmarkRequest(recordId: feed.id)
    apiProvider.justRequest(.postBookmark(request)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          self.updateProfile()
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  func bookmarkFeedTapped(feed: Core.Feed) {
    let videoFeedViewController = VideoFeedViewController(
      type: .bookmarked,
      currentId: feed.id
    )
    self.navigationController?.pushViewController(videoFeedViewController, animated: true)
  }
}

@available(iOS 16.0, *)
extension ProfileViewController: UserRecordDelegate {
  func userRecordFeedTapped(feed: Feed) {
    let videoFeedViewController = VideoFeedViewController(
      type: .userProfile,
      currentId: feed.id,
      userId: feed.userId
    )
    self.navigationController?.pushViewController(videoFeedViewController, animated: true)
  }
  
  func uploadFeedTapped() {
    let uploadViewController = UploadVideoViewController()
    let navigationController = BaseNavigationController(rootViewController: uploadViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }
}
