//
//  CustomImagePickerViewController.swift
//  Presentation
//
//  Created by 송여경 on 2/3/25.
//  Copyright © 2025 com. All rights reserved.
//

import UIKit
import Photos
import Common

import SnapKit
import Then

public protocol CustomImagePickerDelegate: AnyObject {
  func didSelectedImage(_ image: UIImage)
}

public final class CustomImagePickerViewController: UIViewController {
  public weak var delegate: CustomImagePickerDelegate?
  
  private var assets: [PHAsset] = []
  private var selectedIndex: IndexPath?
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let photoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  private lazy var completeButton = UIButton()
  
  public init() {
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    photoCollectionView.delegate = self
    photoCollectionView.dataSource = self
    
    setUI()
    setStyle()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    view.addSubview(photoCollectionView)
  }
  
  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitBG.color
    configureNavigationBar()
    setupCustomBackButton()
    
    collectionViewLayout.do {
      $0.minimumInteritemSpacing = 3
      $0.minimumLineSpacing = 3
      $0.itemSize = CGSize(width: 90, height: 90)
      $0.sectionInset = .zero
    }
    
    photoCollectionView.do {
      $0.backgroundColor = CommonAsset.viskitBG.color
      $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    completeButton.do {
      $0.setTitle(
        "완료",
        for: .normal
      )
      $0.setTitleColor(
        CommonAsset.viskitGray01.color,
        for: .normal
      )
      $0.titleLabel?.font = ViskitFont.title3.font
      $0.isEnabled = false
      $0.addTarget(
        self,
        action: #selector(completeSelection),
        for: .touchUpInside
      )
      $0.setTitleColor(
        CommonAsset.viskitGray08.color,
        for: .normal
      )
    }
    
  }
  
  private func setLayout() {
    photoCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func configureNavigationBar() {
    navigationItem.title = "프로필 사진"
    let completeBarButtonItem = UIBarButtonItem(customView: completeButton)
    navigationItem.rightBarButtonItem = completeBarButtonItem
    
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.tintColor = .white
      navigationBar.titleTextAttributes = [
        .foregroundColor: CommonAsset.viskitGray01.color,
        .font: ViskitFont.title3.font
      ]
    }
  }
  
  private func fetchImages() {
    let status = PHPhotoLibrary.authorizationStatus()
    
    guard status == .authorized || status == .limited else {
      PHPhotoLibrary.requestAuthorization { newStatus in
        if newStatus == .authorized || newStatus == .limited {
          self.fetchImages()
        }
      }
      return
    }
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    fetchResult.enumerateObjects { asset, _, _ in
      self.assets.append(asset)
    }
    
    DispatchQueue.main.async {
      self.photoCollectionView.reloadData()
    }
  }
}

extension CustomImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return assets.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ImageCell.identifier,
      for: indexPath
    ) as? ImageCell else {
      return UICollectionViewCell()
    }
    
    let asset = assets[indexPath.item]
    cell.configure(with: asset)
    
    let isSelected = indexPath == selectedIndex
    cell.setSelected(selected: isSelected)
    
    return cell
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    if let previousIndex = selectedIndex,
       let previousCell = collectionView.cellForItem(at: previousIndex) as? ImageCell {
      previousCell.setSelected(selected: false)
    }
    
    if selectedIndex == indexPath {
      selectedIndex = nil
    } else {
      selectedIndex = indexPath
    }
    
    if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
      cell.setSelected(selected: selectedIndex != nil)
    }
    
    let isSelected = selectedIndex != nil
    completeButton.isEnabled = isSelected
    completeButton.setTitleColor(isSelected ? CommonAsset.viskitGray01.color : CommonAsset.viskitGray08.color, for: .normal)
  }
  
  @objc private func completeSelection() {
    guard let selectedIndex = selectedIndex else { return }
    let asset = assets[selectedIndex.item]
    
    let options = PHImageRequestOptions()
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .exact
    options.isSynchronous = false
    
    PHImageManager.default().requestImage(
      for: asset,
      targetSize: PHImageManagerMaximumSize,
      contentMode: .aspectFit,
      options: options
    ) { [weak self] image, _ in
      if let image = image {
        DispatchQueue.main.async {
          self?.delegate?.didSelectedImage(image)
          self?.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  
}
