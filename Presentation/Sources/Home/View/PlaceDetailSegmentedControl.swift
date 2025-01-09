//
//  PlaceDetailSegmentedControl.swift
//  Presentation
//
//  Created by Chandrala on 10/28/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Common

public protocol PlaceDetailControlTypeDelegate: AnyObject {
  func sendControlType(_ type: PlaceDetailControlType)
}

public final class PlaceDetailSegmentedControl: UIView {
  private var selectedTab: PlaceDetailControlType = .exhibitionList {
    didSet {
      setStyle()
    }
  }
  
  weak public var delegate: PlaceDetailControlTypeDelegate?
  
  private let barStack = UIStackView()
  private let firstButton = UIButton()
  private let secondButton = UIButton()
  private let underDivider = UIView()
  
  private lazy var tapAction = UIAction { [weak self] action in
    guard let self, let sender = action.sender as? UIButton else { return }
    switch sender {
    case self.firstButton:
      self.selectedTab = .exhibitionList
      self.delegate?.sendControlType(.exhibitionList)
    case self.secondButton:
      self.selectedTab = .reviewFeed
      self.delegate?.sendControlType(.reviewFeed)
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
    [firstButton, secondButton].forEach {
      barStack.addArrangedSubview($0)
    }
    
    [barStack, underDivider].forEach {
      addSubview($0)
    }
  }
  
  private func setStyle() {
    barStack.do {
      $0.axis = .horizontal
      $0.spacing = 0
      $0.distribution = .fillEqually
    }
    
    firstButton.do {
      $0.setTitle(PlaceDetailControlType.exhibitionList.rawValue, for: .normal)
      applySelectUI(to: $0, type: .exhibitionList)
    }
    
    secondButton.do {
      $0.setTitle(PlaceDetailControlType.reviewFeed.rawValue, for: .normal)
      applySelectUI(to: $0, type: .reviewFeed)
    }
    
    underDivider.do {
      $0.backgroundColor = CommonAsset.viskitGray01.color
    }
  }
  
  private func setAutoLayout() {
    barStack.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.verticalEdges.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setTabViews() {
    firstButton.addAction(tapAction, for: .touchUpInside)
    secondButton.addAction(tapAction, for: .touchUpInside)
  }
  
  private func applySelectUI(to button: UIButton, type: PlaceDetailControlType) {
    guard let text = button.titleLabel?.text else { return }
    
    let isSelected = type == self.selectedTab
    let attrString = NSMutableAttributedString(string: text)
    attrString.addAttributes(
      [
        .font: isSelected ? ViskitFont.body2Bold.font : ViskitFont.body2.font,
        .foregroundColor: isSelected ? CommonAsset.viskitGray01.color : CommonAsset.viskitGray05.color
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
