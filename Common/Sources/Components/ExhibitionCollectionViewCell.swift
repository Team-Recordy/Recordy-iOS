//
//  ExhibitionCollectionViewCell.swift
//  Common
//
//  Created by Chandrala on 10/28/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Core

public class ExhibitionCollectionViewCell: UICollectionViewCell {
  
  public let exhibitionNameLabel = UILabel()
  public let exhibitionDateLabel = UILabel()
  
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
    cornerRadius(8)
    
    exhibitionNameLabel.do {
      $0.text = "전시회 명 두줄짜리"
      $0.font = ViskitFont.subtitle.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.numberOfLines = 2
    }
    
    exhibitionDateLabel.do {
      $0.text = "2024년 10월 28일 ~ 2024년 10월 29일"
      $0.font = ViskitFont.caption1Medium.font
      $0.textColor = CommonAsset.viskitGray05.color
    }
  }
  
  private func setUI() {
    addSubviews(
      exhibitionNameLabel,
      exhibitionDateLabel
    )
  }
  
  private func setAutolayout() {
    exhibitionNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalToSuperview().offset(16)
    }
    
    exhibitionDateLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-12)
      $0.leading.equalToSuperview().offset(16)
    }
  }
//  
//  public func bind(with placeInfo: PlaceInfo) {
//    exhibitionNameLabel.text = placeInfo.title
//    exhibitionDateLabel.text = placeInfo.duration
//  }
}


