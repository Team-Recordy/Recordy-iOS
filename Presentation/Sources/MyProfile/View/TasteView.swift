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

// EmptyView
class TasteView: UIView {
  
  private let gradientImageView = UIImageView()
  private let emptyView = UIView()
  private let dataView = UIView()
  private let backgroundImageView = UIImageView()
  
  let emptyImageView = UIImageView()
  let emptyLabel = UIImageView()
  let actionButton = UIButton()
  let bottomMessage = UILabel()
  
  let fetchedData: [TasteData] = [
    TasteData(
      title: "집중하기 좋은",
      percentage: 66,
      type: .large
    ),
    TasteData(
      title: "분위기 좋은",
      percentage: 22,
      type: .medium
    ),
    TasteData(
      title: "집중하기 좋은",
      percentage: 10,
      type: .small
    )
  ]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
    checkDataEmpty()
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

    emptyImageView.do {
      $0.image = CommonAsset.mypagebubble.image
      $0.contentMode = .scaleAspectFit
    }
    
    emptyLabel.do {
      $0.image = CommonAsset.mypageEmptyViewText.image
    }
    
    actionButton.do {
      $0.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
      $0.setImage(CommonAsset.gorecord.image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
    }
    
    bottomMessage.do {
      $0.text = "서로 다른 키워드 3개를 입력하면 그래프가 보여요"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
    
    backgroundImageView.do {
      $0.image = CommonAsset.bubbleBackImg.image
      $0.contentMode = .scaleAspectFit
    }
  }
  
  private func setUI() {
    self.addSubview(emptyView)
    self.addSubview(dataView)
    self.addSubview(gradientImageView)

    emptyView.addSubview(emptyImageView)
    emptyView.addSubview(emptyLabel)
    emptyView.addSubview(actionButton)
    emptyView.addSubview(bottomMessage)
    
    dataView.addSubview(backgroundImageView)
  }
  
  private func setAutoLayout() {
    gradientImageView.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide)
    }

    emptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(138)
      $0.width.height.equalTo(100)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(18)
      $0.leading.equalTo(79)
    }
    
    actionButton.snp.makeConstraints {
      $0.top.equalTo(emptyLabel.snp.bottom).offset(31)
      $0.leading.equalTo(130)
      $0.width.equalTo(116.adaptiveWidth)
      $0.height.equalTo(42.adaptiveHeight)
    }
    
    bottomMessage.snp.makeConstraints {
      $0.top.equalTo(actionButton.snp.bottom).offset(94)
      $0.left.equalTo(76)
    }
    
    dataView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    backgroundImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(47)
      $0.edges.equalToSuperview()
      $0.width.height.equalTo(374)
    }
  }
  
  func checkDataEmpty() {
    if !fetchedData.isEmpty {
      emptyView.isHidden = true
      dataView.isHidden = false
      updateDataViews(fetchedData)
    } else {
      emptyView.isHidden = false
      dataView.isHidden = true
    }
  }
  
  @objc private func didTapActionButton() {
    print("기록하러 가기 버튼 눌렸을 때다.")
  }
  
  func updateDataViews(_ tasteData: [TasteData]) {
    for view in dataView.subviews {
      if view != backgroundImageView {
        view.removeFromSuperview()
      }
    }
    
    if tasteData.count >= 3 {
      let firstDataView = TasteDataView(tasteData: tasteData[0])
      let secondDataView = TasteDataView(tasteData: tasteData[1])
      let thirdDataView = TasteDataView(tasteData: tasteData[2])
      
      dataView.addSubview(firstDataView)
      dataView.addSubview(secondDataView)
      dataView.addSubview(thirdDataView)
      
      let bubbleCenters = [
        CGPoint(x: 0.4, y: 0.6),
        CGPoint(x: 0.8, y: 0.4),
        CGPoint(x: 0.5, y: 0.8)
      ]
      
      firstDataView.snp.makeConstraints {
        $0.centerX.equalToSuperview().multipliedBy(bubbleCenters[0].x * 2.05)
        $0.centerY.equalToSuperview().multipliedBy(bubbleCenters[0].y * 1.47)
        $0.width.equalTo(200)
        $0.height.equalTo(200)
      }
      
      secondDataView.snp.makeConstraints {
        $0.centerX.equalToSuperview().multipliedBy(bubbleCenters[1].x * 1.75)
        $0.centerY.equalToSuperview().multipliedBy(bubbleCenters[1].y * 1.18)
        $0.width.equalTo(150)
        $0.height.equalTo(150)
      }
      
      thirdDataView.snp.makeConstraints {
        $0.centerX.equalToSuperview().multipliedBy(bubbleCenters[2].x * 2.574)
        $0.centerY.equalToSuperview().multipliedBy(bubbleCenters[2].y * 1.95)
        $0.width.equalTo(100)
        $0.height.equalTo(100)
      }
    }
  }
}
