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
  
  public var onVideoSelectedInReviewFeed: ((Feed) -> Void)?
  public var onBookmarkTappedInReviewFeed: ((Int) -> Void)?
  
  private let reviewFeedCount = UILabel()
  private let emptyFirstLineLabel = UILabel()
  private let emptySecondLineLabel = UILabel()
  private let recordUploadButton = UIButton()
  public var reviewFeedCollectionView: UICollectionView?
  
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
    
    emptyFirstLineLabel.do {
      $0.text = "아직 후기가 없어요."
      $0.font = RecordyFont.title3.font
      $0.textColor = CommonAsset.viskitGray02.color
    }
    
    emptySecondLineLabel.do {
      $0.text = "첫 번째로 후기를 공유해 보세요!"
      $0.font = RecordyFont.title3.font
      $0.textColor = CommonAsset.viskitGray02.color
    }
    
    recordUploadButton.do {
      $0.backgroundColor = CommonAsset.viskitYellow400.color
      $0.setTitle("영상 업로드하기", for: .normal)
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
      $0.titleLabel?.font = ViskitFont.body2Bold.font
      $0.cornerRadius(22)
    }
  }
  
  private func setUI() {
    addSubviews(
      reviewFeedCount,
      emptyFirstLineLabel,
      emptySecondLineLabel,
      recordUploadButton,
      reviewFeedCollectionView!
    )
  }
  
  private func setAutolayout() {
    reviewFeedCount.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    emptyFirstLineLabel.snp.makeConstraints {
      $0.top.equalTo(reviewFeedCount.snp.bottom).offset(101)
      $0.centerX.equalToSuperview()
    }
    
    emptySecondLineLabel.snp.makeConstraints {
      $0.top.equalTo(emptyFirstLineLabel.snp.bottom).offset(5)
      $0.centerX.equalToSuperview()
    }
    
    recordUploadButton.snp.makeConstraints {
      $0.top.equalTo(emptySecondLineLabel.snp.bottom).offset(23)
      $0.width.equalTo(125.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
      $0.centerX.equalToSuperview()
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
    
    if feeds.isEmpty {
      emptyFirstLineLabel.isHidden = false
      emptySecondLineLabel.isHidden = false
      recordUploadButton.isHidden = false
      reviewFeedCollectionView?.isHidden = true
    } else {
      emptyFirstLineLabel.isHidden = true
      emptySecondLineLabel.isHidden = true
      recordUploadButton.isHidden = true
      reviewFeedCollectionView?.isHidden = false
    }
    
    self.reviewFeedCollectionView?.reloadData()
  }
  
  public func updateThumbnailBookmark(recordIndex: Int, isBookmarked: Bool) {
    let indexPath = IndexPath(item: recordIndex, section: 0)
    DispatchQueue.main.async {
      if let cell = self.reviewFeedCollectionView?.cellForItem(at: indexPath) as? ThumbnailCollectionViewCell {
        cell.updateBookmarkStatus(isBookmarked: isBookmarked)
      }
//      self.reviewFeedCollectionView?.reloadItems(at: [indexPath])
    }
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

@available(iOS 16.0, *)
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
      
      let reviewFeed = feeds[indexPath.row]
      
      cell.backgroundColor = CommonAsset.viskitGray10.color
      cell.configure(feed: reviewFeed)
      cell.bookmarkActionInThumbnailCell = { [weak self] in
        guard let self = self else { return }
        self.onBookmarkTappedInReviewFeed?(indexPath.row)
      }
      return cell
    }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard indexPath.row < feeds.count else { return }
    
    let selectedRecord = feeds[indexPath.row]
    onVideoSelectedInReviewFeed?(selectedRecord)
  }
}
