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
  
  var avPlayer: AVPlayer?
  var avPlayerLayer: AVPlayerLayer?
  var avPlayerLooper: AVPlayerLooper?
  var isPlaying: Bool = false
  var isPlayRequested: Bool = false
  weak var delegate: FeedWatchDelegate?
  private let playerView = UIView()
  let feedView = FeedView()
  var feed: Feed?

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
    avPlayer?.pause()
    avPlayer = nil
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
    self.avPlayer?.play()
    if let feed = self.feed {
      delegate?.play(feed: feed)
    }
  }
  
  func pause() {
    isPlayRequested = false
    self.avPlayer?.pause()
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
//    avPlayer?.currentItem?.addObserver(
//      self,
//      forKeyPath: "playbackBufferEmpty",
//      options: .new,
//      context: nil
//    )
//    avPlayer?.currentItem?.addObserver(
//      self,
//      forKeyPath: "playbackLikelyToKeepUp",
//      options: .new,
//      context: nil
//    )
//    avPlayer?.currentItem?.addObserver(
//      self,
//      forKeyPath: "playbackBufferFull",
//      options: .new,
//      context: nil
//    )
  }
  
  @objc private func playerItemDidReachEnd(notification: Notification) {
    avPlayer?.seek(to: CMTime.zero)
    avPlayer?.play()
  }
  
//  override func observeValue(
//    forKeyPath keyPath: String?,
//    of object: Any?,
//    change: [NSKeyValueChangeKey: Any]?,
//    context: UnsafeMutableRawPointer?
//  ) {
//    if object is AVPlayerItem {
//      switch keyPath {
//      case "playbackBufferEmpty":
//        print("bufferEmpty")
//      case "playbackLikelyToKeepUp":
//        print("LikelyToKeepUp")
//      case "playbackBufferFull":
//        print("BufferFull")
//      default:
//        print("Default")
//      }
//    }
//  }
  
  func bind(feed: Feed, bounds: CGRect, shouldAddPlayer: Bool) {
    self.feed = feed
    if shouldAddPlayer {
      addPlayer(for: URL(string: feed.videoLink)!, bounds: bounds)
    }
    self.feedView.locationLabel.text = feed.location
    self.feedView.nicknameButton.setTitle(feed.nickname, for: .normal)
    self.feedView.descriptionTextView.text = feed.description
    self.feedView.bookmarkButton.setImage(
      feed.isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image,
      for: .normal
    )
    self.feedView.bookmarkLabel.text = "\(feed.bookmarkCount)"
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
  
  func updateBookmarkStatus(
    count: Int,
    isBookmarked: Bool
  ) {
    self.feedView.bookmarkButton.setImage(
      isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image,
      for: .normal
    )
    self.feedView.bookmarkLabel.text = "\(count)"
  }
}
