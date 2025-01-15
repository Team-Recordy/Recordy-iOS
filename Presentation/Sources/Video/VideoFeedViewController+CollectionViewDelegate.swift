//
//  VideoFeedViewController+CollectionViewDelegate.swift
//  Presentation
//
//  Created by 한지석 on 10/31/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

@available(iOS 16.0, *)
extension VideoFeedViewController: UICollectionViewDataSource {

//  @objc private func nicknameButtonTapped(_ sender: UIButton) {
//    guard type != .userProfile && type != .myProfile else { return }
//    let index = sender.tag
//    let feed = viewModel.feedList[index]
//    let userViewController = OtherUserProfileViewController(id: feed.uploaderId)
//    navigationController?.pushViewController(
//        userViewController,
//        animated: true
//      )
//  }

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
    cell.bookmarkAction = { [weak self] in
      guard let self else { return }
//      self.viewModel.bookmarkButtonTapped(indexPath.row)
      cell.updateBookmarkStatus(
        count: self.viewModel.feedList[indexPath.row].bookmarkCount,
        isBookmarked: self.viewModel.feedList[indexPath.row].isBookmarked
      )
    }
    cell.moreAction = { [weak self] in
      guard let self else { return }
      self.sheetAction()
    }
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    //    if indexPath.row == viewModel.feedList.count - 3 {
    //      viewModel.recordListCase()
    //    }
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

  func removeAVPlayers() {
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

@available(iOS 16.0, *)
extension VideoFeedViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.frame.size
  }
}

@available(iOS 16.0, *)
extension VideoFeedViewController: UICollectionViewDelegate { }
