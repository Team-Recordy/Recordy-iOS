//
//  KeychainManager.swift
//  Core
//
//  Created by 한지석 on 7/2/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public class KeychainManager {

  static public let shared = KeychainManager()
  let service = "com.recordy.app.recordy"

  private init() { }

  public func create(
    token: TokenType,
    value: String
  ) {
    /// Keychain Query
    let keychainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: token.account,
      kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
    ]

    /// Keychain의 Key값에 중복이 생길경우 저장할 수 없으므로 기존의 것을 삭제
    SecItemDelete(keychainQuery)

    /// 생성
    let status: OSStatus = SecItemAdd(keychainQuery, nil)
    assert(status == noErr, "@Log - Failed to save token")
  }

  public func read(
    token: TokenType
  ) -> String? {

    let keychainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: token.account,
      /// CFData로 불러오는 것
      kSecReturnData: true,
      /// 중복되는 경우 하나의 값만 가져오게 하도록
      kSecMatchLimit: kSecMatchLimitOne
    ]

    /// CFData -> AnyObject -> Data
    var cfDataToAnyObject: AnyObject?
    let status = SecItemCopyMatching(
      keychainQuery,
      &cfDataToAnyObject
    )

    if status == errSecSuccess {
      let retrievedData = cfDataToAnyObject as! Data
      let value = String(
        data: retrievedData,
        encoding: .utf8
      )
      return value
    } else {
      print("@Log - Failed to read token - status code == \(status)")
      return nil
    }
  }

  public func delete(
    token: TokenType
  ) {
    let keychainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: token.account
    ]

    let status = SecItemDelete(keychainQuery)
    assert(status == noErr, "@Log - Failed to delete token")
  }
}
