//
//  SearchCompleteCollectionViewCell.swift
//  Presentation
//
//  Created by Chandrala on 11/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

public class SearchCompleteCollectionViewCell: UICollectionViewCell {
  
  private var completeLocationResult = UILabel()
  private var completeExhibitionResult = UILabel()
  private let completeRightChevronImageView = UIImageView()
  private var completeEventCollectionView: UICollectionView!
  private let cellDivider = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setCompleteEventCollectionView()
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    completeLocationResult.do {
      $0.text = "전시관 • 서울 동대문구"
      $0.font = ViskitFont.caption1Medium.font
      $0.textColor = CommonAsset.viskitGray05.color
      $0.textAlignment = .left
    }
    
    completeExhibitionResult.do {
      $0.text = "국립현대미술관"
      $0.font = ViskitFont.subtitle.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.textAlignment = .left
    }
    
    completeRightChevronImageView.do {
      $0.image = CommonAsset.chevronRight.image
      $0.contentMode = .scaleAspectFit
    }
    
    cellDivider.do {
      $0.backgroundColor = CommonAsset.viskitGray09.color
    }
  }
  
  private func setUI() {
    addSubviews(
      completeLocationResult,
      completeExhibitionResult,
      completeRightChevronImageView,
      completeEventCollectionView,
      cellDivider
    )
  }
  
  private func setAutolayout() {
    completeLocationResult.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    completeExhibitionResult.snp.makeConstraints {
      $0.top.equalTo(completeLocationResult.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
    }
    
    completeRightChevronImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(31)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.equalTo(18.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    completeEventCollectionView.snp.makeConstraints {
      $0.top.equalTo(completeExhibitionResult.snp.bottom).offset(14)
      $0.leading.equalToSuperview().offset(28)
      $0.trailing.equalToSuperview().offset(-28)
      $0.bottom.equalToSuperview().offset(-1)
    }
    
    cellDivider.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(20)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(1.adaptiveHeight)
    }
  }
  
  private func setCompleteEventCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    
    self.completeEventCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.completeEventCollectionView.showsHorizontalScrollIndicator = false
    self.completeEventCollectionView.register(
      CompleteEventCollectionViewCell.self,
      forCellWithReuseIdentifier: CompleteEventCollectionViewCell.cellIdentifier
    )
    self.completeEventCollectionView.delegate = self
    self.completeEventCollectionView.dataSource = self
  }
}

extension SearchCompleteCollectionViewCell: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case completeEventCollectionView:
      return 3
    default:
      return 0
    }
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch collectionView {
    case completeEventCollectionView:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CompleteEventCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as! CompleteEventCollectionViewCell
      return cell
      
    default:
      fatalError("Unexpected collection view")
    }
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {}
}

extension SearchCompleteCollectionViewCell: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case completeEventCollectionView:
      return CGSize(
        width: collectionView.bounds.width,
        height: 42.adaptiveHeight
      )
      
    default:
      return CGSize.zero
    }
  }
}
