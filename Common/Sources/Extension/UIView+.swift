//
//  UIView+.swift
//  Common
//
//  Created by 한지석 on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UIView {
  public func cornerRadius(_ cgFloat: CGFloat) {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = cgFloat
  }
  
  public func addSubviews(_ views: UIView...) {
      views.forEach {self.addSubview($0)}
  }
}
