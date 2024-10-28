//
//  ExhibitionListView.swift
//  Presentation
//
//  Created by Chandrala on 10/27/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class ExhibitionListView: UIView {
  
  let exhibitionCount = UILabel()
  public let allFilterButton = ChipKeyWordButton()
  public let freeFilterButton = ChipKeyWordButton()
  public let endSoonFilterButton = ChipKeyWordButton()
  var exhibitionCollectionView: UICollectionView?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setStyle()
    setExhibitionCollectionView()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.exhibitionCollectionView?.backgroundColor = .clear
    
    exhibitionCount.do {
      $0.text = "• 1 개의 전시"
      $0.font = ViskitFont.caption1Regular.font
      $0.textColor = CommonAsset.viskitWhite.color
    }
    
    allFilterButton.do {
      $0.setTitle("전체", for: .normal)
      $0.titleLabel?.font = ViskitFont.caption1Regular.font
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
    }
    
    freeFilterButton.do {
      $0.setTitle("무료", for: .normal)
      $0.titleLabel?.font = ViskitFont.caption1Regular.font
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
    }
    
    endSoonFilterButton.do {
      $0.setTitle("곧 끝남", for: .normal)
      $0.titleLabel?.font = ViskitFont.caption1Regular.font
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
    }
  }
  
  func setUI() {
    addSubviews(
      exhibitionCount,
      allFilterButton,
      freeFilterButton,
      endSoonFilterButton,
      exhibitionCollectionView!
    )
  }
  
  func setAutolayout() {
    allFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(41)
      $0.height.equalTo(34)
    }
    
    freeFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalTo(allFilterButton.snp.trailing).offset(8)
      $0.width.equalTo(41)
      $0.height.equalTo(34)
    }
    
    endSoonFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalTo(freeFilterButton.snp.trailing).offset(8)
      $0.width.equalTo(55)
      $0.height.equalTo(34)
    }
    
    exhibitionCount.snp.makeConstraints {
      $0.top.equalToSuperview().offset(36)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    exhibitionCollectionView?.snp.makeConstraints {
      $0.top.equalTo(allFilterButton.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview()
    }
  }
  
  func setExhibitionCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    exhibitionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    exhibitionCollectionView?.showsVerticalScrollIndicator = false
    exhibitionCollectionView?.showsHorizontalScrollIndicator = false
    exhibitionCollectionView?.register(
      ExhibitionCollectionViewCell.self,
      forCellWithReuseIdentifier: ExhibitionCollectionViewCell.cellIdentifier
    )
  }
}

