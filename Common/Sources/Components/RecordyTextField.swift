//
//  RecordyTextField.swift
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
}

public class RecordyTextField: UITextField {
  
  public init(
    frame: CGRect = .zero,
    placeholder: String
  ) {
    super.init(frame: frame)
    self.placeholder = placeholder
    setStyle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    layer.cornerRadius = 8
    font = RecordyFont.body2.font
    addPadding(left: 18, right: 18)
    backgroundColor = CommonAsset.recordyGrey08.color
    textColor = CommonAsset.recordyGrey01.color
    self.setPlaceholder(
      placeholder: self.placeholder ?? "",
      placeholderColor: CommonAsset.recordyGrey04,
      font: .body2
    )
  }
  
  public func updateTextFieldStyle(for state: RecordyTextFieldState) {
    switch state {
    case .unselected:
      layer.borderColor = UIColor.clear.cgColor
      layer.borderWidth = 0
    case .selected:
      layer.borderColor = CommonAsset.recordyMain.color.cgColor
      layer.borderWidth = 1
    case .error:
      layer.borderColor = CommonAsset.recordyAlert.color.cgColor
      layer.borderWidth = 1
    }
  }
}

extension RecordyTextField: UITextFieldDelegate {
  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else {
      return false
    }
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    return updatedText.count <= 10
  }
}
