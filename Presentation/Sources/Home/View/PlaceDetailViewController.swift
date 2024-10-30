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
  
  let placeNameLabel = UILabel()
  let detailLocationLabel = UILabel()
  let findRouteButton = UIButton()
  let reviewButton = UIButton()
  public let segmentedControl = PlaceDetailSegmentedControl()
  var segmentedControlContainer = UIView()
  
  let exhibitionListView = ExhibitionListView()
  let reviewFeedView = ReviewFeedView()
  
  init(place: Place) {
    self.viewModel = PlaceDetailViewModel(place: place)
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
    configureView()
    bind()
    setTarget()
  }
  
  func setStyle() {
    view.backgroundColor = CommonAsset.viskitBlack.color
    title = "전시관"
    
    placeNameLabel.do {
      $0.text = viewModel.place.title
      $0.textColor = CommonAsset.viskitWhite.color
      $0.font = ViskitFont.title1.font
      $0.numberOfLines = 1
    }
    
    detailLocationLabel.do {
      $0.text = viewModel.place.detailLocation
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
  
  func setUI() {
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
  
  func setAutolayout() {
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
      $0.height.equalTo(34)
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
    exhibitionListView.exhibitionCollectionView?.delegate = self
    reviewFeedView.reviewFeedCollectionView?.delegate = self
    exhibitionListView.exhibitionCollectionView?.dataSource = self
    reviewFeedView.reviewFeedCollectionView?.dataSource = self
  }
  
  private func setTarget() {
    exhibitionListView.allFilterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
    exhibitionListView.freeFilterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
    exhibitionListView.endSoonFilterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
  }
  
  @objc private func filterButtonTapped(_ sender: UIButton) {
    if sender == exhibitionListView.allFilterButton {
      viewModel.updateFilterState(selected: .all)
    } else if sender == exhibitionListView.freeFilterButton {
      viewModel.updateFilterState(selected: .free)
    } else if sender == exhibitionListView.endSoonFilterButton {
      viewModel.updateFilterState(selected: .endSoon)
    }
  }
  
  private func configureView() {
    exhibitionListView.updateExhibitionList(data: viewModel.place)
  }
  
  private func bind() {
    viewModel.onControlTypeChanged = { [weak self] type in
      self?.updateView(for: type)
    }
    viewModel.onControlTypeChanged?(viewModel.currentControlType)
    
    viewModel.onFilterChanged = { [weak self] allState, freeState, endSoonState in
      self?.updateFilterButtonStates(
        allState: allState,
        freeState: freeState,
        endSoonState: endSoonState
      )
    }
    viewModel.onFilterChanged?(
      viewModel.allFilterState,
      viewModel.freeFilterState,
      viewModel.endSoonFilterState
    )
  }
  
  private func updateView(for type: PlaceDetailControlType) {
    exhibitionListView.isHidden = type != .exhibitionList
    reviewFeedView.isHidden = type != .reviewFeed
  }
  
  private func updateFilterButtonStates(
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

@available(iOS 16.0, *)
extension PlaceDetailViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case exhibitionListView.exhibitionCollectionView:
      return viewModel.place.placeInfoList.count
    case reviewFeedView.reviewFeedCollectionView:
      return 10
    default:
      return 0
    }
  }
  
  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell: UICollectionViewCell
      switch collectionView {
      case exhibitionListView.exhibitionCollectionView:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ExhibitionCollectionViewCell.cellIdentifier,
          for: indexPath
        ) as? ExhibitionCollectionViewCell else {
          fatalError("Could not dequeue ExhibitionCollectionViewCell")
        }
        let placeInfo = viewModel.place.placeInfoList[indexPath.row]
        cell.bind(with: placeInfo)
        cell.backgroundColor = CommonAsset.viskitGray10.color
        return cell
        
      case reviewFeedView.reviewFeedCollectionView:
        cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: "DefaultCell",
          for: indexPath
        )
        cell.backgroundColor = .lightGray
        return cell
        
      default:
        fatalError("Unexpected collection view")
      }
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
    case exhibitionListView.exhibitionCollectionView:
      return CGSize(width: 335.adaptiveWidth, height: 74.adaptiveHeight)
      
    case reviewFeedView.reviewFeedCollectionView:
      return CGSize(width: 162.adaptiveWidth, height: 288.adaptiveHeight)
      
    default:
      return CGSize.zero
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    switch collectionView {
    case exhibitionListView.exhibitionCollectionView:
      return 12.adaptiveHeight
    case reviewFeedView.reviewFeedCollectionView:
      return 16.adaptiveHeight
    default:
      return 0
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == reviewFeedView.reviewFeedCollectionView {
      return 11.adaptiveWidth
    }
    return 0
  }
}
