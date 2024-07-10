//
//  Keyword.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public enum Keyword {
  case exotic
  case quiet
  case trendy
  case sensuous
  case cute
  case fanAttracting
  case fun
  case cozy
  case classic
  case concentration
  case neat
  case scary
  case intense

  public var title: String {
    switch self {
    case .exotic:
      "이색적인"
    case .quiet:
      "조용한"
    case .trendy:
      "트렌디한"
    case .sensuous:
      "감각적인"
    case .cute:
      "귀여운"
    case .fanAttracting:
      "덕후몰이"
    case .fun:
      "재밌는"
    case .cozy:
      "아늑한"
    case .classic:
      "클래식한"
    case .concentration:
      "집중하기 좋은"
    case .neat:
      "깔끔한"
    case .scary:
      "무서운"
    case .intense:
      "강렬한"
    }
  }
}
