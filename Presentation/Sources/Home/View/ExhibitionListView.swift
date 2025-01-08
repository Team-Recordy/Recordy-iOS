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
import Core

@available(iOS 16.0, *)
final class ExhibitionListView: UIView {
  
  public var onAllFilterButtonTapped: (() -> Void)?
  
  private var exhibitionCountLabel = UILabel()
  let allFilterButton = ChipKeyWordButton()
  let freeFilterButton = ChipKeyWordButton()
  let endSoonFilterButton = ChipKeyWordButton()
  var exhibitionCollectionView: UICollectionView?
  
  private var exhibitions: [Exhibition] = []
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    setCollectionView()
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.exhibitionCollectionView?.backgroundColor = .clear
    
    exhibitionCountLabel.do {
      $0.text = ""
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
      exhibitionCountLabel,
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
    
    exhibitionCountLabel.snp.makeConstraints {
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
  
  public func updateExhibitionList(with exhibitions: [Exhibition]) {
    
    self.exhibitions = exhibitions
    self.exhibitionCountLabel.text = "• \(exhibitions.count)개의 전시"
    self.exhibitionCollectionView?.reloadData()
  }
  
  func setCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 12
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    exhibitionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    exhibitionCollectionView?.showsVerticalScrollIndicator = false
    exhibitionCollectionView?.showsHorizontalScrollIndicator = false
    exhibitionCollectionView?.register(
      ExhibitionCollectionViewCell.self,
      forCellWithReuseIdentifier: ExhibitionCollectionViewCell.cellIdentifier
    )
    
    exhibitionCollectionView?.dataSource = self
    exhibitionCollectionView?.delegate = self
  }
  
  @objc private func allFilterButtonTapped() {
    onAllFilterButtonTapped?()
  }
}

@available(iOS 16.0, *)
extension ExhibitionListView: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    let exhibitions = exhibitions
    return exhibitions.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ExhibitionCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? ExhibitionCollectionViewCell else {
        fatalError("Failed to dequeue OverviewCollectionViewCell")
      }
      let exhibition = exhibitions[indexPath.row]
      
      cell.backgroundColor = CommonAsset.viskitGray10.color
      cell.bind(exhibition: exhibition)
      
      return cell
    }
}

@available(iOS 16.0, *)
extension ExhibitionListView: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.frame.width
    guard let cell = collectionView.cellForItem(at: indexPath) as? ExhibitionCollectionViewCell else {
        return CGSize(width: width, height: 100)
    }
    let calculatedHeight = cell.calculateHeight(width: width)
    return CGSize(width: width, height: calculatedHeight)
  }
}
