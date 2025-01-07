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

@available(iOS 16.0, *)
final class OverviewViewController: UIViewController {
  
  private let viskitLogo = UIImageView()
  private let locationButton = UIButton()
  private var overviewCollectionView: UICollectionView?
  
  private var viewModel = OverviewViewModel()
  
  public init(viewModel: OverviewViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setOverviewCollectionView()
    setStyle()
    setUI()
    setAutolayout()
    bind()
    
    viewModel.getNearPlaceList()
  }
  
  private func setStyle() {
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
    overviewCollectionView?.showsHorizontalScrollIndicator = false
    overviewCollectionView?.dataSource = self
    overviewCollectionView?.delegate = self
    overviewCollectionView?.backgroundColor = .clear
    overviewCollectionView?.register(
      OverviewCollectionViewCell.self,
      forCellWithReuseIdentifier: OverviewCollectionViewCell.cellIdentifier
    )
  }
  
  private func bind() {
    viewModel.onNearRecordsUpdated = { [weak self] in
      DispatchQueue.main.async {
        self?.overviewCollectionView?.reloadData()
      }
    }
    
    viewModel.onLocationStateChanged = { [weak self] state in
      self?.locationButton.setImage(state.buttonImage, for: .normal)
    }
  }
  
  @objc private func locationButtonTapped() {
    viewModel.updateLocationState()
  }
  
  //  @objc private func placeDetailButtonTapped(_ sender: PlaceDetailButton) {
  //    guard let places = viewModel.nearRecords, places.indices.contains(sender.tag) else { return }
  //
  //      let place = places[sender.tag]
  //      let placeDetailVC = PlaceDetailViewController(place: place)
  //      navigationController?.pushViewController(placeDetailVC, animated: true)
  //  }
}

@available(iOS 16.0, *)
extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.nearRecords.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: OverviewCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? OverviewCollectionViewCell else {
        fatalError("Failed to dequeue OverviewCollectionViewCell")
      }
      
      let place = viewModel.nearRecords[indexPath.row]
      cell.backgroundColor = .clear
      cell.bind(place: place, records: [])
      
      viewModel.getPlaceRecordList(placeId: place.id)
      viewModel.onPlaceRecordsUpdated = { [weak cell] in
        DispatchQueue.main.async {
          cell?.updateRecords(records: self.viewModel.placeRecords)
        }
      }
      
      return cell
    }
}

@available(iOS 16.0, *)
extension OverviewViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cell = OverviewCollectionViewCell()
    let screenWidth = UIScreen.main.bounds.width
    let cellHeight = cell.contentHeight
    
    return CGSize(
      width: screenWidth,
      height: cellHeight
    )
  }
}
