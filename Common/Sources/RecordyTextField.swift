//
//  RecordyTextField.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

final class RecordyTextField: UITextField {
  
  var style: RecordyTextFieldStyle {
    didSet {setStyle(style)}
  }
  
  init(frame: CGRect = .zero, style: RecordyTextFieldStyle = .unselected) {
    self.style = style
    super.init(frame: frame)
    setStyle(style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle(_ style: RecordyTextFieldStyle) {
    self.setLayer(
      borderColor: style.borderColor,
      borderWidth: style.borderWidth,
      cornerRadius: 8
    )
  
    self.setPlaceholder(
      placeholder: "",
      placeholderColor: CommonAsset.recordyGrey04,
      font: .body2
    )
    
    self.addPadding(left: 18, right: 18)
    
    self.backgroundColor = CommonAsset.recordyGrey08.color
    
    self.textColor = CommonAsset.recordyGrey04.color
  }
}
