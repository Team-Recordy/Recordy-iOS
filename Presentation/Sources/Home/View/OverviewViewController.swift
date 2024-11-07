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
  private let overviewScrollView = UIScrollView()
  private let contentView = UIView()
  private let overviewStackView = UIStackView()
  
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
    
    setStyle()
    setUI()
    setAutolayout()
    configureStackView()
    bind()
  }
  
  private func setStyle() {
    navigationController?.isNavigationBarHidden = true
    
    overviewScrollView.do {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    contentView.do {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    overviewStackView.do {
      $0.axis = .vertical
      $0.spacing = 16
      $0.translatesAutoresizingMaskIntoConstraints = false
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
      overviewScrollView
    )
    overviewScrollView.addSubview(contentView)
    contentView.addSubview(overviewStackView)
  }
  
  private func setAutolayout() {
    viskitLogo.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(75.adaptiveWidth)
      $0.height.equalTo(23.adaptiveHeight)
    }
    
    overviewScrollView.snp.makeConstraints {
      $0.top.equalTo(viskitLogo.snp.bottom).offset(31)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualToSuperview().priority(.low)
    }
    
    overviewStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.verticalEdges.equalToSuperview()
    }

    locationButton.snp.makeConstraints {
      $0.width.equalTo(24.adaptiveWidth)
      $0.height.equalTo(24.adaptiveHeight)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  /// places 내의 객체 개수 만큼 button, collectionView 생성
  private func configureStackView() {
    overviewStackView.spacing = 16
    
    for (index, place) in (viewModel.overview.first?.places ?? []).enumerated() {
      let placeDetailButton = PlaceDetailButton()
      placeDetailButton.bind(place: place)
      placeDetailButton.tag = index
      placeDetailButton.addTarget(self, action: #selector(placeDetailButtonTapped), for: .touchUpInside)
      
      let placeInfoCollectionView = createCollectionView()
      
      overviewStackView.addArrangedSubview(placeDetailButton)
      overviewStackView.addArrangedSubview(placeInfoCollectionView)
      
      placeDetailButton.snp.makeConstraints {
        $0.height.equalTo(102.adaptiveHeight)
      }
      
      placeInfoCollectionView.snp.makeConstraints {
        $0.height.equalTo(240.adaptiveHeight)
      }
    }
  }
  
  private func createCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.itemSize = CGSize(width: 135, height: 240)
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0
    )
    
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "DefaultCell"
    )
    collectionView.delegate = self
    collectionView.dataSource = self
    
    return collectionView
  }
  
  private func bind() {
    viewModel.onLocationStateChanged = { [weak self] state in
      self?.locationButton.setImage(state.buttonImage, for: .normal)
    }
  }
  
  @objc private func locationButtonTapped() {
    viewModel.updateLocationState()
  }
  
  @objc private func placeDetailButtonTapped(_ sender: PlaceDetailButton) {
    guard let places = viewModel.overview.first?.places, places.indices.contains(sender.tag) else { return }
      
      let place = places[sender.tag]
      let placeDetailVC = PlaceDetailViewController(place: place)
      navigationController?.pushViewController(placeDetailVC, animated: true)
  }
}

@available(iOS 16.0, *)
extension OverviewViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 10
  }

  public func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "DefaultCell",
      for: indexPath
    )
    cell.backgroundColor = .lightGray
    
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
    return CGSize(
      width: 135.adaptiveWidth,
      height: 240.adaptiveHeight
    )
  }
}
