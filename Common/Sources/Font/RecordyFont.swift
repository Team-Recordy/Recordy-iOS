//
//  RecordyFont.swift
//  Common
//
//  Created by 한지석 on 6/28/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public enum RecordyFont {
  //MARK: Title
  case headline
  case title1
  case title2
  case subtitle
  //MARK: Body
  case body1
  case body1Regular
  case body2
  case body2Long
  case caption
  //MARK: Button
  case button1
  case button2
}

extension RecordyFont {
  public var font: UIFont {
    switch self {
    case .headline:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 26)
    case .title1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 20)
    case .title2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 18)
    case .subtitle:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 16)
    case .body1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 16)
    case .body1Regular:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.regular, size: 16)
    case .body2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 14)
    case .body2Long:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 14)
    case .caption:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 12)
    case .button1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.semiBold, size: 16)
    case .button2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 14)
    }
  }
}
