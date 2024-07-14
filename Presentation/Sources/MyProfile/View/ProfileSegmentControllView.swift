//
//  ProfileSegmentControllView.swift
//  Presentation
//
//  Created by 송여경 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common


enum ControlType: String {
  case taste = "내 취향"
  case record = "내 기록"
  case bookmark = "북마크"
}

public final class ProfileSegmentControllView: UIView {
  
  private var selectedTab: ControlType = .taste {
    didSet {
      setupStyle()
    }
  }
  
  private let barStack = UIStackView()
  private let tasteButton = UIButton()
  private let recordButton = UIButton()
  private let bookmarkButton = UIButton()
  private let underDivider = Divider(color: CommonAsset.recordyGrey01.color)
  
  private var didTap: ((_ controlType: ControlType) -> Void)?
  
  private lazy var tapAction = UIAction { [weak self] action in
    guard let self, let sender = action.sender as? UIButton else {return}
    switch sender {
    case self.tasteButton:
      self.selectedTab = .taste
      self.didTap?(.taste)
    case self.recordButton:
      self.selectedTab = .record
      self.didTap?(.record)
    case self.bookmarkButton:
      self.selectedTab = .bookmark
      self.didTap?(.bookmark)
    default:
      return
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUpViews()
    setUpLayout()
    setupStyle()
    setUpConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpViews() {
    tasteButton.addAction(tapAction, for: .touchUpInside)
    recordButton.addAction(tapAction, for: .touchUpInside)
    bookmarkButton.addAction(tapAction, for: .touchUpInside)
  }
  
  private func setUpLayout() {
    [
      tasteButton,
      recordButton,
      bookmarkButton
    ].forEach { barStack.addArrangedSubview($0)}
    
    [
      barStack,
      underDivider
    ].forEach{ self.addSubview($0) }
  }
  
  private func setupStyle() {
    barStack.do {
      $0.axis = .horizontal
      $0.spacing = 50
      $0.distribution = .equalSpacing
    }
    
    tasteButton.do {
      $0.titleLabel?.text = ControlType.taste.rawValue
      applySelectUI(to: $0, type: .taste)
    }
    
    recordButton.do {
      $0.titleLabel?.text = ControlType.record.rawValue
      applySelectUI(to: $0, type: .record)
    }
    
    bookmarkButton.do {
      $0.titleLabel?.text = ControlType.bookmark.rawValue
      applySelectUI(to: $0, type: .bookmark)
    }
  }
  
  private func setUpConstraint() {
    barStack.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.verticalEdges.equalToSuperview()
    }
  }
}


private extension ProfileSegmentControllView {
  func applySelectUI(
    to button: UIButton,
    type: ControlType
  ) {
    guard let text = button.titleLabel?.text else { return }
    
    let isSelected = type == self.selectedTab
    let attrString = NSMutableAttributedString(string: text)
    attrString.addAttributes(
      [
        .font: isSelected ? RecordyFont.body2Bold.font : RecordyFont.body2.font,
        .foregroundColor: isSelected ? CommonAsset.recordyGrey01.color : CommonAsset.recordyGrey04.color
      ],
      range: NSRange(
        location: 0,
        length: attrString.length
      )
      )
    button.setAttributedTitle(
      attrString,
      for: .normal
    )
    if isSelected {
      moveSelectedLine(
        below: button
      )
    }
  }
  
  func moveSelectedLine(below button: UIButton) {
    
    UIView.animate(withDuration: 0.2) {
      self.underDivider.snp.remakeConstraints {
        $0.horizontalEdges.equalTo(button)
        $0.bottom.equalToSuperview()
        $0.height.equalTo(2)
      }
      self.layoutIfNeeded()
    }
  }
}
