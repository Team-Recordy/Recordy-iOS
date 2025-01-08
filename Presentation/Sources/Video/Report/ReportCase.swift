//
//  ReportCase.swift
//  Presentation
//
//  Created by 한지석 on 10/21/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

enum ReportCase: CaseIterable {
  /// 스팸 게시물
  case spam
  /// 음란물 게시물
  case pornography
  /// 불법 게시물
  case illegal
  /// 욕설 게시물
  case swear
  /// 개인정보 위반
  case privacy
  /// 불쾌한
  case unpleasant
  /// 기타
  case etc

  var title: String {
    switch self {
    case .spam:
      "스팸 홍보/도배입니다."
    case .pornography:
      "음란물입니다."
    case .illegal:
      "불법 정보를 포함하고 있습니다."
    case .swear:
      "욕설/생명 경시/혐오/차별적인 표현입니다,"
    case .privacy:
      "개인정보가 노출되어있습니다."
    case .unpleasant:
      "불쾌한 표현이 있습니다."
    case .etc:
      "기타"
    }
  }
}
