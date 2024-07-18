//
//  FollowingViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core
import Common

class FollowingViewModel {
  var followings: Bindable<[Following]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(true)
  
  func fetchFollowings() {
    let fetchedFollowings: [Following] = [
//      Following(
//        username: "유영",
//        profileImage: CommonAsset.yoo0profile.image,
//        isFollowing: false,
//        isFollowButtonVisible: false
//      ),
//      Following(
//        username: "닉네임",
//        profileImage: CommonAsset.profileImage.image,
//        isFollowing: false,
//        isFollowButtonVisible: true
//      ),
//      Following(
//        username: "닉네임",
//        profileImage: CommonAsset.profileImage.image,
//        isFollowing: true,
//        isFollowButtonVisible: true
//      ),
//      Following(
//        username: "닉네임",
//        profileImage: CommonAsset.profileImage.image,
//        isFollowing: false,
//        isFollowButtonVisible: true
//      )
    ]
    followings.value = fetchedFollowings
    isEmpty.value = fetchedFollowings.isEmpty
  }
  
  func toggleFollow(at index: Int) {
    guard index < followings.value.count else { return }
    followings.value[index].isFollowing.toggle()
    followings.value = followings.value
  }
}

