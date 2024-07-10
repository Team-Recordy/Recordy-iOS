//
//  RecordyTextFieldStyle.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

struct RecordyTextFieldStyle {
  let borderColor: CommonColors?
  let borderWidth: CGFloat?
  
  static let unselected = RecordyTextFieldStyle(
    borderColor: nil,
    borderWidth: nil
  )
  
  static let selected = RecordyTextFieldStyle(
    borderColor: CommonAsset.recordyMain,
    borderWidth: 1
  )
  
  static let error = RecordyTextFieldStyle(
    borderColor: CommonAsset.recordyAlert,
    borderWidth: 1
  )
}
