//
//  ProfileViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Core
import Common

enum ControlType: String {
  case taste = "내 취향"
  case record = "내 기록"
  case bookmark = "북마크"
}

public class ProfileViewController: UIViewController {
  
  let profileInfoView = ProfileInfoView()
  let segmentControlView = ProfileSegmentControllView()
  let tasteView = TasteView()
  let recordView = UIView()
  let bookmarkView = UIView()
  
  var controlType: ControlType = .taste {
    didSet {
      controlTypeChanged()
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
    setDelegate()
    controlTypeChanged()
  }
  
  func setStyle() {
    recordView.do {
      $0.backgroundColor = .green
    }
    bookmarkView.do {
      $0.backgroundColor = .blue
    }
  }
  
  func setUI() {
    self.view.addSubviews(
      profileInfoView,
      segmentControlView,
      tasteView,
      recordView,
      bookmarkView
    )
  }
  
  func setAutoLayout() {
    profileInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
      $0.width.equalTo(335.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }
    
    segmentControlView.snp.makeConstraints {
      $0.top.equalTo(profileInfoView.snp.bottom).offset(35.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
    }
    
    tasteView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    recordView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    bookmarkView.snp.makeConstraints {
      $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
  }
  
  func setDelegate() {
    segmentControlView.delegate = self
  }
  
  func controlTypeChanged() {
    tasteView.isHidden = controlType == .taste ? false : true
    recordView.isHidden = controlType == .record ? false : true
    bookmarkView.isHidden = controlType == .bookmark ? false : true
  }
}

extension ProfileViewController: ControlTypeDelegate {
  func sendControlType(_ type: ControlType) {
    self.controlType = type
  }
}
