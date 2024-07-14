//
//  RecordyTextFieldStyle.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public enum RecordyTextFieldState {
  case unselected
  case selected
  case error
  
  public var borderColor: UIColor {
    switch self {
    case .unselected:
      return .clear
    case .selected:
      return CommonAsset.recordyMain.color
    case .error:
      return CommonAsset.recordyAlert.color
    }
  }
  
  public var borderWidth: CGFloat {
    switch self {
    case .unselected:
      return 0
    case .selected:
      return 1
    case .error:
      return 1
    }
  }
}

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
