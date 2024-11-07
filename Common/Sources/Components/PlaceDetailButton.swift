//
//  PlaceDetailButton.swift
//  Common
//
//  Created by Chandrala on 10/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Core

public class PlaceDetailButton: UIButton {
  
  public var place: Place?
  
  public let locationLabel = UILabel()
  public let placeNameLabel = UILabel()
  public let eventCountLabel = UILabel()
  public let rightChevronIcon = UIImageView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    backgroundColor = CommonAsset.viskitGray10.color
    cornerRadius(8)
    
    locationLabel.do {
      $0.font = ViskitFont.caption1Medium.font
      $0.textColor = CommonAsset.viskitGray05.color
    }
    
    placeNameLabel.do {
      $0.font = ViskitFont.title3.font
      $0.textColor = CommonAsset.viskitGray01.color
    }
    
    eventCountLabel.do {
      $0.font = ViskitFont.body2Semibold.font
      $0.textColor = CommonAsset.viskitGray02.color
    }
    
    rightChevronIcon.do {
      $0.image = CommonAsset.chevronRight.image
    }
  }
  
  private func setUI() {
    addSubviews(
      locationLabel,
      placeNameLabel,
      eventCountLabel,
      rightChevronIcon
    )
  }
  
  private func setAutolayout() {
    locationLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
    }
    
    placeNameLabel.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview().offset(16)
    }
    
    eventCountLabel.snp.makeConstraints {
      $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview().offset(16)
    }
    
    rightChevronIcon.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16)
      $0.width.height.equalTo(24.adaptiveWidth)
    }
  }
  
  public func bind(place: Place) {
    self.place = place
    locationLabel.text = place.shortenLocation
    placeNameLabel.text = place.title
    eventCountLabel.text = "\(place.placeInfoList.count)개의 전시가 진행중이에요"
  }
}

