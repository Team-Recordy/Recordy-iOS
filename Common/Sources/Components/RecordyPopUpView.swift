//
//  RecordyPopUpView.swift
//  Common
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then


public class RecordyPopUpView: UIView {
  public let popUpType: RecordyPopUpType
  private let image = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  let leftButton = UIButton()
  let rightButton = UIButton()
  private let buttonStackView = UIStackView()

  public init(type: RecordyPopUpType) {
    self.popUpType = type
    super.init(frame: .zero)
    self.backgroundColor = CommonAsset.recordyGrey08.color
    self.layer.cornerRadius = 20
    setStyle()
    setUI()
    setAutoLayout()
    if case .register(_) = popUpType {
      image.isHidden = true
    }
  }

  private func setStyle() {
    image.do {
      $0.image = popUpType.image
    }

    titleLabel.do {
      $0.text = popUpType.title
      $0.font = popUpType.titleFont
      $0.textAlignment = .center
      $0.textColor = CommonAsset.viskitGray01.color
    }

    subtitleLabel.do {
      $0.text = popUpType.subtitle
      $0.font = popUpType.subtitleFont
      $0.textAlignment = .center
      $0.textColor = CommonAsset.viskitGray01.color
      $0.numberOfLines = 0
    }

    leftButton.do {
      $0.setTitle("취소", for: .normal)
      $0.backgroundColor = popUpType.closeButtonBackgroundColor
      $0.setTitleColor(popUpType.closeButtonTitleColor, for: .normal)
      $0.titleLabel?.font = popUpType.buttonFont
      $0.cornerRadius(8)
    }

    rightButton.do {
      $0.setTitle(popUpType.buttonTitle, for: .normal)
      $0.backgroundColor = popUpType.buttonBackgroundColor
      $0.setTitleColor(popUpType.buttonTitleColor, for: .normal)
      $0.titleLabel?.font = popUpType.buttonFont
      $0.cornerRadius(8)
    }

    buttonStackView.do {
      $0.axis = .horizontal
      $0.spacing = 8
      $0.alignment = .fill
      $0.distribution = .fillEqually
    }
  }

  private func setUI() {
    self.addSubviews(image, titleLabel, subtitleLabel, leftButton, rightButton)
    buttonStackView.addArrangedSubview(leftButton)
    buttonStackView.addArrangedSubview(rightButton)
    addSubview(buttonStackView)
  }

  private func setAutoLayout() {
    if case .register(_) = popUpType {
      titleLabel.snp.makeConstraints {
        $0.top.equalToSuperview().offset(30.adaptiveHeight)
        $0.centerX.equalToSuperview()
      }
    } else {
      image.snp.makeConstraints {
        $0.top.equalToSuperview().offset(30.adaptiveHeight)
        $0.centerX.equalToSuperview()
        $0.width.height.equalTo(72)
      }

      titleLabel.snp.makeConstraints {
        $0.top.equalTo(image.snp.bottom).offset(20.adaptiveHeight)
        $0.centerX.equalToSuperview()
      }
    }

    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }

    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(44.adaptiveHeight)
      $0.width.equalTo(266.adaptiveWidth)
      $0.bottom.equalToSuperview().inset(20.adaptiveHeight)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
