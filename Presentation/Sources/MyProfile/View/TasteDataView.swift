//
//  TasteDataView.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//  setStyle() -> setUI() -> setAutolayout()

import UIKit
import SnapKit

import Core
import Common

class TasteDataView: UIView {
  
  private let titleLabel = UILabel()
  private let percentageLabel = UILabel()
  private let tasteData: TasteData
  
  public init(
    frame: CGRect = .zero,
    tasteData: TasteData
  ) {
    self.tasteData = tasteData
    super.init(
      frame: frame
    )
    configure(with: tasteData)
    setUI()
    setStyle()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    addSubview(titleLabel)
    addSubview(percentageLabel)
  }
  
  private func setStyle() {
    titleLabel.font = tasteData.type.title
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    
    percentageLabel.font = tasteData.type.subtitle
    percentageLabel.textColor = .white
    percentageLabel.textAlignment = .center
  }
  
  private func setAutolayout() {
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-10)
    }
    
    percentageLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
    }
  }
  
  func configure(with data: TasteData) {
    titleLabel.text = data.title
    percentageLabel.text = "\(data.percentage)%"
  }
}
