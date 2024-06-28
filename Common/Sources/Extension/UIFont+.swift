//
//  UIFont+.swift
//  Common
//
//  Created by 한지석 on 6/28/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UIFont {
  static func pretendard(
    type: CommonFontConvertible,
    size: CGFloat
  ) -> UIFont {
    guard let font = UIFont(
      name: type.name,
      size: size
    ) else {
      return UIFont.systemFont(ofSize: size)
    }
    return font
  }
}

