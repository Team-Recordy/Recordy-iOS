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
//      $0.top.equalTo(profileInfoView.snp.bottom).offset(35.adaptiveHeight)
//      $0.horizontalEdges.equalToSuperview()
//      $0.height.equalTo(40.adaptiveHeight)
      
      $0.top.equalTo(profileInfoView.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
//      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(34)
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
    let followerAttributedText = NSMutableAttributedString(string: "\(user.follower.count)", attributes: [.font: RecordyFont.body2.font])
    followerAttributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    self.profileInfoView.followerButton.setAttributedTitle(followerAttributedText, for: .normal)
    let followingAttributedText = NSMutableAttributedString(string: "\(user.following?.count ?? 0)", attributes: [.font: RecordyFont.body2.font])
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
          follower: [],
          following: [],
          isFollowing: response.isFollowing,
          profileImage: response.profileImageUrl,
          feeds: [],
          bookmarkedFeeds: [],
          loginState: .apple,
          recordCount: response.recordCount,
          followerCount: response.followerCount,
          followingCount: response.followingCount,
          bookmarkCount: response.bookmarkCount
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
        let feeds = response.content.map { content in
          Feed(id: content.recordInfo.id,
               userId: content.recordInfo.uploaderId,
               location: content.recordInfo.location,
               placeInfo: PlaceInfo(
                feature: self.getPlaceFeature(from: content.recordInfo.location),
                title: content.recordInfo.location,
                duration: ""
               ),
               nickname: content.recordInfo.uploaderNickname,
               description: content.recordInfo.content,
               isBookmarked: content.isBookmark,
               bookmarkCount: content.recordInfo.bookmarkCount,
               videoLink: content.recordInfo.fileUrl.videoUrl,
               thumbnailLink: content.recordInfo.fileUrl.thumbnailUrl,
               isMine: content.recordInfo.isMine)
        }
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.myRecordView.getMyRecordList(feeds: feeds)
          self.user?.feeds = feeds
          self.setUserProfile()
        }
      case .failure(let failure):
        print("Failed to get user record list: \(failure)")
        DispatchQueue.main.async {
          self.showErrorAlert(message: "기록을 불러오는데 실패했습니다. 다시 시도해주세요.")
        }
      }
    }
  }
  
  private func getPlaceFeature(from location: String) -> PlaceFeature {
    if location.lowercased().contains("free") {
      return .free
    } else if location.lowercased().contains("closing soon") {
      return .closingSoon
    } else {
      return .all
    }
  }
  
  func getBookmarkedRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetBookmarkedListRequest(cursorId: 0, size: 100)
    apiProvider.requestResponsable(.getBookmarkedRecordList(request), DTO.GetBookmarkedListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let feeds = response.content.map { content in
          Feed(id: content.recordInfo.id,
               userId: content.recordInfo.uploaderId,
               location: content.recordInfo.location,
               placeInfo: PlaceInfo(
                feature: self.getPlaceFeature(from: content.recordInfo.location),
                title: content.recordInfo.location,
                duration: ""
               ),
               nickname: content.recordInfo.uploaderNickname,
               description: content.recordInfo.content,
               isBookmarked: true,
               bookmarkCount: content.recordInfo.bookmarkCount,
               videoLink: content.recordInfo.fileUrl.videoUrl,
               thumbnailLink: content.recordInfo.fileUrl.thumbnailUrl,
               isMine: false)
        }
        DispatchQueue.main.async {
          self.bookmarkView.getBookmarkList(feeds: feeds)
          self.user?.bookmarkedFeeds = feeds
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
  
  func showErrorAlert(message: String) {
    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
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
