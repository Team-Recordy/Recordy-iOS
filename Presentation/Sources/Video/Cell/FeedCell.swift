//
//  FeedCell.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import AVKit

import SnapKit
import Then

class FeedCell: UICollectionViewCell {

  var avQueuePlayer: AVQueuePlayer?
  var avPlayerLayer: AVPlayerLayer?

  private let playerView = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutolayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUI() {
    self.addSubview(playerView)
  }

  private func setAutolayout() {
    self.playerView.snp.makeConstraints {
      $0.verticalEdges.horizontalEdges.equalToSuperview()
    }
  }

  private func addPlayer(
    for url: URL,
    bounds: CGRect
  ) {
    avQueuePlayer = AVQueuePlayer(url: url)
    avPlayerLayer = AVPlayerLayer(player: self.avQueuePlayer!)
    avPlayerLayer?.frame = bounds
    avPlayerLayer?.fillMode = .both
    avPlayerLayer?.videoGravity = .resizeAspectFill
    playerView.layer.addSublayer(self.avPlayerLayer!)
  }

  func bind(url: URL?, bounds: CGRect) {
    if let url = url {
      addPlayer(for: url, bounds: bounds)
    }
  }
}
