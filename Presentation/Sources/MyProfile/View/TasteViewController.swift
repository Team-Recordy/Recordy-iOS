//
//  TasteViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit
import SnapKit
import Then

import Common
import Core

public class TasteViewController: UIViewController {
  
  private let viewModel = TasteViewModel()
  private let emptyView = UIView()
  private let dataView = UIView()
  
  let profileInfoView = ProfileInfoView()
  let segmentControlView = ProfileSegmentControllView()
  let emptyImageView = UIImageView()
  let emptyLabel = UIImageView()
  let actionButton = UIButton()
  let bottomMessage = UILabel()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
    bindViewModel()
    
    viewModel.fetchTasteData()
  }
  
  public func setUI() {
    view.backgroundColor = .black
    
    view.addSubview(profileInfoView)
    view.addSubview(segmentControlView)
    view.addSubview(emptyView)
    view.addSubview(dataView)
    
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
    
    emptyImageView.do {
      $0.image = CommonAsset.mypagebubble.image
      $0.contentMode = .scaleAspectFit
    }
    
    emptyLabel.do {
      $0.image = CommonAsset.mypageEmptyViewText.image
    }
    
    actionButton.do {
      $0.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
      $0.setImage(CommonAsset.gorecord.image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
    }
    
    bottomMessage.do {
      $0.text = "서로 다른 키워드 3개를 입력하면 그래프가 보여요"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
    
    emptyView.addSubview(emptyImageView)
    emptyView.addSubview(emptyLabel)
    emptyView.addSubview(actionButton)
    emptyView.addSubview(bottomMessage)
    
    emptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(138)
      $0.width.height.equalTo(100)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(18)
      $0.leading.trailing.equalToSuperview().inset(79)
    }
    
    actionButton.snp.makeConstraints {
      $0.top.equalTo(emptyLabel.snp.bottom).offset(31)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(116)
      $0.height.equalTo(42)
    }
    
    bottomMessage.snp.makeConstraints {
      $0.top.equalTo(actionButton.snp.bottom).offset(94)
      $0.centerX.equalToSuperview()
    }
    
    emptyView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(18)
      $0.leading.trailing.equalToSuperview()
    }
    
    dataView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    // 데이터를 표시하는 뷰 구성 요소 - 추후 추가 해주어야 함
  }
  
  public func bindViewModel() {
    viewModel.isEmpty.bind { [weak self] isEmpty in
      self?.emptyView.isHidden = !isEmpty
      self?.dataView.isHidden = isEmpty
    }
    
    viewModel.tasteData.bind { [weak self] _ in
      self?.updateDataView()
    }
  }
  
  @objc private func didTapActionButton() {
    print("기록하러 가기 버튼 눌렸을 때다.")
  }
  
  public func updateDataView() {
    dataView.subviews.forEach { $0.removeFromSuperview() }
    
    let dataViews = viewModel.tasteData.value.map { data -> TasteDataView in
      let view = TasteDataView()
      view.configure(with: data)
      return view
    }
    
    var previousView: UIView? = nil
    for dataView in dataViews {
      self.dataView.addSubview(dataView)
      dataView.snp.makeConstraints {
        if let previousView = previousView {
          $0.top.equalTo(previousView.snp.bottom).offset(20)
        } else {
          $0.top.equalToSuperview().offset(100)
        }
        $0.centerX.equalToSuperview()
        $0.width.equalTo(200)
        $0.height.equalTo(100)
      }
      previousView = dataView
    }
  }
}
