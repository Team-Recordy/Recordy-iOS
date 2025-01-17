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
  
  var onLocationUpdate: ((CLLocation) -> Void)?
  var onAuthorizationDenied: (() -> Void)?
  
  public init(viewModel: OverviewViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    setOverviewCollectionView()
    setStyle()
    setUI()
    setAutolayout()
    bind()
    
    viewModel.getNearPlaceList()
    viewModel.onNearPlacesUpdated = { [weak self] in
      guard let self = self else { return }
      self.viewModel.nearPlaces.forEach { place in
        self.viewModel.getPlaceRecordList(placeId: place.id, recordSize: place.recordSize)
      }
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleBookmarkStateChange(_:)),
      name: .bookmarkStateChanged,
      object: nil
    )
  }
  
  private func setStyle() {
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
      DispatchQueue.main.async {
        self?.overviewCollectionView?.reloadData()
      }
    }
    
    viewModel.onLocationStateChanged = { [weak self] state in
      self?.locationButton.setImage(state.buttonImage, for: .normal)
    }
    
    viewModel.onPlaceRecordsUpdated = { [weak self] in
      DispatchQueue.main.async {
        self?.overviewCollectionView?.reloadData()
      }
    }
    
    locationManager.onAuthorizationDenied = { [weak self] in
      self?.showLocationPermissionAlert()
    }
    
    locationManager.onLocationUpdate = { [weak self] location in
      guard let self = self else { return }
      self.viewModel.updateLocation(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    }
  }
  
  private func findIndexPath(for feed: Feed) -> IndexPath? {
    if let placeIndex = viewModel.nearPlaces.firstIndex(where: { $0.id == feed.placeId }),
       let recordIndex = viewModel.nearPlaces[placeIndex].recordList.firstIndex(where: { $0.id == feed.id }) {
      return IndexPath(item: recordIndex, section: placeIndex)
    }
    return nil
  }
  
  @objc private func handleBookmarkStateChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let feed = userInfo["feed"] as? Feed else {
      return
    }
    
    viewModel.postBookmark(feed: feed) { [weak self] result in
      print("🚨Overview -> feed from Thumbnail: \(feed)🚨")
      
      switch result {
      case .success:
        print("Bookmark updated successfully.")
        self?.overviewCollectionView?.reloadData()
//        if let indexPath = self?.findIndexPath(for: feed) {
//          DispatchQueue.main.async {
//            self?.overviewCollectionView?.reloadItems(at: [indexPath])
//          }
//        } else {
//          print("No matching IndexPath found for feed: \(feed.id)")
//        }
      case .failure(let error):
        print("Failed to update bookmark: \(error)")
      }
    }
  }
  
  @objc private func locationButtonTapped() {
    locationManager.requestAuthorization()
  }
  
  private func showLocationPermissionAlert() {
    let alert = UIAlertController(
      title: "위치 권한 필요",
      message: "앱 설정에서 위치 권한을 활성화해주세요.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .bookmarkStateChanged, object: nil)
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
      // TODO: Crash
      let place = viewModel.nearPlaces[indexPath.row]
      cell.backgroundColor = .clear
      cell.bind(place: place, records: place.recordList, index: indexPath.row)
      cell.onPlaceDetailButtonTapped = { [weak self] tag in
        guard let self = self else { return }
        self.handlePlaceDetailButtonTapped(index: tag)
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
      
      return cell
    }
  
  private func handlePlaceDetailButtonTapped(index: Int) {
    guard index >= 0, index < viewModel.nearPlaces.count else { return }
    guard let latitude = viewModel.userLatitude,
          let longitude = viewModel.userLongitude else {
      print("위치 정보가 설정되지 않았습니다.")
      return
    }
    
    let selectedPlace = viewModel.nearPlaces[index]
    let placeDetailVC = PlaceDetailViewController(
      place: selectedPlace,
      latitude: latitude,
      longitude: longitude
    )
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
