//
//  RecordCollectionViewCell.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit

import Common
import Core

class RecordCollectionViewCell: UICollectionViewCell {
  
  private let imageView = UIImageView()
  private let locationLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    contentView.addSubview(imageView)
    contentView.addSubview(locationLabel)
    
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    locationLabel.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview().inset(8)
      $0.height.equalTo(20)
    }
    
    locationLabel.textColor = .white
    locationLabel.font = RecordyFont.caption2.font
    locationLabel.textAlignment = .left
  }
  
  func configure(with record: FeedModel) {
    if let image = UIImage(named: record.thumbnail) {
      imageView.image = image
    } else {
      imageView.image = UIImage(named: "placeholder_image")
    }
    locationLabel.text = record.location
  }
}
