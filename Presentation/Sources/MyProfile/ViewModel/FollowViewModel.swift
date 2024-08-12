//
//  FollowersViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import UIKit

import Common
import Core

class FollowViewModel {

  let followType: FollowType
  var followers: Bindable<[Follower]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(false)
  let apiProvider = APIProvider<APITarget.Users>()

  init(followType: FollowType) {
    self.followType = followType
  }

  func fetchUsers() {
    switch followType {
    case .follower:
      getFollowerList()
    case .following:
      getFollowingList()
    }
  }
  
  func getFollowerList() {
    let request = DTO.GetFollowerListRequest(cursorId: 0, size: 100)
    apiProvider.requestResponsable(
      .getfollowerList(request),
      DTO.GetFollowerListResponse.self
    ) { [weak self]
        result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          var followerList = response.content.map {
            Follower(
              id: $0.userInfo.id,
              username: $0.userInfo.nickname,
              isFollowing: $0.following,
              profileImage: $0.userInfo.profileImageUrl
            )
          }
          followerList = self.filterSpecialAccount(in: followerList)
          self.followers.value = followerList
          self.isEmpty.value = followerList.isEmpty
        case .failure(let failure):
          print(failure)
        }
      }
  }

  func getFollowingList() {
    let request = DTO.GetFollowListRequest(cursorId: 0, size: 100)
    apiProvider.requestResponsable(.getfollowList(request), DTO.GetFollowListResponse.self) { [weak self]
      result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        var followList = response.content.map {
          Follower(
            id: $0.id,
            username: $0.nickname,
            isFollowing: true,
            profileImage: $0.profileImageUrl
          )
        }
        followList = self.filterSpecialAccount(in: followList)
        self.followers.value = followList
        self.isEmpty.value = followList.isEmpty
      case .failure(let failure):
        print(failure)
      }
    }
  }
  
  func filterSpecialAccount(in list: [Follower]) -> [Follower] {
    var updatedList = list.filter {$0.username != "유영"}
    let specialAccount = Follower(id: 0, username: "유영", isFollowing: true, profileImage: "")
    updatedList.append(specialAccount)
    return updatedList
  }

  func toggleFollow(at index: Int) {
    guard index < followers.value.count else { return }
    followers.value[index].isFollowing.toggle()
    followers.value = followers.value
  }
}

