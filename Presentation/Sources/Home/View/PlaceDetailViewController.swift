//
//  PlaceDetailViewController.swift
//  Presentation
//
//  Created by Chandrala on 10/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

@available(iOS 16.0, *)
final public class PlaceDetailViewController: UIViewController{
  
  var viewModel: PlaceDetailViewModel
  
  private var userLatitude: Double
  private var userLongitude: Double
  
  private let placeNameLabel = UILabel()
  private let detailLocationLabel = UILabel()
  private let findRouteButton = UIButton()
  private let reviewButton = UIButton()
  private let segmentedControl = PlaceDetailSegmentedControl()
  private var segmentedControlContainer = UIView()
  
  private let exhibitionListView = ExhibitionListView()
  private let reviewFeedView = ReviewFeedView()
  
  var updateBookmarkStateInOverview: (() -> Void)?
  
  init(place: Place, latitude: Double, longitude: Double) {
    self.userLatitude = latitude
    self.userLongitude = longitude
    self.viewModel = PlaceDetailViewModel(
      place: place,
      latitude: userLatitude,
      longitude: userLongitude
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = false
    
    setStyle()
    setUI()
    setAutolayout()
    setDelegate()
    bind()
    setTarget()
    
    viewModel.getExhibitionList(placeId: viewModel.selectedPlace.first?.id ?? 0)
    
    updateFilterButtonState(
      allState: viewModel.allFilterState,
      freeState: viewModel.freeFilterState,
      endSoonState: viewModel.endSoonFilterState
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleBookmarkStateChange(_:)),
      name: .bookmarkStateChanged,
      object: nil
    )
  }
  
  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitBlack.color
    title = "전시관"
    
    placeNameLabel.do {
      $0.text = viewModel.selectedPlace.first?.name ?? "전시회"
      $0.textColor = CommonAsset.viskitWhite.color
      $0.font = ViskitFont.title1.font
      $0.numberOfLines = 1
    }
    
    detailLocationLabel.do {
      $0.text = viewModel.selectedPlace.first?.address ?? "주소"
      $0.textColor = CommonAsset.viskitGray03.color
      $0.font = ViskitFont.body2.font
      $0.numberOfLines = 1
    }
    
    findRouteButton.do {
      $0.backgroundColor = CommonAsset.viskitGray01.color
      $0.setTitle("길찾기", for: .normal)
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
      $0.titleLabel?.font = ViskitFont.body2.font
      $0.cornerRadius(8)
    }
    
    reviewButton.do {
      $0.backgroundColor = CommonAsset.viskitGray01.color
      $0.setTitle("리뷰", for: .normal)
      $0.setTitleColor(CommonAsset.viskitBlack.color, for: .normal)
      $0.titleLabel?.font = ViskitFont.body2.font
      $0.cornerRadius(8)
    }
    
    segmentedControlContainer.do {
      $0.backgroundColor = .clear
    }
  }
  
  private func setUI() {
    view.addSubviews(
      placeNameLabel,
      detailLocationLabel,
      findRouteButton,
      reviewButton,
      segmentedControl,
      segmentedControlContainer
    )
    
    segmentedControlContainer.addSubviews(
      exhibitionListView,
      reviewFeedView
    )
  }
  
  private func setAutolayout() {
    placeNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(130)
      $0.centerX.equalToSuperview()
    }
    
    detailLocationLabel.snp.makeConstraints {
      $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
    }
    
    findRouteButton.snp.makeConstraints {
      $0.top.equalTo(detailLocationLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(111)
      $0.width.equalTo(75.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
    
    reviewButton.snp.makeConstraints {
      $0.top.equalTo(detailLocationLabel.snp.bottom).offset(24)
      $0.leading.equalTo(findRouteButton.snp.trailing).offset(16)
      $0.width.equalTo(63.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
    
    segmentedControl.snp.makeConstraints {
      $0.top.equalTo(findRouteButton.snp.bottom).offset(40)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(40.adaptiveHeight)
    }
    
    segmentedControlContainer.snp.makeConstraints {
      $0.top.equalTo(segmentedControl.snp.bottom)
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    exhibitionListView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    reviewFeedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setDelegate() {
    segmentedControl.delegate = self
  }
  
  private func setTarget() {
    reviewButton.addTarget(self, action: #selector(onReviewButtonTapped), for: .touchUpInside)
    findRouteButton.addTarget(self, action: #selector(onFindRouteButtonTapped), for: .touchUpInside)
    
    exhibitionListView.allFilterButton.tag = FilterType.all.rawValue
    exhibitionListView.freeFilterButton.tag = FilterType.free.rawValue
    exhibitionListView.endSoonFilterButton.tag = FilterType.endSoon.rawValue
    
    exhibitionListView.allFilterButton.addTarget(self, action: #selector(onFilterButtonTapped), for: .touchUpInside)
    exhibitionListView.freeFilterButton.addTarget(self, action: #selector(onFilterButtonTapped(_:)), for: .touchUpInside)
    exhibitionListView.endSoonFilterButton.addTarget(self, action: #selector(onFilterButtonTapped(_:)), for: .touchUpInside)
  }
  
  @objc private func onFilterButtonTapped(_ sender: UIButton) {
    guard let filterType = FilterType(rawValue: sender.tag) else { return }
    viewModel.updateFilterState(selected: filterType)
  }
  
  @objc private func onReviewButtonTapped(_ sender: UIButton) {
    guard let selectedPlace = viewModel.selectedPlace.first else {
      return
    }
    
    let reviewVC = ReviewWebViewController(platformId: selectedPlace.platformId)
    reviewVC.modalPresentationStyle = .pageSheet
    reviewVC.preferredContentSize = CGSize(width: view.frame.width, height: view.frame.height / 2)
    
    if let sheet = reviewVC.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.prefersGrabberVisible = true
    }
    
    present(reviewVC, animated: true)
  }
  
  @objc private func onFindRouteButtonTapped() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let kakaoAction = UIAlertAction(title: "카카오맵", style: .default) { [weak self] _ in
      self?.viewModel.openMap(type: .kakao, openInWebView: { urlString in
        guard let self = self else { return }
        WebViewManager.presentWebView(from: self, urlString: urlString)
      })
    }
    let naverAction = UIAlertAction(title: "네이버 지도", style: .default) { [weak self] _ in
      self?.viewModel.openMap(type: .naver, openInWebView: { urlString in
        guard let self = self else { return }
        WebViewManager.presentWebView(from: self, urlString: urlString)
      })
    }
    let googleAction = UIAlertAction(title: "구글 지도", style: .default) { [weak self] _ in
      self?.viewModel.openMap(type: .google, openInWebView: { urlString in
        guard let self = self else { return }
        WebViewManager.presentWebView(from: self, urlString: urlString)
      })
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    alert.addAction(kakaoAction)
    alert.addAction(naverAction)
    alert.addAction(googleAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  private func bind() {
    viewModel.onControlTypeChanged = { [weak self] type in
      self?.updateView(for: type)
    }
    
    viewModel.onControlTypeChanged?(viewModel.currentControlType)
    
    viewModel.onFilterChanged = { [weak self] allState, freeState, endSoonState in
      self?.updateFilterButtonState(
        allState: allState,
        freeState: freeState,
        endSoonState: endSoonState
      )
    }
    
    viewModel.onExhibitionsUpdated = { [weak self] in
      DispatchQueue.main.async {
        self?.exhibitionListView.updateExhibitionList(with: self?.viewModel.filteredExhibitions ?? [])
      }
    }
    
    viewModel.onFeedsUpdated = { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.reviewFeedView.updateFeedList(with: self.viewModel.reviewFeedList)
      }
    }
    
    reviewFeedView.onVideoSelectedInReviewFeed = { [weak self] selectedFeed in
      guard let self = self else { return }
      
      let videoVC = VideoFeedViewController(
        type: .place,
        placeId: selectedFeed.placeId,
        exhibitionId: selectedFeed.id,
        cursorId: nil,
        userId: selectedFeed.uploaderId
      )
      self.navigationController?.pushViewController(videoVC, animated: true)
    }
//    
//    reviewFeedView.onBookmarkButtonTappedInReviewFeed = { [weak self] record in
//      guard let self = self else { return }
//      viewModel.postBookmark(feed: record) { result in
//        switch result {
//        case .success:
//          print("Bookmark updated successfully")
//          self.updateBookmarkStateInOverview?()
//        case .failure(let error):
//          print("Failed to update bookmark: \(error)")
//        }
//      }
//    }
    
    DispatchQueue.main.async {
      self.reviewFeedView.updateFeedList(with: self.viewModel.reviewFeedList)
    }
  }
  
  private func updateView(for type: PlaceDetailControlType) {
    exhibitionListView.isHidden = type != .exhibitionList
    reviewFeedView.isHidden = type != .reviewFeed
  }
  
  private func updateFilterButtonState(
    allState: ChipState,
    freeState: ChipState,
    endSoonState: ChipState
  ) {
    exhibitionListView.allFilterButton.setState(state: allState)
    exhibitionListView.freeFilterButton.setState(state: freeState)
    exhibitionListView.endSoonFilterButton.setState(state: endSoonState)
  }
  
  @objc private func handleBookmarkStateChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let feed = userInfo["feed"] as? Feed else {
      return
    }
    
    viewModel.postBookmark(feed: feed) { [weak self] result in
      print("🚨PlaceDetail -> feed from Thumbnail: \(feed)🚨")
      guard let self = self else { return }
      switch result {
      case .success:
        print("Bookmark updated successfully.")
        DispatchQueue.main.async {
          self.reviewFeedView.reviewFeedCollectionView?.reloadData()
        }
      case .failure(let error):
        print("Failed to update bookmark: \(error)")
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .bookmarkStateChanged, object: nil)
  }
}

@available(iOS 16.0, *)
extension PlaceDetailViewController: PlaceDetailControlTypeDelegate {
  public func sendControlType(_ type: PlaceDetailControlType) {
    viewModel.updateControlType(to: type)
  }
}

