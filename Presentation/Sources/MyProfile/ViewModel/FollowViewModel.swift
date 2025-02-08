//
//  FollowersViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Common

import Core

class FollowViewModel {
  
  let followType: FollowType
  var followers: [Follow] = [] {
    didSet {
      followersDidChange?(followers)
      isEmptyDidChange?(followers.isEmpty)
    }
  }
  var cursorId: Int? = nil
  var hasNext: Bool = true
  
  var followersDidChange: (([Follow]) -> Void)?
  var isEmptyDidChange: ((Bool) -> Void)?
  let apiProvider = APIProvider<APITarget.Users>()
  
  init(followType: FollowType) {
    self.followType = followType
  }
  
  func fetchUsers() {
    if hasNext {
      switch followType {
      case .follower:
        getFollowerList()
      case .following:
        getFollowingList()
      }
    }
  }
  
  
  private func getFollowerList() {
    let requestCursorId = (cursorId == -1) ? nil : cursorId
    let request = DTO.GetFollowerListRequest(
      cursorId: requestCursorId,
      size: 100
    )
    
    apiProvider.requestResponsable(
      .getFollowerList(request),
      DTO.GetFollowerListResponse.self
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.handleFollowerResponse(response: response)
      case .failure(let failure):
        print("실패 \(failure)")
      }
    }
  }
  
  private func getFollowingList() {
    let requestCursorId = (cursorId == -1) ? nil : cursorId
    let request = DTO.GetFollowingListRequest(
      cursorId: requestCursorId,
      size: 100
    )
    apiProvider.requestResponsable(
      .getFollowingList(request),
      DTO.GetFollowingListResponse.self
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.handleFollowingResponse(response: response)
      case .failure(let failure):
        print("getFollowingList 실패 \(failure)")
      }
    }
  }
  
  private func handleFollowerResponse(response: DTO.GetFollowerListResponse) {
    let followerList = response.content.map {
      Follow(
        followState: .follower,
        userId: String($0.id),
        profileImage: $0.profileImageUrl,
        nickname: $0.nickname,
        isFollowing: $0.isFollowing
      )
    }
    
    self.followers.append(contentsOf: followerList)
    self.cursorId = response.nextCursor
    self.hasNext = response.hasNext
  }
  
  private func handleFollowingResponse(response: DTO.GetFollowingListResponse) {
    let followList = response.content.map {
      Follow(
        followState: .following,
        userId: String($0.id),
        profileImage: $0.profileImageUrl,
        nickname: $0.nickname,
        isFollowing: $0.isFollowing
      )
    }
    
    self.followers.append(contentsOf: followList)
    self.cursorId = response.nextCursor
    self.hasNext = response.hasNext
  }
  
  func postFollowRequest(at index: Int) {
    guard index < followers.count else { return }
    let follower = followers[index]
    let request = DTO.FollowRequest(followingId: Int(follower.userId) ?? 0)
    
    toggleFollow(at: index)
    
    apiProvider.justRequest(.follow(request)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        print("Follow request 성공")
      case .failure(let failure):
        print("Follow request 실패")
        self.toggleFollow(at: index)
      }
    }
  }
  
  func toggleFollow(at index: Int) {
    guard index < followers.count else { return }
    followers[index].isFollowing.toggle()
    followersDidChange?(followers)
  }
}
