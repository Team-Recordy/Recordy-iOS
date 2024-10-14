//
//  ViskitFont.swift
//  Common
//
//  Created by Chandrala on 10/14/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public enum ViskitFont {
  //MARK: Title
  case title1
  case title2
  case title3
  case title3Semibold
  case title4
  case subtitle
  //MARK: Body
  case body1
  case body2
  case body2Semibold
  case body2Bold
  case body2Long
  case caption1Regular
  case caption1Medium
  case caption1MediumUnderline
  case caption1Semibold
  case caption2Regular
  case caption2Medium
}

extension ViskitFont {
  public var font: UIFont {
    switch self {
    case .title1:
      UIFont(font: CommonFontFamily.Pretendard.bold, size: 22)!
    case .title2:
      UIFont(font: CommonFontFamily.Pretendard.bold, size: 20)!
    case .title3:
      UIFont(font: CommonFontFamily.Pretendard.bold, size: 18)!
    case .title3Semibold:
      UIFont(font: CommonFontFamily.Pretendard.semiBold, size: 18)!
    case .title4:
      UIFont(font: CommonFontFamily.Pretendard.extraBold, size: 17)!
    case .subtitle:
      UIFont(font: CommonFontFamily.Pretendard.bold, size: 16)!
    case .body1:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 16)!
    case .body2:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 14)!
    case .body2Semibold:
      UIFont(font: CommonFontFamily.Pretendard.semiBold, size: 14)!
    case .body2Bold:
      UIFont(font: CommonFontFamily.Pretendard.bold, size: 14)!
    case .body2Long:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 14)!
    case .caption1Regular:
      UIFont(font: CommonFontFamily.Pretendard.regular, size: 12)!
    case .caption1Medium:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 12)!
    case .caption1MediumUnderline:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 12)!
    case .caption1Semibold:
      UIFont(font: CommonFontFamily.Pretendard.semiBold, size: 12)!
    case .caption2Regular:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 10)!
    case .caption2Medium:
      UIFont(font: CommonFontFamily.Pretendard.medium, size: 10)!
    }
  }
}
