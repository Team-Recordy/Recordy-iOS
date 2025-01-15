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

protocol FeedWatchDelegate: AnyObject {
  func play(feed: Feed)
}

class FeedCell: UICollectionViewCell {

  weak var delegate: FeedWatchDelegate?

  private let playerView = UIView()
  let feedView = FeedView()

  var feed: Feed?
  var avPlayer: AVPlayer?
  var avPlayerLayer: AVPlayerLayer?
  var avPlayerLooper: AVPlayerLooper?
  var isPlaying: Bool = false
  var isPlayRequested: Bool = false

  var bookmarkAction: (() -> Void)?
  var profileAction: (() -> Void)?
  var deleteAction: (() -> Void)?
  var moreAction: (() -> Void)?

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
    avPlayer?.pause()
    avPlayer = nil
    avPlayerLayer?.removeFromSuperlayer()
    avPlayerLayer = nil
    avPlayerLooper = nil
    isPlayRequested = false
    NotificationCenter.default.removeObserver(self)
  }

  deinit {
    deinitPlayers()
  }

  private func setUI() {
    addSubview(playerView)
    addSubview(feedView)
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

  func play() {
    isPlayRequested = true
    isPlaying = true
    avPlayer?.play()
    if let feed = feed {
      delegate?.play(feed: feed)
    }
  }

  func pause() {
    isPlayRequested = false
    avPlayer?.pause()
  }

  func deinitPlayers() {
    avPlayer?.pause()
    avPlayer = nil
    avPlayerLayer?.removeFromSuperlayer()
    avPlayerLayer = nil
    avPlayerLooper = nil
    NotificationCenter.default.removeObserver(self)
  }

  private func addPlayer(
    for url: URL,
    bounds: CGRect
  ) {
    avPlayer = AVPlayer(url: url)
    avPlayer!.automaticallyWaitsToMinimizeStalling = false
    avPlayerLayer = AVPlayerLayer(player: self.avPlayer!)
    avPlayerLayer?.frame = bounds
    avPlayerLayer?.fillMode = .both
    avPlayerLayer?.videoGravity = .resizeAspectFill
    playerView.layer.addSublayer(self.avPlayerLayer!)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(playerItemDidReachEnd),
      name: .AVPlayerItemDidPlayToEndTime,
      object: avPlayer?.currentItem
    )
  }

  @objc private func playerItemDidReachEnd(notification: Notification) {
    avPlayer?.seek(to: CMTime.zero)
    avPlayer?.play()
  }

  func bind(feed: Feed, bounds: CGRect, shouldAddPlayer: Bool) {
    self.feed = feed

//    feedView.updateTitle(feed.placeInfo.title)
    if shouldAddPlayer {
      addPlayer(for: URL(string: feed.videoLink)!, bounds: bounds)
    }
    feedView.descriptionTextView.attributedText = UITextView.setLineSpacing(
      5,
      text: feed.description
    )
//    feedView.locationLabel.text = feed.location
//    feedView.nicknameButton.setTitle(
//      feed.nickname,
//      for: .normal
//    )
    feedView.descriptionTextView.text = feed.description
    feedView.bookmarkButton.setImage(
      feed.isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image,
      for: .normal
    )
    feedView.bookmarkLabel.text = "\(feed.bookmarkCount)"
    feedView.bookmarkButton.addTarget(
      self,
      action: #selector(bookmarkButtonTapped),
      for: .touchUpInside
    )
    feedView.deleteButton.isHidden = !feed.isMine
    feedView.deleteButton.addTarget(
      self,
      action: #selector(deleteButtonTapped),
      for: .touchUpInside
    )
    feedView.moreButton
      .addTarget(
        self,
        action: #selector(moreButtonTapped),
        for: .touchUpInside
      )
  }

  func updateBookmarkStatus(
    count: Int,
    isBookmarked: Bool
  ) {
    feedView.bookmarkButton.setImage(
      isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image,
      for: .normal
    )
    feedView.bookmarkLabel.text = "\(count)"
  }

  @objc
  private func bookmarkButtonTapped() {
    bookmarkAction?()
  }

  @objc
  private func deleteButtonTapped() {
    deleteAction?()
  }

  @objc 
  private func moreButtonTapped() {
    moreAction?()
  }
}
