//
//  FollowersViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation


class FollowersViewModel {
  var followers: Bindable<[Follower]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(true)
  
  func fetchFollowers() {
    let fetchedFollowers: [Follower] = [
      Follower(username: "닉네임", isFollowing: false),
      Follower(username: "닉네임", isFollowing: true)
    ]
    followers.value = fetchedFollowers
    isEmpty.value = fetchedFollowers.isEmpty
  }
}

class Bindable<T> {
  var value: T {
    didSet {
      observer?(value)
    }
  }
  
  private var observer: ((T) -> Void)?
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(_ observer: @escaping (T) -> Void) {
    self.observer = observer
    observer(value)
  }
}
