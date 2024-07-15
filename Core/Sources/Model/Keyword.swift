//
//  Keyword.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public enum Keyword: CaseIterable {
  case all
  case sensitive
  case intensive
  case cute
  case clean
  case nerdy
  case cozy
  case exotic
  case fun
  case quiet
  case concentrate
  case classic
  case trendy

  public var title: String {
    switch self {
    case .all:
      "전체"
    case .sensitive:
      "감각적인"
    case .intensive:
      "강렬한"
    case .cute:
      "귀여운"
    case .clean:
      "깔끔한"
    case .nerdy:
      "덕후몰이"
    case .cozy:
      "아늑한"
    case .exotic:
      "이색적인"
    case .fun:
      "재밋는"
    case .quiet:
      "조용한"
    case .concentrate:
      "집중하기 좋은"
    case .classic:
      "클래식한"
    case .trendy:
      "트렌디한"
    }
  }

  public var width: CGFloat {
    switch self {
    case .all:
      return 41 //2
    case .intensive, .cute, .clean, .cozy, .fun, .quiet:
      return 52 //3
    case .sensitive, .nerdy, .exotic, .classic, .trendy:
      return 62 //4
    case .concentrate:
      return 86
    }
  }
}
