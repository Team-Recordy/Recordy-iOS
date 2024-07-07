//
//  VideoFeedViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import AVKit

import RxSwift
import RxCocoa
import SnapKit
import Then

public class VideoFeedViewController: UIViewController {

  private var collectionView: UICollectionView? = nil

  private var viewModel = VideoFeedViewModel()
  private let disposeBag = DisposeBag()
  private let fetchVideoRelay = PublishRelay<Void>()
  private let currentIndexRelay = PublishRelay<Int>()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setUI()
    setAutolayout()
    bind()
  }

  private func setUI() {
    self.view.addSubview(collectionView!)
  }

  private func setAutolayout() {
    self.collectionView!.snp.makeConstraints {
      $0.verticalEdges.horizontalEdges.equalToSuperview()
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
    let input = VideoFeedViewModel.Input(
      fetchVideos: fetchVideoRelay,
      currentIndex: currentIndexRelay
    )
    let output = viewModel.transform(input: input)

    output.videoList
      .drive(
        collectionView!.rx.items(
          cellIdentifier: FeedCell.cellIdentifier,
          cellType: FeedCell.self
        )
      ) { (row, url, cell) in
        cell.bind(
          url: url,
          bounds: self.collectionView!.frame
        )
        cell.avQueuePlayer?.play()
      }
      .disposed(by: disposeBag)

    collectionView?.rx.willDisplayCell
      .subscribe(onNext: { [weak self] cell, indexPath in
        guard let self = self else { return }
        if indexPath.row == self.viewModel.videoListRelay.value.count - 3 {
          input.fetchVideos.accept(())
        }
        self.currentIndexRelay.accept(indexPath.row)
        print(viewModel.videoListRelay.value[indexPath.row])
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

    fetchVideoRelay.accept(())
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
