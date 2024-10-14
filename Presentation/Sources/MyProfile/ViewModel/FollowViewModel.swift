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
  
  let apiProvider = APIProvider<APITarget.Users>()
  
  var followersDidChange: (([Follow]) -> Void)?
  var isEmptyDidChange: ((Bool) -> Void)?
  
  init(followType: FollowType) {
    self.followType = followType
    fetchUsers()
  }
  
  func fetchUsers() {
    switch followType {
    case .follower:
      getFollowerList()
    case .following:
      getFollowingList()
    }
  }
  
  private func getFollowerList() {
    let request = DTO.GetFollowerListRequest(cursorId: cursorId, size: 100)
    apiProvider.requestResponsable(
      .getfollowerList(request),
      DTO.GetFollowerListResponse.self
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.handleFollowerResponse(response: response)
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  func getFollowingList() {
    let request = DTO.GetFollowListRequest(size: 10)
    
    apiProvider.requestResponsable(.getfollowList(request), DTO.GetFollowListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.handleFollowingResponse(response: response)
      case .failure(let failure):
        print("Decoding failed: \(failure)")
      }
    }
  }
  
  private func handleFollowerResponse(response: DTO.GetFollowerListResponse) {
    let followerList = response.content.map {
      Follow(
        followState: .follower,
        userId: String($0.userInfo.id),
        profileImage: $0.userInfo.profileImageUrl,
        nickname: $0.userInfo.nickname,
        isFollowing: $0.following
      )
    }
    self.followers = followerList
  }
  
  private func handleFollowingResponse(response: DTO.GetFollowListResponse) {
    let followList = response.content.map {
      Follow(
        followState: .following,
        userId: String($0.id),
        profileImage: $0.profileImageUrl,
        nickname: $0.nickname,
        isFollowing: true
      )
    }
    self.followers = followList.reversed()
  }
  
  func toggleFollow(at index: Int) {
    guard index < followers.count else { return }
    followers[index].isFollowing.toggle()
    followersDidChange?(followers)
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
        print("Follow request successful")
      case .failure(let failure):
        print("Follow request failed: \(failure)")
        self.toggleFollow(at: index)
      }
    }
  }
}
