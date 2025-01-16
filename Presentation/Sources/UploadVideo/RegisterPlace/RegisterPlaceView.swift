//
//  RegisterPlaceView.swift
//  Presentation
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Common

class RegisterPlaceView: UIView {

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let stackView: UIStackView = {
      let stack = UIStackView()

      return stack
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    backgroundColor = CommonAsset.viskitGray10.color
    cornerRadius(8)

    stackView.do {
      $0.axis = .vertical
      $0.spacing = 4
      $0.alignment = .leading
    }

    titleLabel.do {
      $0.font = ViskitFont.subtitle.font
      $0.textColor = CommonAsset.viskitGray01.color
    }

    subtitleLabel.do {
      $0.font = ViskitFont.body2.font
      $0.textColor = CommonAsset.viskitGray01.color
    }
  }

  private func setUI() {
    addSubview(stackView)
    stackView.addArrangedSubviews(
      titleLabel,
      subtitleLabel
    )
  }

  private func setAutolayout() {
    stackView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(16.adaptiveWidth)
    }
//    titleLabel.snp.makeConstraints {
//      $0.centerY.equalToSuperview().offset(-9.adaptiveHeight)
//      $0.horizontalEdges.equalToSuperview().inset(16.adaptiveWidth)
//    }
//
//    subtitleLabel.snp.makeConstraints {
//      $0.top.equalTo(titleLabel.snp.bottom).offset(4.adaptiveHeight)
//      $0.horizontalEdges.equalToSuperview().inset(16.adaptiveWidth)
//    }
  }

  func configure(
    title: String,
    subtitle: String
  ) {
    titleLabel.text = title
    subtitleLabel.text = subtitle
  }
}
