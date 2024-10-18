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

protocol BookmarkDelegate: AnyObject {
  func bookmarkFeedTapped(feed: Feed)
  func bookmarkButtonTapped(feed: Feed)
}

class BookmarkView: UIView {
  private let bookmarkEmptyView = BookMarkEmptyView()
  private let countLabel = UILabel()
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 170, height: 288)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier)
    return collectionView
  }()
  
  private var feeds: [Feed] = [] {
    didSet {
      updateViewState()
    }
  }
  weak var delegate: BookmarkDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setStyle()
    setLayout()
    updateViewState()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    [
      bookmarkEmptyView,
      countLabel,
      collectionView
    ].forEach { addSubview($0) }
    
    bookmarkEmptyView.setActionButtonHandler { [weak self] in
      print("영상 둘러보기 눌림")
    }
  }
  
  private func setStyle() {
    backgroundColor = .black
    
    countLabel.do {
      $0.textColor = .white
      $0.font = RecordyFont.caption1.font
      $0.numberOfLines = 1
      $0.textAlignment = .right
    }
  }
  
  private func setLayout() {
    bookmarkEmptyView.snp.makeConstraints { $0.edges.equalToSuperview() }
    
    countLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-18)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(countLabel.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func updateViewState() {
    let isEmpty = feeds.isEmpty
    bookmarkEmptyView.isHidden = !isEmpty
    collectionView.isHidden = isEmpty
    setCountLabelText()
    if !isEmpty {
      collectionView.reloadData()
    }
  }
  
  private func setCountLabelText() {
    let whiteText = "• \(feeds.count)"
    let greyText = " 개의 기록"
    let attributedText = NSMutableAttributedString(string: whiteText, attributes: [.foregroundColor: UIColor.white])
    attributedText.append(NSAttributedString(string: greyText, attributes: [.foregroundColor: CommonAsset.recordyGrey03.color]))
    countLabel.attributedText = attributedText
  }
  
  func getBookmarkList(feeds: [Feed]) {
    self.feeds = feeds
  }
}

extension BookmarkView: UICollectionViewDataSource {
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
    cell.configure(feed: feeds[indexPath.row])
    cell.bookmarkButtonEvent = { [weak self] in
      guard let self = self else { return }
      self.feeds[indexPath.row].isBookmarked.toggle()
      self.delegate?.bookmarkButtonTapped(feed: self.feeds[indexPath.row])
      cell.updateBookmarkButton(isBookmarked: self.feeds[indexPath.row].isBookmarked)
    }
    return cell
  }
}

extension BookmarkView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.bookmarkFeedTapped(feed: feeds[indexPath.row])
  }
}
