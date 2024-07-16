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
import Common

import SnapKit

class VideoCell: UICollectionViewCell {
  private let previewImageView = UIImageView().then {
    $0.contentMode = .scaleToFill
  }
  private let playtimeLabel = UILabel().then {
    $0.font = RecordyFont.caption2.font
    $0.textColor = CommonAsset.recordyWhite.color
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
    self.addSubview(playtimeLabel)
  }
  
  private func setAutoLayout() {
    previewImageView.snp.makeConstraints {
      $0.verticalEdges.horizontalEdges.equalToSuperview()
    }
    playtimeLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(4)
      $0.trailing.equalToSuperview().inset(6)
    }
  }
  
  func bind(localVideo: LocalVideo) {
    let assetImage = PhotoKitManager.getAssetThumbnail(
      asset: localVideo.asset,
      size: bounds.size
    )
    previewImageView.image = assetImage
    playtimeLabel.text = localVideo.playtime
  }

//  func setSelected(_ selected: Bool) {
//    contentView.backgroundColor = selected ? UIColor.black.withAlphaComponent(0.3) : UIColor.clear
//  }
}
