//
//  OverviewViewController.swift
//  Presentation
//
//  Created by Chandrala on 10/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

final class OverviewViewController: UIViewController {
  
  var placeInfo: [PlaceInfo] = []
  
  let rootView = OverviewView()
  
  public override func loadView() {
    self.view = rootView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    rootView.placeInfoCollectionView.delegate = self
  }
  
  func setPlaceInfoCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.itemSize = CGSize(
      width: 135,
      height: 240
    )
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 16.adaptiveWidth,
      bottom: 0,
      right: 0
    )

    rootView.placeInfoCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    rootView.placeInfoCollectionView.showsHorizontalScrollIndicator = false
    rootView.placeInfoCollectionView.register(
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
    )
    rootView.placeInfoCollectionView.delegate = self
    rootView.placeInfoCollectionView.dataSource = self
  }
}

extension OverviewViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 10
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as! ThumbnailCollectionViewCell
    let placeInfoRecord = placeInfo[indexPath.row]
//    cell.configure(feed: PlaceInfo)
//    cell.bookmarkButtonEvent = { [weak self] in
//      guard let self = self else { return }
//      self.postBookmarkRequest(
//        index: indexPath.row,
//        type: .famous
//      )
//      cell.updateBookmarkButton(isBookmarked: famousRecords[indexPath.row].isBookmarked)
//    }
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
//    var nextType: VideoFeedType = .famous
//    var currentId: Int?
//    if collectionView == rootView.placeInfoCollectionView {
//      nextType = .famous
//      currentId = famousRecords[indexPath.row].id
//    }
//    let videoFeedViewController = VideoFeedViewController(
//      type: nextType,
//      currentId: currentId,
//      cursorId: 0,
//      userId: 0
//    )
//    self.navigationController?.pushViewController(
//      videoFeedViewController,
//      animated: true
//    )
  }
}

extension OverviewViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: 135.adaptiveWidth,
      height: 240.adaptiveHeight
    )
  }
}
