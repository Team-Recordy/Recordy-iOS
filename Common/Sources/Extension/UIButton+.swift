//
//  UIButton+.swift
//  Common
//
//  Created by 한지석 on 7/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UIButton {
  public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
    let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(minimumSize)
    
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(origin: .zero, size: minimumSize))
    }
    
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    self.setBackgroundImage(colorImage, for: state)
  }
}
