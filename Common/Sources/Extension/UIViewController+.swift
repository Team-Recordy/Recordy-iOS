//
//  UIViewController+.swift
//  Common
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

extension UIViewController {
  public func hideKeyboard() {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(
        UIViewController.dismissKeyboard
      )
    )
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
