//
//  CGFloat+.swift
//  Common
//
//  Created by 한지석 on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Foundation

extension CGFloat {
  var 
  
  private var adaptiveWidthRatio: CGFloat {
    return UIScreen.main.bounds.width / 375
  }

  private var adaptiveHeightRatio: CGFloat {
    return UIScreen.main.bounds.height / 812
  }
}
