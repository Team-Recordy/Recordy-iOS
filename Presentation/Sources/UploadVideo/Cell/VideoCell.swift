//
//  VideoCell.swift
//  Presentation
//
//  Created by 한지석 on 7/2/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Photos

import Core

import SnapKit

class VideoCell: UICollectionViewCell {
  private let previewImageView = UIImageView().then {
    $0.contentMode = .scaleToFill
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.addSubview(previewImageView)
  }
  
  private func setAutoLayout() {
    previewImageView.snp.makeConstraints {
      $0.verticalEdges.horizontalEdges.equalToSuperview()
    }
  }
  
  func bind(asset: PHAsset) {
    let assetImage = PhotoKitManager.getAssetThumbnail(asset: asset, size: bounds.size)
    previewImageView.image = assetImage
  }

  func setSelected(_ selected: Bool) {
    contentView.backgroundColor = selected ? UIColor.black.withAlphaComponent(0.3) : UIColor.clear
  }
}
