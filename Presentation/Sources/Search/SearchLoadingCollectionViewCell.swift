//
//  SearchLoadingCollectionViewCell.swift
//  Presentation
//
//  Created by Chandrala on 11/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

public class SearchLoadingCollectionViewCell: UICollectionViewCell {
  
  private var loadingLocationResult = UILabel()
  private var loadingExhibitionResult = UILabel()
  private let loadingRightChevronImageView = UIImageView()
  
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
    loadingLocationResult.do {
      $0.text = "전시관 • 서울 동대문구"
      $0.font = ViskitFont.caption1Medium.font
      $0.textColor = CommonAsset.viskitGray05.color
      $0.textAlignment = .left
      $0.setLineHeight(18)
    }
    
    loadingExhibitionResult.do {
      $0.text = "국립현대미술관"
      $0.font = ViskitFont.subtitle.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.textAlignment = .left
      $0.setLineHeight(28)
    }
    
    loadingRightChevronImageView.do {
      $0.image = CommonAsset.chevronRight.image
      $0.contentMode = .scaleAspectFit
    }
  }
  
  private func setUI() {
    addSubviews(
      loadingLocationResult,
      loadingExhibitionResult,
      loadingRightChevronImageView
    )
  }
  
  private func setAutolayout() {
    loadingLocationResult.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    loadingExhibitionResult.snp.makeConstraints {
      $0.top.equalTo(loadingLocationResult.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
    }
    
    loadingRightChevronImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.equalTo(18.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
  }
}
