//
//  VideoFeedViewController.swift
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

public class VideoFeedViewController: UIViewController {

  private var collectionView: UICollectionView? = nil
  private let recordyToggle = RecordyToggle()
  private var isFetched = false
  private var isPlayed = false

  var type: VideoFeedType
  private var viewModel: VideoFeedViewModel

  init(
    type: VideoFeedType,
    keyword: Keyword? = nil,
    currentId: Int? = nil,
    cursorId: Int? = nil,
    userId: Int? = nil
  ) {
    self.type = type
    self.viewModel = VideoFeedViewModel(
      type: type,
      keyword: keyword,
      currentId: currentId,
      cursorId: cursorId,
      userId: userId
    )
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setStyle()
    setUI()
    setAutolayout()
  }

  public override func viewWillAppear(_ animated: Bool) {
    bind()
    viewModel.recordListCase()
  }

  public override func viewDidDisappear(_ animated: Bool) {
    removeAVPlayers()
  }

  private func bind() {
    viewModel.onFeedListUpdate = { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.collectionView!.reloadData()
        self.isPlayed = false
      }
    }
  }

  private func setStyle() {
    self.navigationController?.navigationBar.isHidden = self.type == .all || self.type == .following
    self.view.backgroundColor = CommonAsset.recordyBG.color
    self.recordyToggle.do {
      $0.isHidden = type != .all && type != .following
    }
    self.recordyToggle.toggleAction = { [weak self] toggleState in
      guard let self = self else { return }
      toggleButtonTapped(type: toggleState == .all ? .following : .all)
    }
    if self.type != .all {
      self.navigationController?.navigationBar.topItem?.title = ""
    }
  }

  func toggleButtonTapped(type: VideoFeedType) {
    self.viewModel.type = type == .all ? .following : .all
    self.viewModel.recordListCase()
    self.isPlayed = false
  }

  private func setUI() {
    self.view.addSubview(collectionView!)
    self.view.addSubview(recordyToggle)
    self.view.bringSubviewToFront(recordyToggle)
  }

  private func setAutolayout() {
    self.collectionView!.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.recordyToggle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(12.adaptiveHeight)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(124)
      $0.height.equalTo(32)
    }
  }

  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.collectionView!.showsVerticalScrollIndicator = false
    self.collectionView!.contentInsetAdjustmentBehavior = .never
    self.collectionView!.isPagingEnabled = true
    self.collectionView!.backgroundColor = CommonAsset.recordyBG.color
    self.collectionView!.register(
      FeedCell.self,
      forCellWithReuseIdentifier: FeedCell.cellIdentifier
    )
    self.collectionView!.delegate = self
    self.collectionView!.dataSource = self
  }

  @objc private func nicknameButtonTapped(_ sender: UIButton) {
    print(type != .userProfile && type != .myProfile)
    guard type != .userProfile && type != .myProfile else { return }
    print(#function)
    let index = sender.tag
    let feed = viewModel.feedList[index]
    let userVC = OtherUserProfileViewController(id: feed.userId)
    self.navigationController?.pushViewController(userVC, animated: true)
  }
}

extension VideoFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.feedList.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: FeedCell.cellIdentifier,
      for: indexPath
    ) as! FeedCell
    let feed = viewModel.feedList[indexPath.row]
    cell.delegate = self
    cell.bind(
      feed: feed,
      bounds: collectionView.frame,
      shouldAddPlayer: cell.avPlayer == nil
    )
    if !isPlayed && indexPath.row == 0 {
      cell.play()
      isPlayed = true
    }
    cell.feedView.nicknameButton.tag = indexPath.row
    cell.feedView.nicknameButton.addTarget(
      self,
      action: #selector(nicknameButtonTapped),
      for: .touchUpInside
    )
    cell.bookmarkAction = {
      self.viewModel.bookmarkButtonTapped(indexPath.row)
      cell.updateBookmarkStatus(
        count: self.viewModel.feedList[indexPath.row].bookmarkCount,
        isBookmarked: self.viewModel.feedList[indexPath.row].isBookmarked
      )
    }
    //    cell.deleteAction = {
    //
    //    }
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if indexPath.row == viewModel.feedList.count - 3 {
      viewModel.recordListCase()
    }
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    checkAndPlay()
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    let cell = cell as! FeedCell
    cell.pause()
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.frame.size
  }
}


extension VideoFeedViewController {
  private func removeAVPlayers() {
    let visibleCells = collectionView?.visibleCells.compactMap { $0 as? FeedCell } ?? []
    for cell in visibleCells {
      cell.deinitPlayers()
    }
  }

  private func checkAndPlay() {
    let visibleCells = collectionView!.visibleCells.compactMap { $0 as? FeedCell }
    visibleCells.forEach {
      let frame = $0.frame
      let window = self.view.window!
      let rect = window.convert(frame, from: $0.superview!)
      let intersection = rect.intersection(window.bounds)
      let ratio = (intersection.width * intersection.height) / (frame.width * frame.height)
      if ratio > 0.5 {
        if !$0.isPlayRequested {
          $0.play()
        }
      } else {
        $0.pause()
      }
    }
  }

  private func playFirstVisibleCell() {
    let visibleCells = collectionView?.visibleCells.compactMap { $0 as? FeedCell } ?? []
    guard let firstCell = visibleCells.first else { return }
    firstCell.play()
    isPlayed = true
  }
}

extension VideoFeedViewController: FeedWatchDelegate {
  func play(feed: Feed) {
    viewModel.postIsFeedWatched(feed: feed)
  }
}
