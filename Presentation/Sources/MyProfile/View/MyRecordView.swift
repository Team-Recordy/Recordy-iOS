//
//  MyRecordView.swift
//  Presentation
//
//  Created by 송여경 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit
import SnapKit
import Then

import Core
import Common

class MyRecordView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
  private let videoEmptyView = UIView()
  private let videoEmptyImageView = UIImageView()
  private let videoEmptyTextView = UIImageView()
  private let goActionButton = UIButton()
  private let countLabel = UILabel()
  private var collectionView: UICollectionView!
  private let feeds: [Feed] = Feed.mockdata
  
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
    
    videoEmptyImageView.do {
      $0.image = CommonAsset.mypageCamera.image
      $0.contentMode = .scaleAspectFit
    }
    
    videoEmptyTextView.do {
      $0.image = CommonAsset.myRecordText.image
    }
    
    goActionButton.do {
      $0.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
      $0.setImage(CommonAsset.gorecord.image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
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
    self.addSubview(videoEmptyView)
    self.addSubview(countLabel)
    self.addSubview(collectionView)
    
    videoEmptyView.addSubview(videoEmptyImageView)
    videoEmptyView.addSubview(videoEmptyTextView)
    videoEmptyView.addSubview(goActionButton)
  }
  
  private func setAutoLayout() {
    videoEmptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.leading.equalTo(138)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100.adaptiveHeight.adaptiveWidth)
    }
    
    videoEmptyTextView.snp.makeConstraints {
      $0.top.equalTo(videoEmptyImageView.snp.bottom).offset(18)
      $0.leading.equalToSuperview().offset(105)
    }
    
    goActionButton.snp.makeConstraints {
      $0.top.equalTo(videoEmptyTextView.snp.bottom).offset(31)
      $0.leading.equalToSuperview().offset(130)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(116.adaptiveWidth)
      $0.height.equalTo(42.adaptiveHeight)
    }
    
    videoEmptyView.snp.makeConstraints {
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
  
  @objc private func didTapActionButton() {
    print("기록하기 버튼 눌림")
  }
  
  private func checkDataEmpty() {
    if feeds.isEmpty {
      videoEmptyView.isHidden = false
      countLabel.isHidden = true
      collectionView.isHidden = true
    } else {
      videoEmptyView.isHidden = true
      countLabel.isHidden = false
      collectionView.isHidden = false
      setCountLabelText()
    }
  }
  
  private func setCountLabelText() {
    let whiteText = "• \(feeds.count)"
    let greyText = " 개의 기록"
    let attributedText = NSMutableAttributedString(string: whiteText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    attributedText.append(NSAttributedString(string: greyText, attributes: [NSAttributedString.Key.foregroundColor: CommonAsset.recordyGrey03.color]))
    countLabel.attributedText = attributedText
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
    cell.backgroundImageView.image = UIImage(systemName: "person")
    cell.locationText.text = feeds[indexPath.row].location
    return cell
  }
}
