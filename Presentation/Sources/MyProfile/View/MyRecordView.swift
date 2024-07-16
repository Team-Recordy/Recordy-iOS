//
//  MyRecordView.swift
//  Presentation
//
//  Created by 송여경 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Common

class MyRecordView: UIView {
  private let videoEmptyView = UIView()
  private let videoDataView = UIView()
  
  let videoEmptyImageView = UIImageView()
  let videoEmptyTextView = UIImageView()
  let goActionButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
    checkDataEmpty()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    self.backgroundColor = .black
    videoEmptyImageView.do {
      $0.image = CommonAsset.mypageCamera.image
      $0.contentMode = .scaleAspectFit
    }
    
    videoEmptyTextView.do {
      $0.image = CommonAsset.myRecordText.image
    }
    
    goActionButton.do {
      $0.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
      $0.setImage(CommonAsset.gorecord.image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
    }
  }
  
  private func setUI() {
    self.addSubview(videoEmptyView)
    self.addSubview(videoDataView)
    
    videoEmptyView.addSubview(videoEmptyImageView)
    videoEmptyView.addSubview(videoEmptyTextView)
    videoEmptyView.addSubview(goActionButton)
  }
  
  private func setAutoLayout() {
    videoEmptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.leading.equalTo(138)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100.adaptiveHeight.adaptiveWidth)
    }
    
    videoEmptyTextView.snp.makeConstraints {
      $0.top.equalTo(videoEmptyImageView.snp.bottom).offset(18)
      $0.leading.equalToSuperview().offset(105)
    }
    
    goActionButton.snp.makeConstraints {
      $0.top.equalTo(videoEmptyTextView.snp.bottom).offset(31)
      $0.leading.equalToSuperview().offset(130)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(116.adaptiveWidth)
      $0.height.equalTo(42.adaptiveHeight)
    }
    
    videoDataView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  @objc private func didTapActionButton() {
    print("기록하기 버튼 눌림")
  }
  
  private func checkDataEmpty() {
    
  }
}
