//
//  PlaceButton.swift
//  Presentation
//
//  Created by 한지석 on 1/8/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Common

class PlaceButton: UIButton {

  private let buttonTitleLabel = UILabel()
  private let placeLabel = UILabel()
  private let chevronImageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutoLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUI() {
    addSubviews(
      buttonTitleLabel,
      placeLabel,
      chevronImageView
    )

    backgroundColor = CommonAsset.viskitGray10.color
    cornerRadius(8)

    buttonTitleLabel.do {
      $0.text = "장소"
      $0.font = ViskitFont.body2.font
      $0.textColor = CommonAsset.viskitGray01.color
    }

    chevronImageView.do {
      $0.image = CommonAsset.chevronRight.image
      $0.tintColor = CommonAsset.viskitGray01.color
      $0.contentMode = .scaleAspectFit
    }

    placeLabel.do {
      $0.font = ViskitFont.body2.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.textAlignment = .right
    }
  }

  private func setAutoLayout() {
    buttonTitleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }

    placeLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(buttonTitleLabel.snp.trailing).offset(8.adaptiveWidth)
      $0.trailing.equalTo(chevronImageView.snp.leading).offset(-16.adaptiveWidth)
    }

    chevronImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-20)
      $0.size.equalTo(18)
    }
  }

  func configure(text: String) {
    placeLabel.text = text
  }
}
