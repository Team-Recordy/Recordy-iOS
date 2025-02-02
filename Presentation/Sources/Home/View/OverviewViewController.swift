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
import CoreLocation

@available(iOS 16.0, *)
final class OverviewViewController: UIViewController {
  
  private let locationManager = LocationManager()
  private var viewModel = OverviewViewModel()
  
  private let viskitLogo = UIImageView()
  private let locationButton = UIButton()
  private var overviewCollectionView: UICollectionView?
  
  public init(viewModel: OverviewViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    viewModel.getNearPlaceList()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setOverviewCollectionView()
    setStyle()
    setUI()
    setAutolayout()
    bind()
  }
  
  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitBG.color
    navigationController?.isNavigationBarHidden = true

    overviewCollectionView!.do {
      $0.backgroundColor = .clear
    }
    
    viskitLogo.do {
      $0.image = CommonAsset.viskitLogo.image
      $0.contentMode = .scaleAspectFit
    }
    
    locationButton.do {
      $0.setImage(CommonAsset.locationInactive.image, for: .normal)
      $0.contentMode = .scaleAspectFit
      $0.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
  }
  
  private func setUI() {
    view.addSubviews(
      viskitLogo,
      locationButton,
      overviewCollectionView!
    )
  }
  
  private func setAutolayout() {
    viskitLogo.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(75.adaptiveWidth)
      $0.height.equalTo(23.adaptiveHeight)
    }
    
    overviewCollectionView!.snp.makeConstraints {
      $0.top.equalTo(viskitLogo.snp.bottom).offset(31)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    locationButton.snp.makeConstraints {
      $0.width.equalTo(24.adaptiveWidth)
      $0.height.equalTo(24.adaptiveHeight)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  
  private func setOverviewCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    layout.minimumInteritemSpacing = 16
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: 16,
      right: 0
    )
    
    overviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    overviewCollectionView?.showsVerticalScrollIndicator = false
    overviewCollectionView?.backgroundColor = .clear
    overviewCollectionView?.register(
      OverviewCollectionViewCell.self,
      forCellWithReuseIdentifier: OverviewCollectionViewCell.cellIdentifier
    )
    overviewCollectionView?.dataSource = self
    overviewCollectionView?.delegate = self
  }
  
  private func bind() {
    viewModel.onNearPlacesUpdated = { [weak self] in
      guard let self = self else { return }
      let dispatchGroup = DispatchGroup()
      
      self.viewModel.nearPlaces.forEach { place in
        dispatchGroup.enter()
        self.viewModel.getPlaceRecordList(placeId: place.id, recordSize: place.recordSize) {
          dispatchGroup.leave()
        }
      }

      dispatchGroup.notify(queue: .main) {
        self.overviewCollectionView?.reloadData()
      }
    }
    
    viewModel.onLocationStateChanged = { [weak self] state in
      self?.locationButton.setImage(state.buttonImage, for: .normal)
    }
    
    locationManager.onLocationUpdated = { [weak self] location in
      guard let self = self else { return }
      self.viewModel.updateLocation()
      self.viewModel.getNearPlaceList()
    }
  }
  
  @objc private func locationButtonTapped() {
    let status = locationManager.currentAuthorizationStatus
    
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      self.viewModel.getNearPlaceList()
      self.showToast(status: .complete, message: "위치를 업데이트 했어요!", height: 70)
    } else if status == .denied || status == .restricted {
      DispatchQueue.main.async {
        self.showPopUp(type: .permission) {
          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
      }
    } else if status == .notDetermined {
      locationManager.requestAuthorization()
    }
  }
}

@available(iOS 16.0, *)
extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.nearPlaces.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: OverviewCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? OverviewCollectionViewCell else {
        fatalError("Failed to dequeue OverviewCollectionViewCell")
      }
      let place = viewModel.nearPlaces[indexPath.row]
      cell.backgroundColor = .clear
      cell.bind(place: place, records: place.recordList, index: indexPath.row)
      cell.onPlaceDetailButtonTapped = { [weak self] tag in
        guard let self = self else { return }
        self.handlePlaceDetailButtonTapped(index: tag)
      }
      cell.onBookmarkButtonTapped = { [weak self] recordIndex in
        guard let self = self else { return }
        self.viewModel.postBookmark(
          placeIndex: indexPath.row,
          recordIndex: recordIndex
        )
        cell.updateThumbnailBookmark(recordIndex: recordIndex, isBookmarked: viewModel.nearPlaces[indexPath.row].recordList[recordIndex].isBookmarked)
      }
      cell.onUpdateHeight = {
        DispatchQueue.main.async {
          collectionView.collectionViewLayout.invalidateLayout()
        }
      }
      cell.onVideoSelectedInCell = { [weak self] selectedFeed in
        guard let self = self else { return }
        
        let placeId = selectedFeed.placeId
        let exhibitionId = selectedFeed.id
        let uploaderId = selectedFeed.uploaderId
        let videoVC = VideoFeedViewController(
          type: .place,
          placeId: placeId,
          exhibitionId: exhibitionId,
          cursorId: 0,
          userId: uploaderId
        )
        self.navigationController?.pushViewController(videoVC, animated: true)
      }
      viewModel.onBookmarkUpdated = { [weak self] index in
        guard let self else { return }
        DispatchQueue.main.async {
          cell.updateRecords(records: self.viewModel.nearPlaces[index].recordList)
        }
      }
      return cell
    }
  
  private func handlePlaceDetailButtonTapped(index: Int) {
    guard index >= 0, index < viewModel.nearPlaces.count else { return }
    
    let selectedPlace = viewModel.nearPlaces[index]
    let placeDetailVC = PlaceDetailViewController(place: selectedPlace)
    placeDetailVC.updateBookmarkStateInOverview = { [weak self] in
      self?.viewModel.onPlaceRecordsUpdated?()
    }
    navigationController?.pushViewController(placeDetailVC, animated: true)
  }
}

@available(iOS 16.0, *)
extension OverviewViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let place = viewModel.nearPlaces[indexPath.row]
    let overViewCollectionViewCell = OverviewCollectionViewCell()
    overViewCollectionViewCell.bind(place: place, records: [])
    let screenWidth = UIScreen.main.bounds.width
    let cellHeight = overViewCollectionViewCell.contentHeight
    
    return CGSize(
      width: screenWidth,
      height: cellHeight
    )
  }
}
