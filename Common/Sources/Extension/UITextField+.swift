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
    placeholderColor: UIColor,
    font: UIFont
  ) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [.foregroundColor: placeholderColor, .font: font]
    )
    self.font = font
  }
  
  func setLayer(
    borderColor: UIColor = .clear,
    borderWidth: CGFloat = 0,
    cornerRadius: CGFloat = 0
  ){
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = borderWidth
    layer.cornerRadius = cornerRadius
  }
  
  func addPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
    if let left {
      leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 0))
      leftViewMode = .always
    }
    if let right {
      rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 0))
      rightViewMode = .always
    }
  }
}
