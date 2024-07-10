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
}
