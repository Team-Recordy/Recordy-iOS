//
//  PopularCollectionViewCell.swift
//  Common
//
//  Created by Chandrala on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core

import SnapKit
import Then

public class PopularCollectionViewCell: UICollectionViewCell {
  
  let label = UILabel()
  let location = UILabel()
  let container = UIView()
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
    label.backgroundColor = CommonAsset.recordyGrey05.color
    label.cornerRadius(12)
    location.do {
      $0.text = "최대열글자들어갑니다"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    locationImageView.do {
      $0.image = CommonAsset.location.image
    }
    bookmarkButton.do {
      $0.setImage(CommonAsset.bookmarkUnselected.image, for: .normal)
    }
  }
  
  private func setUI() {
    self.addSubviews(label)
    label.addSubviews(
      container,
      bookmarkButton
    )
    container.addSubviews(
      location,
      locationImageView)
  }
  
  private func setAutoLayout() {
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    container.snp.makeConstraints {
      $0.width.equalTo(120.adaptiveWidth)
      $0.height.equalTo(26.adaptiveHeight)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-10)
    }
    
    locationImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(3)
      $0.width.equalTo(16.adaptiveWidth)
      $0.height.equalTo(16.adaptiveHeight)
      $0.centerY.equalToSuperview()
    }
    
    location.snp.makeConstraints {
      $0.leading.equalTo(locationImageView.snp.trailing).offset(4)
      $0.centerY.equalToSuperview()
    }
    
    bookmarkButton.snp.makeConstraints {
      $0.width.equalTo(20.adaptiveWidth)
      $0.height.equalTo(20.adaptiveHeight)
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
  }
}
