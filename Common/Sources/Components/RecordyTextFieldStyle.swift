//
//  RecordyTextFieldStyle.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public struct RecordyTextFieldStyle {
  let borderColor: CommonColors?
  let borderWidth: CGFloat?
  
  public static let unselected = RecordyTextFieldStyle(
    borderColor: nil,
    borderWidth: nil
  )
  
  public static let selected = RecordyTextFieldStyle(
    borderColor: CommonAsset.recordyMain,
    borderWidth: 1
  )
  
  public static let error = RecordyTextFieldStyle(
    borderColor: CommonAsset.recordyAlert,
    borderWidth: 1
  )
}
