
//
//  MyRecordViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//  setStyle() -> setUI() -> setAutolayout()

import UIKit
import SnapKit
import Then

import Core
import Common

public class MyRecordViewController: UIViewController {
  
  private let viewModel = MyRecordViewModel()
  
  let profileInfoView = ProfileInfoView()
  let segmentControlView = ProfileSegmentControllView()
  let emptyRecordView = UIImageView()
  let emptyRecordText = UIImageView()
  let recordButton = UIButton()
  let countLabel = UILabel()
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 10
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
    bindViewModel()
    viewModel.fetchRecords()
  }
  
  public func setStyle() {
    view.backgroundColor = .black
    
    emptyRecordView.do {
      $0.image = CommonAsset.mypageCamera.image
      $0.contentMode = .scaleAspectFit
    }
    
    emptyRecordText.do {
      $0.image = CommonAsset.myRecordText.image
      $0.contentMode = .scaleAspectFit
    }
    
    recordButton.do {
      $0.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
      $0.setImage(CommonAsset.gorecord.image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
    }
    
    countLabel.do {
      $0.text = "0개의 기록"
      $0.textColor = .white
      $0.font = RecordyFont.caption1.font
      $0.numberOfLines = 0
      $0.textAlignment = .right
    }
    
    collectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.backgroundColor = .clear
      $0.isHidden = true
      $0.register(RecordCollectionViewCell.self, forCellWithReuseIdentifier: "RecordCell")
    }
  }
  
  private func setUI() {
    view.addSubview(profileInfoView)
    view.addSubview(segmentControlView)
    view.addSubview(countLabel)
    view.addSubview(emptyRecordView)
    view.addSubview(emptyRecordText)
    view.addSubview(recordButton)
    view.addSubview(collectionView)
  }
  
  private func setAutoLayout() {
    profileInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.width.equalTo(335.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }
    
    segmentControlView.snp.makeConstraints {
      $0.top.equalTo(profileInfoView.snp.bottom).offset(35)
      $0.leading.trailing.equalToSuperview()
    }
    
    countLabel.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(18)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.equalTo(160)
      $0.height.equalTo(18)
    }
    
    emptyRecordView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(96)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(138)
      $0.width.height.equalTo(100)
    }
    
    emptyRecordText.snp.makeConstraints {
      $0.top.equalTo(emptyRecordView.snp.bottom).offset(18)
      $0.leading.trailing.equalToSuperview().inset(79)
    }
    
    recordButton.snp.makeConstraints {
      $0.top.equalTo(emptyRecordText.snp.bottom).offset(31)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(116)
      $0.height.equalTo(42)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(48)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func bindViewModel() {
    viewModel.isEmpty.bind { [weak self] isEmpty in
      self?.emptyRecordView.isHidden = !isEmpty
      self?.emptyRecordText.isHidden = !isEmpty
      self?.recordButton.isHidden = !isEmpty
      self?.countLabel.isHidden = isEmpty
      self?.collectionView.isHidden = isEmpty
    }
    
    viewModel.records.bind { [weak self] records in
      self?.updateUI(with: records)
    }
  }
  
  private func updateUI(with records: [FeedModel]) {
    countLabel.text = "• \(records.count)개의 기록"
    collectionView.reloadData()
  }
}

extension MyRecordViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.records.value.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCollectionViewCell
    let record = viewModel.records.value[indexPath.item]
    cell.configure(with: record)
    return cell
  }
}

extension MyRecordViewController: UICollectionViewDelegate {
  // Handle cell selection, etc.
}
