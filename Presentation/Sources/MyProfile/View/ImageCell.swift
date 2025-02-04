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
  private let loadingIndicator = UIActivityIndicatorView(style: .medium)
  
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
      selectionIndicator,
      loadingIndicator
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
    loadingIndicator.do {
      $0.hidesWhenStopped = true
      $0.color = .gray
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
    
    loadingIndicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  func configure(
    with asset: PHAsset,
    indexPath: IndexPath
  ) {
    let imageManager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.deliveryMode = .fastFormat
    options.isSynchronous = false
    self.tag = indexPath.item
    
    imageView.image = nil
    imageView.alpha = 0
    loadingIndicator.startAnimating()
    
    imageManager.requestImage(
      for: asset,
      targetSize: PHImageManagerMaximumSize,
      contentMode: .aspectFill,
      options: options
    ) { [weak self] image, _ in
      guard let self = self else { return }
      if self.tag != indexPath.item { return }
      DispatchQueue.main.async {
        if let image = image {
          self.imageView.image = image
          self.imageView.alpha = 1
        }
        self.loadingIndicator.stopAnimating()
      }
    }
  }
  
  func setSelected(selected: Bool) {
    imageView.layer.borderColor = isSelected ? CommonAsset.viskitKakaoYellow.color.cgColor : UIColor.clear.cgColor
    imageView.layer.borderWidth = selected ? 1 : 0
    checkmark.isHidden = !selected
  }
}


