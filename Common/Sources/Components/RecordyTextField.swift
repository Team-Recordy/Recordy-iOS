//
//  RecordyTextField.swift
//  Common
//
//  Created by Chandrala on 7/4/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public final class RecordyTextField: UITextField {
  
  public var onStateChange: ((RecordyTextFieldState) -> Void)?
  public var style: RecordyTextFieldStyle {
    didSet { setStyle(style) }
  }
  public var textState: RecordyTextFieldState = .unselected {
    didSet {
      setState(textState)
    }
  }
  
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
    self.textState = .unselected
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setState(_ style: RecordyTextFieldState) {
    self.layer.borderColor = style.borderColor.cgColor
    self.layer.borderWidth = style.borderWidth
    onStateChange?(style)
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
      onStateChange?(.error)
    } else {
      onStateChange?(.selected)
    }
    return true
  }
  
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    onStateChange?(.unselected)
    return true
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    onStateChange?(.unselected)
    return true
  }
}
