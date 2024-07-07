//
//  UITextField+.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UITextField {
  func setPlaceholder(
    placeholder: String,
    placeholderColor: CommonColors,
    font: RecordyFont
  ) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        .foregroundColor: placeholderColor,
        .font: font
      ]
    )
    self.font = font.font
  }
  
  func setLayer(
    borderColor: CommonColors? = nil,
    borderWidth: CGFloat? = nil,
    cornerRadius: CGFloat
  ) {
    if let borderColor = borderColor {
      layer.borderColor = borderColor.color.cgColor
    }
    if let borderWidth = borderWidth {
      layer.borderWidth = borderWidth
    }
    layer.cornerRadius = cornerRadius
  }
  
  func addPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
    if let leftPadding = left {
      let leftView = UIView(
        frame: CGRect(
          x: 0,
          y: 0,
          width: leftPadding,
          height: self.frame.height
        )
      )
      self.leftView = leftView
      self.leftViewMode = .always
    }
    
    if let rightPadding = right {
      let rightView = UIView(
        frame: CGRect(
          x: 0,
          y: 0,
          width: rightPadding,
          height: self.frame.height
        )
      )
      self.rightView = rightView
      self.rightViewMode = .always
    }
  }
}
