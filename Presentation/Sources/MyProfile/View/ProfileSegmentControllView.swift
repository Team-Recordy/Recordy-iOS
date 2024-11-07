//
//  ProfileSegmentControllView.swift
//  Presentation
//
//  Created by 송여경 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
// setStyle() -> setUI() -> setAutoLayout()
import UIKit

import SnapKit
import Then

import Common

protocol ControlTypeDelegate: AnyObject {
  func sendControlType(_ type: ControlType)
}

public final class ProfileSegmentControllView: UIView {
  
  private var selectedTab: ControlType = .record {
    didSet {
      setStyle()
    }
  }
  weak var delegate: ControlTypeDelegate?
  private let barStack = UIStackView()
  private let recordButton = UIButton()
  private let bookmarkButton = UIButton()
  private let underDivider = UIView()
  
  private lazy var tapAction = UIAction { [weak self] action in
    guard let self, let sender = action.sender as? UIButton else { return }
    switch sender {
    case self.recordButton:
      self.selectedTab = .record
      delegate?.sendControlType(.record)
    case self.bookmarkButton:
      self.selectedTab = .bookmark
      delegate?.sendControlType(.bookmark)
    default:
      return
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setStyle()
    setAutoLayout()
    setTabViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    [recordButton, bookmarkButton].forEach { barStack.addArrangedSubview($0) }
    [barStack, underDivider].forEach { addSubview($0) }
  }
  
  private func setStyle() {
    barStack.do {
      $0.axis = .horizontal
      $0.spacing = 11.adaptiveWidth
      $0.distribution = .fillEqually
    }
    
    recordButton.do {
      $0.setTitle(ControlType.record.rawValue, for: .normal)
      applySelectUI(to: $0, type: .record)
    }
    
    bookmarkButton.do {
      $0.setTitle(ControlType.bookmark.rawValue, for: .normal)
      applySelectUI(to: $0, type: .bookmark)
    }
    
    underDivider.do {
      $0.backgroundColor = CommonAsset.recordyGrey01.color
    }
  }
  
  private func setAutoLayout() {
    barStack.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setTabViews() {
    recordButton.addAction(tapAction, for: .touchUpInside)
    bookmarkButton.addAction(tapAction, for: .touchUpInside)
  }
  
  private func applySelectUI(to button: UIButton, type: ControlType) {
    guard let text = button.titleLabel?.text else { return }
    
    let isSelected = type == self.selectedTab
    let attrString = NSMutableAttributedString(string: text)
    attrString.addAttributes(
      [
        .font: isSelected ? RecordyFont.body2Bold.font : RecordyFont.body2.font,
        .foregroundColor: isSelected ? CommonAsset.recordyGrey01.color : CommonAsset.recordyGrey04.color
      ],
      range: NSRange(location: 0, length: attrString.length)
    )
    button.setAttributedTitle(attrString, for: .normal)
    if isSelected {
      moveSelectedLine(below: button)
    }
  }
  
  private func moveSelectedLine(below button: UIButton) {
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
