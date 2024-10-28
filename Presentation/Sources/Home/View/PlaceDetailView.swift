//
//  PlaceDetailView.swift
//  Presentation
//
//  Created by Chandrala on 10/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class PlaceDetailView: UIView {
  
  let exhibitionListView = ExhibitionListView()
  let reviewFeedView = ReviewFeedView()

  let placeNameLabel = UILabel()
  let detailLocationLabel = UILabel()
  let findRouteButton = UIButton()
  let reviewButton = UIButton()
  public let segmentedControl = PlaceDetailSegmentedControl()
  var segmentedControlContainer = UIView()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    backgroundColor = CommonAsset.viskitBlack.color
    
    placeNameLabel.do {
      $0.text = "국립현대미술관"
      $0.textColor = CommonAsset.viskitWhite.color
      $0.font = ViskitFont.title1.font
      $0.numberOfLines = 1
    }
    
    detailLocationLabel.do {
      $0.text = "서울시 종로구 삼청로 30"
      $0.textColor = CommonAsset.viskitGray03.color
      $0.font = ViskitFont.body2.font
      $0.numberOfLines = 1
    }
    
    findRouteButton.do {
      $0.backgroundColor = CommonAsset.viskitGray01.color
      $0.setTitle("길찾기", for: .normal)
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
      $0.titleLabel?.font = ViskitFont.body2.font
      $0.cornerRadius(8)
    }
    
    reviewButton.do {
      $0.backgroundColor = CommonAsset.viskitGray01.color
      $0.setTitle("리뷰", for: .normal)
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
      $0.titleLabel?.font = ViskitFont.body2.font
      $0.cornerRadius(8)
    }
    
    segmentedControlContainer.do {
      $0.backgroundColor = .clear
    }
  }
  
  func setUI() {
    addSubviews(
      placeNameLabel,
      detailLocationLabel,
      findRouteButton,
      reviewButton,
      segmentedControl,
      segmentedControlContainer
    )
    
    self.segmentedControlContainer.addSubviews(
      exhibitionListView,
      reviewFeedView
    )
  }
  
  func setAutolayout() {
    placeNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(130)
      $0.centerX.equalToSuperview()
    }
    
    detailLocationLabel.snp.makeConstraints {
      $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
    }
    
    findRouteButton.snp.makeConstraints {
      $0.top.equalTo(detailLocationLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(111)
      $0.width.equalTo(75.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
    
    reviewButton.snp.makeConstraints {
      $0.top.equalTo(detailLocationLabel.snp.bottom).offset(24)
      $0.leading.equalTo(findRouteButton.snp.trailing).offset(16)
      $0.width.equalTo(63.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
    
    segmentedControl.snp.makeConstraints {
      $0.top.equalTo(findRouteButton.snp.bottom).offset(40)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(34)
    }
    
    segmentedControlContainer.snp.makeConstraints {
      $0.top.equalTo(segmentedControl.snp.bottom)
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    exhibitionListView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    reviewFeedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
