//
//  RecentCollectionViewCell.swift
//  Common
//
//  Created by Chandrala on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core

import SnapKit
import Then


public class ThumbnailCollectionViewCell: UICollectionViewCell {
  
  let label = UILabel()
  let locationStackView = UIStackView()
  let locationText = UILabel()
  let locationImageView = UIImageView()
  let bookmarkButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    label.backgroundColor = CommonAsset.recordyGrey03.color
    label.cornerRadius(12)
    
    locationStackView.do {
      $0.axis = .horizontal
      $0.distribution = .fillProportionally
      $0.alignment = .center
      $0.spacing = 3
    }
    
    locationText.do {
      $0.text = "최대열글자들어갑니다"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    
    locationImageView.do {
      $0.image = CommonAsset.location.image
    }
    
    bookmarkButton.do {
      $0.setImage(CommonAsset.bookmarkUnselected.image, for: .normal)
      $0.titleLabel?.font = RecordyFont.button2.font
    }
  }
  
  private func setUI() {
    self.addSubviews(label)
    label.addSubviews(
      locationStackView,
      bookmarkButton
    )
    
    locationStackView.addArrangedSubview(locationImageView)
    locationStackView.addArrangedSubview(locationText)
  }
  
  private func setAutoLayout() {
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    locationStackView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(9)
      $0.bottom.equalToSuperview().offset(15)
    }
    
    locationImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(3)
      $0.width.equalTo(12.adaptiveWidth)
      $0.height.equalTo(12.adaptiveHeight)
      $0.centerY.equalToSuperview()
    }

    bookmarkButton.snp.makeConstraints {
      $0.width.equalTo(13.adaptiveWidth)
      $0.height.equalTo(15.adaptiveHeight)
      $0.top.equalToSuperview().offset(15)
      $0.trailing.equalToSuperview().offset(-15)
    }
  }
}
