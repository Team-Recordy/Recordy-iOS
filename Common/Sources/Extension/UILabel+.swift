//
//  UILabel+.swift
//  Common
//
//  Created by Chandrala on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UILabel {
  func underlineText(forText: String) {
      guard let labelText = self.text else { return }
      
      let rangeToUnderline = (labelText as NSString).range(of: forText)
      
      let underlinedText = NSMutableAttributedString(string: labelText)
    underlinedText.addAttribute(
      .underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: rangeToUnderline
    )
      
      self.attributedText = underlinedText
    }
}
