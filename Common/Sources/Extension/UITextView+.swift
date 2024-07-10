//
//  UITextView+.swift
//  Common
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UITextView {
  public static func setLineSpacing(
    _ spacing: CGFloat,
    text: String
  ) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = spacing
    let attributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: paragraphStyle,
        .font: RecordyFont.body2Long.font,
        .foregroundColor: UIColor.white
    ]
    
    return NSAttributedString(
      string: text,
      attributes: attributes
    )
  }
}
