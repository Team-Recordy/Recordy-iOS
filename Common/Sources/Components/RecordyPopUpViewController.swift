//
//  RecordyPopUpViewController.swift
//  Common
//
//  Created by 한지석 on 7/19/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

class RecordyPopUpViewController: UIViewController {

  let popUpView: RecordyPopUpView
  var rightButtonAction: (() -> Void)?

  public init(
    type: RecordyPopUpType,
    rightButtonAction: (() -> Void)?
  ) {
    self.popUpView = RecordyPopUpView(type: type)
    self.rightButtonAction = rightButtonAction
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
  }

  private func setStyle() {
    self.popUpView.rightButton.addTarget(
      self,
      action: #selector(rightButtonTapped),
      for: .touchUpInside
    )
    self.popUpView.leftButton.addTarget(
      self,
      action: #selector(leftButtonTapped),
      for: .touchUpInside
    )
  }

  private func setUI() {
    view.backgroundColor = .black.withAlphaComponent(0.5)
    self.view.addSubview(popUpView)
  }

  private func setAutoLayout() {
    self.popUpView.snp.makeConstraints {
      $0.width.equalTo(290.adaptiveWidth)
      $0.height.equalTo(256.adaptiveHeight)
      $0.center.equalToSuperview()
    }
  }

  @objc func rightButtonTapped() {
    rightButtonAction?()
  }

  @objc func leftButtonTapped() {
    self.dismiss(animated: false)
  }
}
