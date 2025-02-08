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
  
  private var feeds: [Feed] = []
  private let id: Int
  private var cursorId: Int = 0
  
  init(id: Int) {
    self.id = id
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    getUserProfile()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateProfile),
      name: .updateDidComplete,
      object: nil
    )
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateProfile()
    self.tabBarController?.tabBar.isHidden = false
  }
  
  @objc private func updateProfile() {
    getUserProfile()
    getMyRecordList()
    getBookmarkedRecordList()
    
    DispatchQueue.main.async {
      self.myRecordView.collectionView.reloadData()
    }
  }
  
  func setStyle() {
    view.backgroundColor = CommonAsset.viskitBG.color
    configureNavigationBar()
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
      $0.top.equalTo(profileInfoView.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
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
  
  private func configureNavigationBar() {
    navigationItem.title = "프로필"
    navigationItem.backButtonTitle = ""
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.tintColor = .white
      navigationBar.titleTextAttributes = [
        .foregroundColor: CommonAsset.viskitGray01.color,
        .font: ViskitFont.title3.font
      ]
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
    guard let user = user else {
      return
    }
    let followerAttributedText = NSMutableAttributedString(
      string: "\(user.followerCount)",
      attributes: [.font: RecordyFont.body2.font]
    )
    followerAttributedText
      .append(
        NSAttributedString(string: " 명의 팔로워",
                           attributes: [
                            .font: RecordyFont.body2.font,
                            .foregroundColor: CommonAsset.recordyGrey03.color
                           ]
                          )
      )
    self.profileInfoView.followerButton
      .setAttributedTitle(
        followerAttributedText,
        for: .normal
      )
    let followingAttributedText = NSMutableAttributedString(
      string: "\(user.followingCount)",
      attributes: [.font: RecordyFont.body2.font]
    )
    followingAttributedText
      .append(
        NSAttributedString(string: " 명의 팔로잉",
                           attributes: [
                            .font: RecordyFont.body2.font,
                            .foregroundColor: CommonAsset.recordyGrey03.color
                           ]
                          )
      )
    self.profileInfoView.followingButton
      .setAttributedTitle(
        followingAttributedText,
        for: .normal
      )
    self.profileInfoView.userName.text = user.nickname
    let url = URL(
      string: user.profileImage
    )!
    self.profileInfoView.profileImage.kf
      .setImage(
        with: url
      )
  }
  
  func getUserProfile() {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.GetProfileRequest(otherUserId: id)
    apiProvider.requestResponsable(
      .getProfile(
        request
      ),
      DTO.GetProfileResponse.self
    ) { [weak self] result in guard let self = self else {return}
      switch result {
      case .success(let response):
        self.user = User(
          id: response.id,
          nickname: response.nickname,
          isFollowing: response.isFollowing,
          profileImage: response.profileImageUrl,
          recordCount: response.recordCount,
          followerCount: response.followerCount,
          followingCount: response.followingCount
        )
        self.setUserProfile()
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  func getMyRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetUserRecordListRequest(
      otherUserId: id,
      cursorId: 0,
      size: 100
    )
    apiProvider.requestResponsable(.getUserRecordList(request),DTO.GetUserRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let feeds = response.content.map {
          Feed(
            id: $0.id,
            videoLink: $0.fileUrl.videoUrl,
            thumbnailLink: $0.fileUrl.thumbnailUrl,
            description: $0.content,
            exhibitionName: $0.exhibitionName,
            placeId: $0.placeId,
            placeName: $0.placeName,
            uploaderId: $0.uploaderId,
            uploaderNickname: $0.uploaderNickname,
            bookmarkCount: $0.bookmarkCount,
            isMine: $0.isMine,
            isBookmarked: $0.isBookmarked
          )
        }
        self.feeds = feeds
        DispatchQueue.main.async {
          self.myRecordView.getMyRecordList(feeds: feeds)
        }
      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }
  
  func getBookmarkedRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetBookmarkedListRequest(size: 100)
    apiProvider.requestResponsable(
      .getBookmarkedRecordList(request),
      DTO.GetBookmarkedListResponse.self
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let feeds = response.content.map { content in
          Feed(
            id: content.id,
            videoLink: content.fileUrl.videoUrl,
            thumbnailLink: content.fileUrl.thumbnailUrl,
            description: content.content,
            exhibitionName: content.exhibitionName,
            placeId: content.placeId,
            placeName: content.placeName,
            uploaderId: content.uploaderId,
            uploaderNickname: content.uploaderNickname,
            bookmarkCount: content.bookmarkCount,
            isMine: content.isMine,
            isBookmarked: content.isBookmarked
          )
        }
        DispatchQueue.main.async {
          self.user?.bookmarkedFeeds = feeds
          self.bookmarkView.getBookmarkList(feeds: feeds)
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  func postBookmark(feed: Feed, completion: ((Result<Void, Error>) -> Void)? = nil) {
    let apiProvider = APIProvider<APITarget.Bookmarks>()
    let request = DTO.PostBookmarkRequest(recordId: feed.id)
    
    apiProvider.justRequest(.postBookmark(request)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        if let recordIndex = self.user?.bookmarkedFeeds?.firstIndex(where: { $0.id == feed.id }) {
          self.bookmarkView.feeds[recordIndex].isBookmarked = !feed.isBookmarked
        }
        //        bookmarkView.updateViewState()
        completion?(.success(()))
      case .failure(let error):
        print("Failed to update bookmark: \(error)")
        completion?(.failure(error))
      }
    }
  }
  
  
  //  private func getPlaceFeature(from location: String) -> PlaceFeature {
  //    if location.lowercased().contains("free") {
  //      return .free
  //    } else if location.lowercased().contains("closing soon") {
  //      return .closingSoon
  //    } else {
  //      return .all
  //    }
  //  }
  
  @objc private func handleBookmarkStateChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let feed = userInfo["feed"] as? Feed else {
      return
    }
    
    postBookmark(feed: feed) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        print("Bookmark updated successfully.")
        DispatchQueue.main.async {
          self.bookmarkView.collectionView.reloadData()
        }
      case .failure(let error):
        print("Failed to update bookmark: \(error)")
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
    let settingViewController = SettingViewController(id: id)
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
  func bookmarkButtonTapped(feed: Feed, completion: @escaping (Result<Void, Error>) -> Void) {
    let apiProvider = APIProvider<APITarget.Bookmarks>()
    let request = DTO.PostBookmarkRequest(recordId: feed.id)
    
    apiProvider.justRequest(.postBookmark(request)) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success:
        DispatchQueue.main.async {
          self.updateProfile()
        }
        completion(.success(()))
        
      case .failure(let error):
        print("Bookmark API 실패: \(error)")
        completion(.failure(error))
      }
    }
  }
  
  func bookmarkFeedTapped(feed: Core.Feed) {
      let videoFeedViewController = VideoFeedViewController(
        type: .bookmarked,
        cursorId: cursorId
      )
      self.navigationController?.pushViewController(videoFeedViewController, animated: true)
  }
}

@available(iOS 16.0, *)
extension ProfileViewController: UserRecordDelegate {
  func userRecordFeedTapped(feed: Feed) {
    let videoFeedViewController = VideoFeedViewController(
      type: .others,
      placeId: feed.id,
      exhibitionId: nil,
      cursorId: cursorId,
      userId: feed.uploaderId
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
