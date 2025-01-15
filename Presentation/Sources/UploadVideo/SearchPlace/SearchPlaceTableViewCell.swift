//
//  SearchPlaceTableViewCell.swift
//  Presentation
//
//  Created by 한지석 on 1/8/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit

import Common

class SearchPlaceTableViewCell: UITableViewCell {

  private let descriptionWithLocationLabel = UILabel()
  private let placeNameLabel = UILabel()
  private let chevronImageView = UIImageView()

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

    descriptionWithLocationLabel.do {
      $0.textColor = CommonAsset.viskitGray05.color
      $0.font = ViskitFont.caption1Medium.font
    }

    placeNameLabel.do {
      $0.textColor = CommonAsset.viskitGray01.color
      $0.font = ViskitFont.subtitle.font
    }

    chevronImageView.do {
      $0.image = CommonAsset.chevronRight.image
    }
  }

  private func setUI() {
    addSubviews(
      descriptionWithLocationLabel,
      placeNameLabel,
      chevronImageView
    )
  }

  private func setAutoLayout() {
    descriptionWithLocationLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
    }
    placeNameLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionWithLocationLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
      $0.trailing.equalTo(chevronImageView.snp.leading).offset(8.adaptiveWidth)
      $0.bottom.equalToSuperview().offset(-14.adaptiveHeight)
    }
    chevronImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20.adaptiveWidth)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(18.adaptiveWidth)
    }
  }

  func configure(_ searchedData: SearchPlaceViewModel.SearchedPlace) {
    let type = searchedData.type == "PLACE" ? "장소" : "전시관"
    descriptionWithLocationLabel.text = "\(type) - \(searchedData.address)"
    placeNameLabel.text = searchedData.name
  }
}
