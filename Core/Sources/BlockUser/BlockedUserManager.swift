//
//  BlockUserManager.swift
//  Core
//
//  Created by Rama on 5/18/25.
//  Copyright © 2025 com. All rights reserved.
//

import UIKit

public struct BlockedUserManager {
  private static let blockedKey = "blockedUserInfos"
  
  public static func getBlockedUsers() -> [UserInfoForBlock] {
    guard let data = UserDefaults.standard.data(forKey: blockedKey),
          let users = try? JSONDecoder().decode([UserInfoForBlock].self, from: data) else {
      return []
    }
    return users
  }
  
  public static func addBlockedUser(_ user: UserInfoForBlock) {
    var users = getBlockedUsers()
    guard !users.contains(where: { $0.id == user.id }) else { return }
    users.append(user)
    if let encoded = try? JSONEncoder().encode(users) {
      UserDefaults.standard.set(encoded, forKey: blockedKey)
    }
  }
  
  public static func isBlocked(userId: Int) -> Bool {
    return getBlockedUsers().contains(where: { $0.id == userId })
  }
  
  public static func filterBlockedFeeds(_ feeds: [Feed]) -> [Feed] {
    let blockedIds = getBlockedUsers().map { $0.id }
    return feeds.filter { !blockedIds.contains($0.uploaderId) }
  }
}
