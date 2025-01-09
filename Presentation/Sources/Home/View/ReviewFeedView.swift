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
import Core

final class ReviewFeedView: UIView {
  
  var feeds: [Feed] = []
  
  private let reviewFeedCount = UILabel()
  var reviewFeedCollectionView: UICollectionView?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setReviewFeedCollectionView()
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    self.reviewFeedCollectionView?.backgroundColor = .clear
    
    reviewFeedCount.do {
      $0.text = ""
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
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  public func updateFeedList(with feeds: [Feed]) {
    
    self.feeds = feeds
    self.reviewFeedCount.text = "• \(feeds.count)개의 기록"
    self.reviewFeedCollectionView?.reloadData()
  }
  
  private func setReviewFeedCollectionView() {
    let layout = UICollectionViewFlowLayout()
    let totalSpacing = 20.adaptiveWidth * 2
    let interItemSpacing = 11.0
    let screenWidth = UIScreen.main.bounds.width
    let cellWidth = (screenWidth - totalSpacing - interItemSpacing) / 2
    
    layout.itemSize = CGSize(width: cellWidth, height: 288.adaptiveHeight)
    layout.sectionInset = UIEdgeInsets(
        top: 0,
        left: 20.adaptiveWidth,
        bottom: 0,
        right: 20.adaptiveWidth
    )
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 11
    
    reviewFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    reviewFeedCollectionView?.showsVerticalScrollIndicator = false
    reviewFeedCollectionView?.register(
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
    )
    
    reviewFeedCollectionView?.dataSource = self
    reviewFeedCollectionView?.delegate = self
  }
}

extension ReviewFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    let reviewFeeds = feeds
    return reviewFeeds.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? ThumbnailCollectionViewCell else {
        fatalError("Failed to dequeue OverviewCollectionViewCell")
      }
      let reviewFeeds = feeds[indexPath.row]
      
      cell.backgroundColor = CommonAsset.viskitGray10.color
      cell.configure(feed: reviewFeeds)
      
      return cell
    }
}
