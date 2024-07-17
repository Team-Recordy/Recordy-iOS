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

public class ProfileViewController: UIViewController {
  
  let profileInfoView = ProfileInfoView()
  let segmentControlView = ProfileSegmentControllView()
  let tasteView = TasteView()
  let recordView = MyRecordView()
  let bookmarkView = BookMarkView()
  
  var controlType: ControlType = .taste {
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
    getBookmarkedRecordList()
    getTasteRecordList()
    print(KeychainManager.shared.read(token: .AccessToken))
    
  }
  
  func setStyle() {
    
  }
  
  func setUI() {
    self.view.addSubviews(
      profileInfoView,
      segmentControlView,
      tasteView,
      recordView,
      bookmarkView
    )
  }
  
  func setAutoLayout() {
    profileInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
      $0.width.equalTo(335.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }
    
    segmentControlView.snp.makeConstraints {
      $0.top.equalTo(profileInfoView.snp.bottom).offset(35.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
    }
    
    tasteView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    recordView.snp.makeConstraints {
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
  }
  
  func controlTypeChanged() {
    tasteView.isHidden = controlType == .taste ? false : true
    recordView.isHidden = controlType == .record ? false : true
    bookmarkView.isHidden = controlType == .bookmark ? false : true
  }
  
  func getBookmarkedRecordList() {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetBookmarkedListRequest(cursorId: 0, size: 10)
    apiProvider.requestResponsable(.getBookmarkedRecordList(request), DTO.GetBookmarkedListResponse.self) { [weak self] result in
      guard let self = self else { return }
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
        self.bookmarkView.getBookmarkList(feeds: feeds)
      case .failure(let failure):
        print("@Log - \(failure.localizedDescription)")
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
        let tasteDataList = response.preference.count
        for i in 0..<tasteDataList {
          print("@Log - \(response.preference[i])")
          let percentage = Int(response.preference[i][1]) ?? 0
          let taste = TasteData(title: response.preference[i][0], percentage: percentage, type: TasteCase(rawValue: i)!)
          tasteData.append(taste)
        }
        DispatchQueue.main.async {
          self.tasteView.updateDataViews(tasteData)
        }
      case .failure(let failure):
        print("@Log - \(failure.localizedDescription)")
      }
    }
  }
}

extension ProfileViewController: ControlTypeDelegate {
  func sendControlType(_ type: ControlType) {
    self.controlType = type
  }
}
