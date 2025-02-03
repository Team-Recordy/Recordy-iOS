//
//  ImageCell.swift
//  Presentation
//
//  Created by 송여경 on 2/3/25.
//  Copyright © 2025 com. All rights reserved.
//

import Common
import Photos
import UIKit


import SnapKit
import Then

final class ImageCell: UICollectionViewCell {
  static let identifier = "Photo"
  
  private let imageView = UIImageView()
  private let selectionIndicator = UIView()
  private let checkmark = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setStyle()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    contentView.addSubviews(
      imageView,
      selectionIndicator
    )
    selectionIndicator.addSubview(checkmark)
  }
  
  private func setStyle() {
    imageView.do {
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
    }
    selectionIndicator.do {
      $0.layer.borderWidth = 1
      $0.layer.cornerRadius = 16/2
      $0.layer.borderColor = CommonAsset.viskitGray01.color.cgColor
      $0.backgroundColor = CommonAsset.viskitBlack30.color
    }
    checkmark.do {
      $0.image = CommonAsset.selctionCheck.image
      $0.isHidden = true
      $0.layer.cornerRadius = 16/2
    }
  }
  
  private func setLayout() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    selectionIndicator.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.top).offset(6)
      $0.trailing.equalTo(imageView.snp.trailing).inset(6)
      $0.width.height.equalTo(16)
    }
    
    checkmark.snp.makeConstraints {
      $0.edges.equalTo(selectionIndicator)
      $0.width.height.equalTo(16)
    }
  }
  
  func configure(with asset: PHAsset) {
    let imageManager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.deliveryMode = .fastFormat
    options.isSynchronous = false
    
    imageManager.requestImage(
      for: asset,
      targetSize: bounds.size,
      contentMode: .aspectFill,
      options: options
    ) { [weak self] image, _ in
      guard let self = self, let image = image else { return }
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    }
  }
  
  
  func setSelected(selected: Bool) {
    selectionIndicator.layer.borderColor = isSelected ? CommonAsset.viskitKakaoYellow.color.cgColor : UIColor.clear.cgColor
    checkmark.isHidden = !selected
  }
  
}

