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
          let followerList = response.content.map {
            Follower(
              id: $0.userInfo.id,
              username: $0.userInfo.nickname,
              isFollowing: $0.following,
              profileImage: $0.userInfo.profileImageUrl
            )
          }
          self.followers.value = followerList
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
        let followList = response.content.map {
          Follower(
            id: $0.id,
            username: $0.nickname,
            isFollowing: true,
            profileImage: $0.profileImageUrl
          )
        }
        self.followers.value = followList.reversed()
      case .failure(let failure):
        print(failure)
      }
    }
  }

  func toggleFollow(at index: Int) {
    guard index < followers.value.count else { return }
    followers.value[index].isFollowing.toggle()
    followers.value = followers.value
  }
}

