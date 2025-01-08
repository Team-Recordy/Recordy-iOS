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
import Common

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
      $0.text = ""
      $0.font = ViskitFont.subtitle.font
      $0.textColor = CommonAsset.viskitGray01.color
    }
    
    exhibitionDateLabel.do {
      $0.text = ""
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
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    exhibitionDateLabel.snp.makeConstraints {
      $0.top.equalTo(exhibitionNameLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-12)
    }
  }
  
  public func bind(exhibition: Exhibition) {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.timeZone = TimeZone.current

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "yyyy년 MM월 dd일"

      let startDate = formatter.date(from: exhibition.startDate)
      let endDate = formatter.date(from: exhibition.endDate)

      let formattedStartDate = startDate != nil ? outputFormatter.string(from: startDate!) : exhibition.startDate
      let formattedEndDate = endDate != nil ? outputFormatter.string(from: endDate!) : exhibition.endDate

      exhibitionNameLabel.text = exhibition.name
      exhibitionDateLabel.text = "\(formattedStartDate)~\(formattedEndDate)"
  }
  
  public func calculateHeight(width: CGFloat) -> CGFloat {
      let targetSize = CGSize(width: width - 32, height: CGFloat.greatestFiniteMagnitude)
      
      let nameLabelHeight = exhibitionNameLabel.sizeThatFits(targetSize).height
      let dateLabelHeight = exhibitionDateLabel.sizeThatFits(targetSize).height
      let padding: CGFloat = 12 + 4 + 12
    
      return nameLabelHeight + dateLabelHeight + padding
  }
}


