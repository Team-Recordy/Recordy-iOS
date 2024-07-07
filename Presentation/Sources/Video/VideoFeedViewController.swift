//
//  VideoViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class VideoFeedViewController: UIViewController {

  private var collectionView: UICollectionView? = nil

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
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
      VideoCell.self,
      forCellWithReuseIdentifier: VideoCell.cellIdentifier
    )
    //    self.collectionView!.rx.setDelegate(self).disposed(by: disposeBag)
    self.collectionView!.delegate = self
    self.collectionView!.dataSource = self
  }
}

extension VideoFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: VideoCell.cellIdentifier,
      for: indexPath
    ) as! VideoCell
    return cell
  }
}

extension VideoFeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.frame.size
  }
}
