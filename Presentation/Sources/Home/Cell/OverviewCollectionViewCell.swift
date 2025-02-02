//
//  OverviewCollectionViewCell.swift
//  Common
//
//  Created by Chandrala on 1/6/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Core
import Common

public class OverviewCollectionViewCell: UICollectionViewCell {
  private var place: Place?
  private var records: [Feed] = []
  
  public var onPlaceDetailButtonTapped: ((Int) -> Void)?
  public var onUpdateHeight: (() -> Void)?
  public var onVideoSelectedInCell: ((Feed) -> Void)?
  public var onBookmarkButtonTapped: ((Int) -> Void)?
  
  private let locationLabel = UILabel()
  private let placeNameLabel = UILabel()
  private let eventCountLabelYellow = UILabel()
  private let eventCountLabel = UILabel()
  private let rightChevronIcon = UIImageView()
  private let placeDetailButton = UIButton()
  private var placeExhibitionCollectionView: UICollectionView?
  
  public var contentHeight: CGFloat {
    var totalHeight: CGFloat = 0
    totalHeight += 102.adaptiveHeight
    if let collectionView = placeExhibitionCollectionView, !collectionView.isHidden {
      totalHeight += 261.adaptiveHeight
    }
    return totalHeight
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setPlaceExhibitionCollectionView()
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    placeDetailButton.do {
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.cornerRadius(8)
      $0.addTarget(self, action: #selector(placeDetailButtonTapped), for: .touchUpInside)
    }
    
    placeExhibitionCollectionView!.do {
      $0.backgroundColor = .clear
    }
    
    locationLabel.do {
      $0.font = ViskitFont.caption1Medium.font
      $0.textColor = CommonAsset.viskitGray05.color
    }
    
    placeNameLabel.do {
      $0.font = ViskitFont.title3.font
      $0.textColor = CommonAsset.viskitGray01.color
    }
    
    eventCountLabelYellow.do {
      $0.font = ViskitFont.body2Semibold.font
      $0.textColor = CommonAsset.viskitYellow500.color
    }
    
    eventCountLabel.do {
      $0.text = "의 전시가 진행중이에요"
      $0.font = ViskitFont.body2Semibold.font
      $0.textColor = CommonAsset.viskitGray02.color
    }
    
    rightChevronIcon.do {
      $0.image = CommonAsset.chevronRight.image
    }
  }
  
  private func setUI() {
    contentView.addSubviews(
      placeDetailButton,
      placeExhibitionCollectionView!
    )
    
    placeDetailButton.addSubviews(
      locationLabel,
      placeNameLabel,
      eventCountLabelYellow,
      eventCountLabel,
      rightChevronIcon
    )
  }
  
  private func setAutolayout() {
    placeDetailButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(102.adaptiveHeight)
    }
    
    placeExhibitionCollectionView!.snp.makeConstraints {
      $0.top.equalTo(placeDetailButton.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(277.adaptiveHeight)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
    }
    
    placeNameLabel.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
    }
    
    eventCountLabelYellow.snp.makeConstraints {
      $0.top.equalTo(placeNameLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(20.adaptiveHeight)
    }
    
    eventCountLabel.snp.makeConstraints {
      $0.centerY.equalTo(eventCountLabelYellow.snp.centerY)
      $0.leading.equalTo(eventCountLabelYellow.snp.trailing)
      $0.height.equalTo(20.adaptiveHeight)
    }
    
    rightChevronIcon.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16)
      $0.width.height.equalTo(24.adaptiveWidth)
    }
  }
  
  private func setPlaceExhibitionCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(
      width: 138.adaptiveWidth,
      height: 245.adaptiveHeight
    )
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 16.adaptiveWidth,
      bottom: 0,
      right: 0
    )
    
    placeExhibitionCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    placeExhibitionCollectionView?.backgroundColor = .clear
    placeExhibitionCollectionView?.showsHorizontalScrollIndicator = false
    placeExhibitionCollectionView?.register(
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
    )
    placeExhibitionCollectionView?.delegate = self
    placeExhibitionCollectionView?.dataSource = self
  }
  
  public func bind(place: Place, records: [Feed], index: Int? = nil) {
    self.place = place
    self.records = records
    
    let addressComponents = place.address.split(separator: " ")
    let formattedAddress = addressComponents.prefix(2).joined(separator: " ")
    
    locationLabel.text = formattedAddress
    placeNameLabel.text = place.name
    eventCountLabelYellow.text = "\(place.exhibitionSize)개"
    placeDetailButton.tag = index ?? -1
    
    if place.recordSize == 0 {
      placeExhibitionCollectionView?.isHidden = true
    } else {
      placeExhibitionCollectionView?.isHidden = false
    }
    placeExhibitionCollectionView?.reloadData()
    onUpdateHeight?()
  }
  
  private func updateRecords(records: [Feed]) {
    self.records = records
    placeExhibitionCollectionView?.reloadData()
  }
  
  public func updateThumbnailBookmark(recordIndex: Int, isBookmarked: Bool) {
    let indexPath = IndexPath(item: recordIndex, section: 0)
    if let cell = placeExhibitionCollectionView?.cellForItem(at: indexPath) as? ThumbnailCollectionViewCell {
      cell.updateBookmarkStatus(isBookmarked: isBookmarked)
    }
  }
  
  @objc private func placeDetailButtonTapped(_ sender: UIButton) {
    onPlaceDetailButtonTapped?(sender.tag)
  }
}

@available(iOS 16.0, *)
extension OverviewCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard !(placeExhibitionCollectionView?.isHidden ?? true) else {
      return 0
    }
    return min(records.count, 10)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? ThumbnailCollectionViewCell else {
      fatalError("Failed to dequeue ThumbnailCollectionViewCell")
    }
    guard indexPath.row < records.count else {
      return cell
    }
    var record = records[indexPath.row]
    
    cell.configure(feed: record)
    cell.bookmarkActionInThumbnailCell = { [weak self] in
      guard let self else { return }
      self.onBookmarkButtonTapped?(indexPath.row)
    }
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard indexPath.row < records.count else { return }
    
    let selectedRecord = records[indexPath.row]
    onVideoSelectedInCell?(selectedRecord)
  }
}
