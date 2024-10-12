//
//  OverviewView.swift
//  Presentation
//
//  Created by Chandrala on 10/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

import SnapKit
import Then

final class OverviewView: UIView {
  
  var overview: [Overview]? = nil
  
  let viskitLogo = UIImageView()
  let locationButton = UIButton()
  let overviewScrollView = UIScrollView()
  let overviewStackView = UIStackView()
  let placeDetailButton = ViskitPlaceDetailButton()
  lazy var placeInfoCollectionView = UICollectionView()
  
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
    overviewScrollView.do {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    overviewStackView.do {
      $0.axis = .vertical
      $0.spacing = 16
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    viskitLogo.do {
      $0.image = CommonAsset.viskitLogo.image
      $0.contentMode = .scaleAspectFit
    }
    
    locationButton.do {
      $0.setImage(CommonAsset.location.image, for: .normal)
    }
  }
  
  func setUI() {
    addSubview(overviewScrollView)
    overviewScrollView.addSubview(overviewStackView)
    
    for place in overview! {
      overviewStackView.addArrangedSubviews(
        placeDetailButton,
        placeInfoCollectionView
      )
    }
  }
  
  func setAutolayout() {
    overviewScrollView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(72)
      $0.bottom.leading.trailing.equalToSuperview()
    }
    
    overviewStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(overviewScrollView)
      $0.height.greaterThanOrEqualToSuperview().priority(.low)
    }
    
    placeDetailButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(102.adaptiveHeight)
    }
    
    viskitLogo.snp.makeConstraints {
      $0.top.equalToSuperview().offset(18)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(75.adaptiveWidth)
      $0.height.equalTo(23.adaptiveHeight)
    }
    
    locationButton.snp.makeConstraints {
      $0.width.equalTo(24.adaptiveWidth)
      $0.height.equalTo(24.adaptiveHeight)
      $0.top.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
}
