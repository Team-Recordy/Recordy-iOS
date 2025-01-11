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
  
  private let placeNameLabel = UILabel()
  private let detailLocationLabel = UILabel()
  private let findRouteButton = UIButton()
  private let reviewButton = UIButton()
  private let segmentedControl = PlaceDetailSegmentedControl()
  private var segmentedControlContainer = UIView()
  
  private let exhibitionListView = ExhibitionListView()
  private let reviewFeedView = ReviewFeedView()
  
  init(place: Place, reviewFeeds: [Feed]) {
    self.viewModel = PlaceDetailViewModel(
      place: place,
      reviewFeeds: reviewFeeds
    )
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
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
}

@available(iOS 16.0, *)
extension PlaceDetailViewController: PlaceDetailControlTypeDelegate {
  public func sendControlType(_ type: PlaceDetailControlType) {
    viewModel.updateControlType(to: type)
  }
}
