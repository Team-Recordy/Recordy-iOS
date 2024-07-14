//
//  TasteDataView.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//  setStyle() -> setUI() -> setAutolayout()

import UIKit
import SnapKit

import Common

class TasteDataView: UIView {
  
  private let titleLabel = UILabel()
  private let percentageLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(titleLabel)
    addSubview(percentageLabel)
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-10)
    }
    
    percentageLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
    }
    
    titleLabel.font = RecordyFont.keyword1.font
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    
    percentageLabel.font = RecordyFont.number1.font
    percentageLabel.textColor = .white
    percentageLabel.textAlignment = .center
  }
  
  func configure(with data: TasteData) {
    titleLabel.text = data.title
    percentageLabel.text = "\(data.percentage)%"
  }
}
