//
//  RecordyTextField.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public protocol RecordyTextFieldStateDelegate: AnyObject {
  func state(_ currentState: RecordyTextFieldState)
}

public final class RecordyTextField: UITextField {
  
  public weak var stateDelegate: RecordyTextFieldStateDelegate?
  var style: RecordyTextFieldStyle {
    didSet { setStyle(style) }
  }
  public var textState: RecordyTextFieldState = .unselected

  public init(
    frame: CGRect = .zero,
    style: RecordyTextFieldStyle = .unselected,
    placeholder: String
  ) {
    self.style = style
    super.init(frame: frame)
    self.placeholder = placeholder
    self.delegate = self
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
      placeholder: self.placeholder ?? "",
      placeholderColor: CommonAsset.recordyGrey04,
      font: .body2
    )
    
    self.addPadding(left: 18, right: 18)
    self.backgroundColor = CommonAsset.recordyGrey08.color
    self.textColor = CommonAsset.recordyGrey01.color
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
    
    let pattern = "^[가-힣0-9._]{1,10}$"
    let regex = try! NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: updatedText, range: NSRange(location: 0, length: updatedText.utf16.count))
    
    if matches.isEmpty {
      stateDelegate?.state(.error)
    } else {
      stateDelegate?.state(.selected)
    }
    
    return true
  }

  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    stateDelegate?.state(.unselected)
    return true
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    stateDelegate?.state(.unselected)
    return true
  }
}
