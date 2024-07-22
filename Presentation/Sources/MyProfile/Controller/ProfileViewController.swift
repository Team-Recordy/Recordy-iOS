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
  case taste = "내 취향"
  case record = "내 기록"
  case bookmark = "북마크"
}

@available(iOS 16.0, *)
public class ProfileViewController: UIViewController {

  let profileInfoView = ProfileInfoView()
  let segmentControlView = ProfileSegmentControllView()
  let tasteView = TasteView()
  let tasteEmptyView = TasteEmptyView()
  let myRecordView = MyRecordView()
  let bookmarkView = BookmarkView()
  var user: User?

  var controlType: ControlType = .taste {
    didSet {
      controlTypeChanged()
    }
  }
  var fetchedData: [TasteData] = []

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
    getBookmarkedRecordList()
    getTasteRecordList()
    getMyRecordList()
    getUserProfile()
    setObserver()
  }

  public override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: .updateDidComplete, object: nil)
  }

  func setObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleUploadCompletion),
      name: .updateDidComplete,
      object: nil
    )
  }

  @objc private func handleUploadCompletion(_ notification: Notification) {
    guard let state = notification.userInfo?["state"] as? String,
          let message = notification.userInfo?["message"] as? String else {
      return
    }
    if state == "success" {
      showToast(status: .complete, message: message, height: 44)
      getMyRecordList()
    } else {
      showToast(status: .warning, message: message, height: 44)
    }
  }

  func setStyle() {
    self.title = "프로필"
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
      tasteView,
      myRecordView,
      bookmarkView,
      tasteEmptyView
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

    tasteView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }

    tasteEmptyView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
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
    tasteEmptyView.delegate = self
    bookmarkView.delegate = self
    myRecordView.delegate = self
  }

  func updateTasteView(type: Bool) {
    if type {
      if fetchedData.isEmpty {
        tasteEmptyView.isHidden = false
        tasteView.isHidden = true
      } else {
        tasteEmptyView.isHidden = true
        tasteView.isHidden = false
        tasteView.updateDataViews(self.fetchedData)
      }
    } else {
      tasteEmptyView.isHidden = true
      tasteView.isHidden = true
    }
  }

  func controlTypeChanged() {
    updateTasteView(type: controlType == .taste)
    myRecordView.isHidden = controlType == .record ? false : true
    bookmarkView.isHidden = controlType == .bookmark ? false : true
  }

  private func setUserProfile() {
    guard let user = user else { return }
    let followerAttributedText = NSMutableAttributedString(string: "\(user.followerCount)", attributes: [.font: RecordyFont.body2.font])
    followerAttributedText.append(NSAttributedString(string: " 명의 팔로워", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    self.profileInfoView.followerButton.setAttributedTitle(followerAttributedText, for: .normal)
    let follwingAttributedText = NSMutableAttributedString(string: "\(user.followingCount)", attributes: [.font: RecordyFont.body2.font])
    follwingAttributedText.append(NSAttributedString(string: " 명의 팔로잉", attributes: [.font: RecordyFont.body2.font, .foregroundColor: CommonAsset.recordyGrey03.color]))
    self.profileInfoView.followingButton.setAttributedTitle(follwingAttributedText, for: .normal)
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
          id: response.id,
          nickname: response.nickname,
          followerCount: response.followerCount,
          followingCount: response.followingCount,
          isFollowing: response.isFollowing,
          profileImage: response.profileImageUrl
        )
        self.setUserProfile()
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
        let feeds = response.content.map {
          Feed(
            id: $0.recordInfo.id,
            userId: $0.recordInfo.uploaderId,
            location: $0.recordInfo.location,
            nickname: $0.recordInfo.uploaderNickname,
            description: $0.recordInfo.content,
            bookmarkCount: $0.recordInfo.bookmarkCount,
            isBookmarked: $0.isBookmark,
            videoLink: $0.recordInfo.fileUrl.videoUrl,
            thumbnailLink: $0.recordInfo.fileUrl.thumbnailUrl,
            isMine: $0.recordInfo.isMine
          )
        }
        self.bookmarkView.getBookmarkList(feeds: feeds)
      case .failure(let failure):
        print("@Log - \(failure.localizedDescription)")
      }
    }
  }

  func getMyRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let request = DTO.GetUserRecordListRequest(
      otherUserId: userId,
      cursorId: 0,
      size: 100
    )
    apiProvider.requestResponsable(.getUserRecordList(request), DTO.GetUserRecordListResponse.self) {[weak self]
      result in
      guard let self = self else {return}
      switch result {
      case .success(let response):
        let feeds = response.content.map {
          Feed(
            id: $0.recordInfo.id,
            userId: $0.recordInfo.uploaderId,
            location: $0.recordInfo.location,
            nickname: $0.recordInfo.uploaderNickname,
            description: $0.recordInfo.content,
            bookmarkCount: $0.recordInfo.bookmarkCount,
            isBookmarked: $0.isBookmark,
            videoLink: $0.recordInfo.fileUrl.videoUrl,
            thumbnailLink: $0.recordInfo.fileUrl.thumbnailUrl,
            isMine: $0.recordInfo.isMine
          )
        }
        self.myRecordView.getMyRecordList(feeds:feeds)
      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }

  func getTasteRecordList() {
    let apiProvider = APIProvider<APITarget.Preference>()
    apiProvider.requestResponsable(.getPreference, DTO.GetPreferenceResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        var tasteData: [TasteData] = []
        guard !response.preference.isEmpty else {
          DispatchQueue.main.async {
            self.tasteView.updateDataViews([])
          }
          return
        }
        for i in 0..<response.preference.count {
          let percentage = Int(response.preference[i][1]) ?? 0
          let taste = TasteData(title: response.preference[i][0], percentage: percentage, type: TasteCase(rawValue: i)!)
          tasteData.append(taste)
        }
        DispatchQueue.main.async {
          self.fetchedData = tasteData
          self.updateTasteView(type: self.controlType == .taste)
        }
      case .failure(let failure):
        print("@Log - \(failure.localizedDescription)")
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
    apiProvider.justRequest(.postBookmark(request)) { result in
      switch result {
      case .success(let success):
        print(success)
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

@available(iOS 16.0, *)
extension ProfileViewController: TasteViewDelegate {
  func tasteViewUploadFeedTapped() {
    let uploadViewController = UploadVideoViewController()
    let navigationController = BaseNavigationController(rootViewController: uploadViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }
}
