//
//  ReviewFeedView.swift
//  Presentation
//
//  Created by Chandrala on 10/27/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

final class ReviewFeedView: UIView {
  
  private let reviewFeedCount = UILabel()
  var reviewFeedCollectionView: UICollectionView?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setStyle()
    setReviewFeedCollectionView()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    self.reviewFeedCollectionView?.backgroundColor = .clear
    
    reviewFeedCount.do {
      $0.text = "• 0 개의 기록"
      $0.font = ViskitFont.caption1Regular.font
      $0.textColor = CommonAsset.viskitWhite.color
    }
  }
  
  private func setUI() {
    addSubviews(
      reviewFeedCount,
      reviewFeedCollectionView!
    )
  }
  
  private func setAutolayout() {
    reviewFeedCount.snp.makeConstraints {
      $0.top.equalToSuperview().offset(36)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    reviewFeedCollectionView?.snp.makeConstraints {
      $0.top.equalTo(reviewFeedCount.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview()
    }
  }
  
  private func setReviewFeedCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    reviewFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    reviewFeedCollectionView?.showsVerticalScrollIndicator = false
    reviewFeedCollectionView?.showsHorizontalScrollIndicator = false
    reviewFeedCollectionView?.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "DefaultCell"
    )
  }
}


