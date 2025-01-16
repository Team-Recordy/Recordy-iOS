//
//  RegisterPlaceSearchCell.swift
//  Presentation
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit

import Common

class RegisterPlaceSearchCell: UITableViewCell {

  private let locationLabel = UILabel()
  private let placeNameLabel = UILabel()

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier
    )
    setStyle()
    setUI()
    setAutoLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    backgroundColor = .clear

    locationLabel.do {
      $0.textColor = CommonAsset.viskitGray05.color
      $0.font = ViskitFont.caption1Medium.font
    }

    placeNameLabel.do {
      $0.textColor = CommonAsset.viskitGray01.color
      $0.font = ViskitFont.subtitle.font
    }
  }

  private func setUI() {
    addSubviews(
      locationLabel,
      placeNameLabel
    )
  }

  private func setAutoLayout() {
    locationLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
    }
    placeNameLabel.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
      $0.bottom.equalToSuperview().offset(-14.adaptiveHeight)
    }
  }

  func configure(_ searchedData: RegisterPlaceSearchViewModel.Place) {
    locationLabel.text = searchedData.address
    placeNameLabel.text = searchedData.name
  }
}
