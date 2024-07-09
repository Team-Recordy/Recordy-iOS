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
  case title3
  case subtitle
  //MARK: Body
  case body1
  case body1Regular
  case body2
  case body2Bold
  case body2Long
  case caption1
  case caption1Underline
  case caption2
  //MARK: Button
  case button1
  case button2
  //MARK: Bubble Grahic
  case number1
  case number2
  case number3
  case keyword1
  case keyword2
  case keyword3
  
}

extension RecordyFont {
  public var font: UIFont {
    switch self {
    case .headline:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 26)
    case .title1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 22)
    case .title2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 20)
    case .title3:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 18)
    case .subtitle:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 16)
    case .body1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 16)
    case .body1Regular:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.regular, size: 16)
    case .body2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 14)
    case .body2Bold:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.bold, size: 14)
    case .body2Long:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 14)
    case .caption1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 12)
    case .caption1Underline:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 12)
    case .caption2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 12)
    case .button1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.semiBold, size: 16)
    case .button2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 14)
    case .number1:
      UIFont.pretendard(type: CommonFontFamily.CocogoosePro.thin, size: 42)
    case .number2:
      UIFont.pretendard(type: CommonFontFamily.CocogoosePro.thin, size: 32)
    case .number3:
      UIFont.pretendard(type: CommonFontFamily.CocogoosePro.thin, size: 20)
    case .keyword1:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.medium, size: 17)
    case .keyword2:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.regular, size: 14)
    case .keyword3:
      UIFont.pretendard(type: CommonFontFamily.Pretendard.regular, size: 12)
    }
  }
}
