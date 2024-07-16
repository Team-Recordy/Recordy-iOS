//
//  RecordyToastMessageView.swift
//  Common
//
//  Created by 송여경 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit

public enum RecordyToastStatus {
  case complete, warning

  var icon: UIImage {
    switch self {
    case .complete:
      return CommonAsset.toastCheck.image

    case .warning:
      return CommonAsset.toastAlert.image
    }
  }
}

public final class RecordyToastMessageView: UIView {

  private let toastImage = UIImageView()
  public let toastLabel = UILabel().then {
    $0.textColor = CommonAsset.recordyGrey01.color
    $0.font = RecordyFont.body2Long.font
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyle()
    setupHierarchy()
    setupLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setMessage(text: String, status: RecordyToastStatus) {
    toastLabel.text = text
    toastImage.image = status.icon
  }
}

private extension RecordyToastMessageView {
  func setupStyle() {
    self.backgroundColor = CommonAsset.recordySub01.color
    self.cornerRadius(8)
    self.toastLabel.do {
      $0.font = RecordyFont.body2Long.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
  }

  func setupHierarchy() {
    addSubviews(
      toastImage,
      toastLabel
    )
  }

  func setupLayout() {
    toastImage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(16)
      $0.width.height.equalTo(24.adaptiveWidth)
    }

    toastLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(toastImage.snp.trailing).offset(4)
    }
  }
}

