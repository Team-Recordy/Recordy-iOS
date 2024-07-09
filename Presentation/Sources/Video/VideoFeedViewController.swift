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

import RxSwift
import RxCocoa
import SnapKit
import Then

public class VideoFeedViewController: UIViewController {

  private var collectionView: UICollectionView? = nil
  private let recordyToggle = RecordyToggle()

  private var viewModel = VideoFeedViewModel()
  private let disposeBag = DisposeBag()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setUI()
    setAutolayout()
    bind()
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
    self.collectionView!.rx.setDelegate(self).disposed(by: disposeBag)
  }

  func bind() {
    viewModel.output.feedList
      .asDriver()
      .drive(
        collectionView!.rx.items(
          cellIdentifier: FeedCell.cellIdentifier,
          cellType: FeedCell.self
        )
      ) { (row, feed, cell) in
        cell.bind(
          feed: feed,
          bounds: self.collectionView!.frame
        )
        cell.avQueuePlayer?.play()
        cell.bookmarkTappedRelay
          .map { row }
          .bind(to: self.viewModel.input.bookmarkTapped)
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: disposeBag)

    collectionView?.rx.willDisplayCell
      .subscribe(onNext: { [weak self] cell, indexPath in
        guard let self = self else { return }
        if indexPath.row == self.viewModel.output.feedList.value.count - 3 {
          viewModel.input.fetchVideos.accept(())
        }
        self.viewModel.input.currentIndex.accept(indexPath.row)
      })
      .disposed(by: disposeBag)

    collectionView!.rx.didEndDisplayingCell
      .subscribe { cell, indexPath in
        let cell = cell as! FeedCell
        cell.avQueuePlayer?.pause()
      }
      .disposed(by: disposeBag)

    collectionView?.rx.willBeginDragging
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.collectionView?.visibleCells.forEach { cell in
                if let feedCell = cell as? FeedCell {
                    feedCell.avQueuePlayer?.pause()
                }
            }
        })
        .disposed(by: disposeBag)

    collectionView?.rx.didEndDecelerating
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.collectionView?.visibleCells.forEach { cell in
                if let feedCell = cell as? FeedCell {
                    feedCell.avQueuePlayer?.seek(to: CMTime.zero)
                    feedCell.avQueuePlayer?.play()
                }
            }
        })
        .disposed(by: disposeBag)
  }
}

extension VideoFeedViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.frame.size
  }
}
