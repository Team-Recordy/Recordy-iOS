//
//  CompleteEventCollectionViewCell.swift
//  Presentation
//
//  Created by Chandrala on 11/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

public class CompleteEventCollectionViewCell: UICollectionViewCell {
  
  private let completeEventButton = UIButton()
  private let completeEventLabel = UILabel()
  
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
    completeEventButton.do {
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.cornerRadius(8)
    }
    
    completeEventLabel.do {
      $0.text = "박수빈: 코딩 파이팅 전시회"
      $0.font = ViskitFont.caption1Regular.font
      $0.textColor = CommonAsset.viskitGray03.color
      $0.textAlignment = .left
    }
  }
  
  private func setUI() {
    addSubviews(
      completeEventButton
    )
    
    completeEventButton.addSubview(completeEventLabel)
  }
  
  private func setAutolayout() {
    completeEventButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    completeEventLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
  }
}
