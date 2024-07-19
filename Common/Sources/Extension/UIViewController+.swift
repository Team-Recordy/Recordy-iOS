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

  public func showToast(
    status: RecordyToastStatus,
    message: String,
    height: CGFloat
  ) {
    let screenWidth = self.view.frame.size.width
    let toastLabelFrame = CGRect(
      x: 20,
      y: self.view.frame.size.height - (height + 100),
      width: screenWidth - 40,
      height: 44
    )
    let toastView = RecordyToastMessageView(frame: toastLabelFrame)
    toastView.setMessage(text: message, status: status)
    self.view.addSubview(toastView)
    self.view.endEditing(true)
    UIView.animate(withDuration: 0.5,
                   delay: 1.8,
                   options: .curveEaseOut,
                   animations: {
      toastView.alpha = 0.0
    }, completion: { _ in
      toastView.removeFromSuperview()
    })
  }

  public func showPopUp(
    type: RecordyPopUpType,
    rightButtonAction: (() -> Void)?
  ) {
    let popupViewController = RecordyPopUpViewController(
      type: type,
      rightButtonAction: rightButtonAction
    )
    popupViewController.modalPresentationStyle = .overFullScreen
    present(popupViewController, animated: false)
  }
}
