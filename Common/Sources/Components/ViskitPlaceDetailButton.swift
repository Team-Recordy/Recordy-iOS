//
//  ViskitPlaceDetailButton.swift
//  Common
//
//  Created by Chandrala on 10/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public class ViskitPlaceDetailButton: UIButton {
  
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
  // -TODO: 에셋 파일 수정되면 폰트, 색깔 변경
  private func setStyle() {
    locationLabel.do {
      $0.text = "서울 종로구"
      $0.font = RecordyFont.keyword1.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
    
    placeNameLabel.do {
      $0.text = "국립현대미술관"
      $0.font = RecordyFont.keyword1.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
    
    // -TODO: 숫자 폰트, 색깔 변경
    eventCountLabel.do {
      $0.text = "7개의 전시가 진행중이에요"
      $0.font = RecordyFont.keyword1.font
      $0.textColor = CommonAsset.recordyGrey03.color
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
}

