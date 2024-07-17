//
//  BookMarkView.swift
//  Presentation
//
//  Created by 송여경 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit


import Common
import Core

import SnapKit
import Then
import Kingfisher

class BookMarkView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
  private let bookmarkEmptyView = UIView()
  private let bookmarkDataView = UIView()
  
  let bookmarkEmptyImageView = UIImageView()
  let bookmarkEmptyTextVIew = UIImageView()
  private let countLabel = UILabel()
  private var collectionView: UICollectionView!
  private var feeds: [Feed] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpCollectionView()
    setStyle()
    setUI()
    setAutoLayout()
    checkDataEmpty()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:)가 구현되지 않았습니다.")
  }
  
  private func setStyle() {
    self.backgroundColor = .black
    bookmarkEmptyImageView.do {
      $0.image = CommonAsset.mypagebookmark.image
      $0.contentMode = .scaleAspectFit
    }
    bookmarkEmptyTextVIew.do {
      $0.image = CommonAsset.bookmarkText.image
    }
    
    countLabel.do {
      $0.text = "0 개의 기록"
      $0.textColor = .white
      $0.font = RecordyFont.caption1.font
      $0.numberOfLines = 1
      $0.textAlignment = .right
    }
    
    collectionView.do {
      $0.backgroundColor = .clear
    }
  }
  
  private func setUI() {
    self.addSubview(bookmarkEmptyView)
    self.addSubview(bookmarkDataView)
    self.addSubview(countLabel)
    self.addSubview(collectionView)
    
    bookmarkEmptyView.addSubview(bookmarkEmptyImageView)
    bookmarkEmptyView.addSubview(bookmarkEmptyTextVIew)
  }
  
  private func setAutoLayout() {
    bookmarkEmptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(115)
      $0.leading.equalTo(143)
      $0.width.equalTo(100.adaptiveWidth)
      $0.height.equalTo(100.adaptiveHeight)
    }
    
    bookmarkEmptyTextVIew.snp.makeConstraints {
      $0.top.equalTo(bookmarkEmptyImageView.snp.bottom).offset(18)
      $0.leading.equalTo(70)
    }
    
    bookmarkEmptyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    countLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-18)
      $0.leading.equalToSuperview().offset(194)
      $0.width.equalTo(161.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(countLabel.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 170, height: 288)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier)
  }
  
  private func checkDataEmpty() {
    if feeds.isEmpty {
      bookmarkEmptyView.isHidden = false
      countLabel.isHidden = true
      collectionView.isHidden = true
    } else {
      bookmarkEmptyView.isHidden = true
      countLabel.isHidden = false
      collectionView.isHidden = false
      setCountLabelText()
    }
  }
  
  private func setCountLabelText() {
    let whiteText = "• \(feeds.count)"
    let greyText = " 개의 기록"
    let attributedText = NSMutableAttributedString(string: whiteText, attributes:       [NSAttributedString.Key.foregroundColor: UIColor.white])
    attributedText.append(NSAttributedString(string: greyText, attributes: [NSAttributedString.Key.foregroundColor: CommonAsset.recordyGrey03.color]))
    countLabel.attributedText = attributedText
  }

  func getBookmarkList(feeds: [Feed]) {
    self.feeds.append(contentsOf: feeds)
    self.collectionView.reloadData()
    checkDataEmpty()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feeds.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? ThumbnailCollectionViewCell else {
      return UICollectionViewCell()
    }
    let thumbnailUrl = URL(string: String(feeds[indexPath.row].thumbnailLink.dropLast(1)))
    cell.backgroundImageView.kf.setImage(with: thumbnailUrl)
    cell.locationText.text = feeds[indexPath.row].location
    return cell
  }
}
