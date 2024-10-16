//
//  String+.swift
//  Common
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension String {
  func heightWithConstrainedWidth() -> CGFloat {
    let constraintRect = CGSize(
      width: CGFloat(220),
      height: .greatestFiniteMagnitude
    )
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: [
        .usesLineFragmentOrigin,
        .usesFontLeading
      ],
      attributes: [NSAttributedString.Key.font: RecordyFont.body2Long.font],
      context: nil
    )
    return boundingBox.height
  }
  
  public func timeStringToSeconds() -> Int {
    let components = self.split(separator: ":")
    guard components.count == 2,
          let minutes = Int(components[0]),
          let seconds = Int(components[1]) else {
      return 100
    }
    return (minutes * 60) + seconds
  }
  
  public func removeQueryParameters() -> String? {
    if let urlComponents = URLComponents(string: self) {
      var modifiedComponents = urlComponents
      modifiedComponents.query = nil
      return modifiedComponents.string
    }
    return nil
  }
  
  public func keywordEncode() -> String? {
    guard let data = self.data(using: .utf8) else { return nil }
    return data.base64EncodedString()
  }
  
  public func matches(pattern: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
    let range = NSRange(location: 0, length: self.utf16.count)
    let matches = regex.matches(in: self, range: range)
    return !matches.isEmpty
  }
  
  public func isNicknamePatternValid(_ nickname: String) -> Bool {
    let pattern = "^[가-힣0-9._]{1,10}$"
    return nickname.matches(pattern: pattern)
  }
}
