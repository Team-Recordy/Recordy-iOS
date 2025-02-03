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

protocol CustomImagePickerDelegate: AnyObject {
  func didSelectedImage(_ image: UIImage)
}

final class CustomImagePickerViewController: UIViewController {
  weak var delegate: CustomImagePickerDelegate?
  
  private var assets: [PHAsset] = []
  private var selectedIndex: IndexPath?
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let photoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  private lazy var completeButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
      $0.addTarget(self, action: #selector(completeSelection), for: .touchUpInside)
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
  
  @objc private func completeSelection() {
    //TODO: 이미지 선택이 되었을 경우, 완료 버튼 활성화 및, 완료 버튼 눌렀을 때 ImagePicker 없어지도록.
  }
}
