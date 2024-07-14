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
    let fetchedFollowers: [Follower] = [
      Follower(username: "닉네임1", isFollowing: false, profileImage: CommonAsset.profileImage.image),
      Follower(username: "닉네임2", isFollowing: true, profileImage: CommonAsset.profileImage.image),
    ]
    followers.value = fetchedFollowers
    isEmpty.value = fetchedFollowers.isEmpty
  }
  
  func toggleFollow(at index: Int) {
    guard index < followers.value.count else { return }
    followers.value[index].isFollowing.toggle()
    followers.value = followers.value
  }
}

