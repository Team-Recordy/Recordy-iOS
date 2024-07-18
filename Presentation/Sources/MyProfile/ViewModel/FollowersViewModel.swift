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

class FollowerViewModel {
  var followers: Bindable<[Follower]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(true)
  
  func fetchFollowers() {
    getFollowerList()
  }
  
  func getFollowerList() {
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.GetFollowerListRequest(cursorId: 0, size: 10)
    apiProvider.requestResponsable(
      .getfollowerList(request),
      DTO.GetFollowerListResponse.self) { [weak self]
        result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          let followerList = response.content.map {
            Follower(
              username: $0.userInfo.nickname,
              isFollowing: $0.following,
              profileImage: CommonAsset.profileImage.image
            )
          }
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

