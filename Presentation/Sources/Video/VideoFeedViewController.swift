//
//  VideoFeedViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import AVKit

import Common

import SnapKit
import Then

public class VideoFeedViewController: UIViewController {

  private var collectionView: UICollectionView? = nil
  private let recordyToggle = RecordyToggle()
  private var isFetched = false
  private var isPlayed = false

  private var viewModel = VideoFeedViewModel()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setUI()
    setAutolayout()
    fetchInitialVideos()
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
    self.collectionView!.register(
      FeedCell.self,
      forCellWithReuseIdentifier: FeedCell.cellIdentifier
    )
    self.collectionView!.delegate = self
    self.collectionView!.dataSource = self
  }

  private func fetchInitialVideos() {
    viewModel.fetchVideos {
      DispatchQueue.main.async {
        self.collectionView?.reloadData()
      }
    }
  }

  private func fetchMoreVideos() {
    if !isFetched {
      viewModel.fetchMoreVideos {
        DispatchQueue.main.async {
          self.collectionView?.reloadData()
          self.isFetched.toggle()
        }
      }
    }
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
    cell.bind(
      feed: feed,
      bounds: collectionView.frame,
      shouldAddPlayer: cell.avQueuePlayer == nil
    )
    if !isPlayed {
      cell.play()
      isPlayed = true
    }
    cell.bookmarkTappedRelay = {
      self.viewModel.bookmarkButtonTapped(indexPath.row)
      cell.updateBookmarkStatus(isBookmarked: self.viewModel.feedList[indexPath.row].isBookmarked)
    }
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if viewModel.feedList.count == indexPath.row + 1 {
      fetchMoreVideos()
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
}
