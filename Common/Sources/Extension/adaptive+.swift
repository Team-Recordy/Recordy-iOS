//
//  adaptive+.swift
//  Common
//
//  Created by 한지석 on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Foundation

extension CGFloat {
  public var adaptiveWidth: CGFloat {
    self * adaptiveWidthRatio
  }

  public var adaptiveHeight: CGFloat {
    self * adaptiveHeightRatio
  }

  private var adaptiveWidthRatio: CGFloat {
    UIScreen.main.bounds.width / 375
  }

  private var adaptiveHeightRatio: CGFloat {
    UIScreen.main.bounds.height / 812
  }
}

extension Int {
  public var adaptiveWidth: CGFloat {
    CGFloat(self).adaptiveWidth
  }

  public var adaptiveHeight: CGFloat {
    CGFloat(self).adaptiveHeight
  }
}

extension Double {
  public var adaptiveWidth: CGFloat {
    CGFloat(self).adaptiveWidth
  }

  public var adaptiveHeight: CGFloat {
    CGFloat(self).adaptiveHeight
  }
}
