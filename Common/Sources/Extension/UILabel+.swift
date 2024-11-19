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
  
  public func setLineSpacing(lineHeightMultiple: CGFloat) {
    guard let labelText = self.text else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = lineHeightMultiple
    
    let attributedString: NSMutableAttributedString
    if let labelAttributedText = self.attributedText {
      attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
    } else {
      attributedString = NSMutableAttributedString(string: labelText)
    }
    
    attributedString.addAttribute(
      .paragraphStyle,
      value: paragraphStyle,
      range: NSMakeRange(
        0,
        attributedString.length
      )
    )
    
    self.attributedText = attributedString
  }
  
  public func setLineHeight(_ lineHeight: CGFloat) {
    guard let labelText = self.text else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    
    let attributedString: NSMutableAttributedString
    if let labelAttributedText = self.attributedText {
      attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
    } else {
      attributedString = NSMutableAttributedString(string: labelText)
    }
    
    attributedString.addAttribute(
      .paragraphStyle,
      value: paragraphStyle,
      range: NSRange(location: 0, length: attributedString.length)
    )
    
    self.attributedText = attributedString
  }
  
  public func setColor(for targetText: String, with color: UIColor) {
    guard let fullText = self.text else { return }
    
    let attributedString = NSMutableAttributedString(string: fullText)
    
    if let range = fullText.range(of: targetText) {
      let nsRange = NSRange(range, in: fullText)
      attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
    }
    
    self.attributedText = attributedString
  }
}
