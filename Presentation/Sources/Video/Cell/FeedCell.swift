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

class FeedCell: UICollectionViewCell {

  var avQueuePlayer: AVPlayer?
  var avPlayerLayer: AVPlayerLayer?
  var avPlayerLooper: AVPlayerLooper?
  var isPlaying: Bool = false
  var isPlayRequested: Bool = false
  private let playerView = UIView()
  private let feedView = FeedView()

  var bookmarkTappedRelay: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutolayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    avQueuePlayer?.pause()
    avQueuePlayer = nil
    avPlayerLayer?.removeFromSuperlayer()
    avPlayerLayer = nil
    avPlayerLooper = nil
    isPlayRequested = false
    NotificationCenter.default.removeObserver(self)
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
    self.bookmarkTappedRelay?()
  }

  func play() {
    isPlayRequested = true
    isPlaying = true
    self.avQueuePlayer?.play()
  }

  func pause() {
    isPlayRequested = false
    self.avQueuePlayer?.pause()
  }

  private func addPlayer(
    for url: URL,
    bounds: CGRect
  ) {
    avQueuePlayer = AVPlayer(url: url)
    avPlayerLayer = AVPlayerLayer(player: self.avQueuePlayer!)
    avPlayerLayer?.frame = bounds
    avPlayerLayer?.fillMode = .both
    avPlayerLayer?.videoGravity = .resizeAspectFill
    playerView.layer.addSublayer(self.avPlayerLayer!)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(playerItemDidReachEnd),
      name: .AVPlayerItemDidPlayToEndTime,
      object: avQueuePlayer?.currentItem
    )
  }

  @objc private func playerItemDidReachEnd(notification: Notification) {
    avQueuePlayer?.seek(to: CMTime.zero)
    avQueuePlayer?.play()
  }

  func bind(feed: Feed, bounds: CGRect, shouldAddPlayer: Bool) {
    if shouldAddPlayer {
      addPlayer(for: feed.videoLink, bounds: bounds)
    }
    self.feedView.locationLabel.text = feed.location
    self.feedView.nicknameLabel.text = feed.nickname
    self.feedView.descriptionTextView.text = feed.description
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
    self.feedView.descriptionTextView.attributedText = UITextView.setLineSpacing(
      5,
      text: feed.description
    )
  }

  func updateBookmarkStatus(isBookmarked: Bool) {
    self.feedView.bookmarkButton.setImage(
      isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image,
      for: .normal
    )
  }
}
