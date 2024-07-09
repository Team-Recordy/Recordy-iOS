//
//  FeedCell.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import AVKit

import Core
import Common

import SnapKit
import Then
import RxSwift
import RxCocoa

class FeedCell: UICollectionViewCell {

  var avQueuePlayer: AVQueuePlayer?
  var avPlayerLayer: AVPlayerLayer?
  private let playerView = UIView()
  private let feedView = FeedView()

  var bookmarkTappedRelay = PublishRelay<Void>()
  let disposeBag = DisposeBag()

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
    self.addSubview(feedView)
  }

  private func setAutolayout() {
    self.feedView.snp.makeConstraints {
      $0.verticalEdges.horizontalEdges.equalToSuperview()
    }
    self.playerView.snp.makeConstraints {
      $0.top.equalTo(playerView.snp.top)
      $0.leading.equalTo(playerView.snp.leading)
      $0.trailing.equalTo(playerView.snp.trailing)
      $0.bottom.equalTo(playerView.snp.bottom)
    }
  }

  @objc private func bookmarkButtonTapped() {
    self.bookmarkTappedRelay.accept(())
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

  func bind(feed: Feed, bounds: CGRect) {
    addPlayer(for: feed.videoLink, bounds: bounds)
    self.feedView.locationLabel.text = feed.location
    self.feedView.nicknameLabel.text = feed.nickname
    self.feedView.descriptionLabel.text = feed.description
    self.feedView.bookmarkButton.setImage(
      feed.isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image,
      for: .normal
    )
    self.feedView.bookmarkLabel.text = feed.bookmarkCount
    self.feedView.bookmarkButton.addTarget(
      self,
      action: #selector(bookmarkButtonTapped),
      for: .touchUpInside
    )
  }
}
