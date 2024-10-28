//
//  PlaceDetailViewController.swift
//  Presentation
//
//  Created by Chandrala on 10/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
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

public enum PlaceDetailControlType: String {
  case exhibitionList = "전시 리스트"
  case reviewFeed = "후기 영상"
}

final public class PlaceDetailViewController: UIViewController{
  
  let placeDetailView = PlaceDetailView()
  
  var placeDetailControlType: PlaceDetailControlType = .exhibitionList {
    didSet {
      controlTypeChanged()
    }
  }
  
  public override func loadView() {
    view = placeDetailView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    controlTypeChanged()
  }
  
  private func setDelegate() {
    placeDetailView.segmentedControl.delegate = self
    placeDetailView.exhibitionListView.exhibitionCollectionView?.delegate = self
    placeDetailView.reviewFeedView.reviewFeedCollectionView?.delegate = self
    placeDetailView.exhibitionListView.exhibitionCollectionView?.dataSource = self
    placeDetailView.reviewFeedView.reviewFeedCollectionView?.dataSource = self
  }
  
  func controlTypeChanged() {
    placeDetailView.exhibitionListView.isHidden = placeDetailControlType != .exhibitionList
    placeDetailView.reviewFeedView.isHidden = placeDetailControlType != .reviewFeed
  }
}

extension PlaceDetailViewController: PlaceDetailControlTypeDelegate {
  public func sendControlType(_ type: PlaceDetailControlType) {
    self.placeDetailControlType = type
  }
}

@available(iOS 16.0, *)
extension PlaceDetailViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case placeDetailView.exhibitionListView.exhibitionCollectionView:
      return 10
      
    case placeDetailView.reviewFeedView.reviewFeedCollectionView:
      return 10
      
    default:
      return 0
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell: UICollectionViewCell
      switch collectionView {
      case placeDetailView.exhibitionListView.exhibitionCollectionView:
        cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ExhibitionCollectionViewCell.cellIdentifier,
          for: indexPath
        )
        cell.backgroundColor = CommonAsset.viskitGray10.color
      case placeDetailView.reviewFeedView.reviewFeedCollectionView:
        cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: "DefaultCell",
          for: indexPath
        )
        cell.backgroundColor = .lightGray
      default:
        fatalError("Unexpected collection view")
      }
      return cell
    }
}

@available(iOS 16.0, *)
extension PlaceDetailViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    // TODO: 두줄일 때 height 늘어나게 설정
    case placeDetailView.exhibitionListView.exhibitionCollectionView:
      return CGSize(width: 335.adaptiveWidth, height: 74.adaptiveHeight)
    
    case placeDetailView.reviewFeedView.reviewFeedCollectionView:
      return CGSize(width: 162.adaptiveWidth, height: 288.adaptiveHeight)
      
    default:
      return CGSize.zero
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    switch collectionView {
    case placeDetailView.exhibitionListView.exhibitionCollectionView:
      return 12.adaptiveHeight
      
    case placeDetailView.reviewFeedView.reviewFeedCollectionView:
      return 16.adaptiveHeight
      
    default:
      return 0
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      if collectionView == placeDetailView.reviewFeedView.reviewFeedCollectionView {
        return 11.adaptiveWidth
      }
      return 0
  }
}
