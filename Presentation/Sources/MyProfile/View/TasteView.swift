//
//  TasteView.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//  setStyle() -> setUI() -> setAutoLayout()

import UIKit
import SnapKit
import Then

import Common
import Core

class TasteView: UIView {
  
  private let gradientImageView = UIImageView()
  private let dataView = UIView()
  private let backgroundImageView = UIImageView()

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
    self.backgroundColor = .black
    gradientImageView.do {
      $0.image = CommonAsset.gradientImage.image
      $0.contentMode = .scaleAspectFit
    }
    backgroundImageView.do {
      $0.image = CommonAsset.bubbleBackImg.image
      $0.contentMode = .scaleAspectFit
    }
  }
  
  private func setUI() {
    self.addSubview(gradientImageView)
    self.addSubview(backgroundImageView)
  }
  
  private func setAutoLayout() {
    gradientImageView.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide)
    }

    backgroundImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview().inset(140)
    }
  }
  
  func updateDataViews(_ tasteData: [TasteData]) {
    for view in backgroundImageView.subviews {
      view.removeFromSuperview()
    }
    
    if tasteData.count >= 3 {
      let firstDataView = TasteDataView(tasteData: tasteData[0])
      let secondDataView = TasteDataView(tasteData: tasteData[1])
      let thirdDataView = TasteDataView(tasteData: tasteData[2])
      
      backgroundImageView.addSubview(firstDataView)
      backgroundImageView.addSubview(secondDataView)
      backgroundImageView.addSubview(thirdDataView)
      
      let bubbleCenters = [
        CGPoint(x: 0.4, y: 0.6),
        CGPoint(x: 0.8, y: 0.4),
        CGPoint(x: 0.5, y: 0.8)
      ]
      
      firstDataView.snp.makeConstraints {
        $0.centerX.equalToSuperview().multipliedBy(bubbleCenters[0].x * 2)
        $0.centerY.equalToSuperview().multipliedBy(bubbleCenters[0].y * 1.47)
        $0.width.equalTo(200)
        $0.height.equalTo(200)
      }
      
      secondDataView.snp.makeConstraints {
        $0.centerX.equalToSuperview().multipliedBy(bubbleCenters[1].x * 1.74)
        $0.centerY.equalToSuperview().multipliedBy(bubbleCenters[1].y * 1.29)
        $0.width.equalTo(150)
        $0.height.equalTo(150)
      }
      
      thirdDataView.snp.makeConstraints {
        $0.centerX.equalToSuperview().multipliedBy(bubbleCenters[2].x * 2.574)
        $0.centerY.equalToSuperview().multipliedBy(bubbleCenters[2].y * 1.83)
        $0.width.equalTo(100)
        $0.height.equalTo(100)
      }
    }
  }
}
