//
//  UICollectionViewCell+.swift
//  Common
//
//  Created by 한지석 on 7/2/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  public static var cellIdentifier: String {
    return String(describing: self)
  }
}
