//
//  RecordyToggle.swift
//  Common
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public enum ToggleState {
  case all
  case following
}

public class ViskitToggle: UIButton {

  var toggleState: ToggleState = .following {
    didSet {
      self.update()
    }
  }

  public var toggleAction: ((ToggleState) -> Void)?

  private let backgroundView = UIStackView()
  private let leftStateView = UIView()
  private let rightStateView = UIView()
  private let leftStateLabel = UILabel()
  private let rightStateLabel = UILabel()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutolayout()
    setState(state: .following)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    toggle()
    toggleAction?(toggleState)
  }

  private func setStyle() {
    backgroundView.do {
      $0.axis = .horizontal
      $0.layer.backgroundColor = (UIColor.black.cgColor).copy(alpha: 0.2)
      $0.isLayoutMarginsRelativeArrangement = true
      $0.cornerRadius(15)
      $0.isUserInteractionEnabled = false
    }

    leftStateView.do {
      $0.cornerRadius(15)
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.isUserInteractionEnabled = false
    }

    rightStateView.do {
      $0.cornerRadius(15)
      $0.isUserInteractionEnabled = false
    }

    leftStateLabel.do {
      $0.text = "전체"
      $0.textColor = .white
      $0.font = ViskitFont.body2.font
    }

    rightStateLabel.do {
      $0.text = "팔로잉"
      $0.textColor = .white
      $0.font = ViskitFont.body2.font
    }
  }

  private func setUI() {
    backgroundView.addArrangedSubview(leftStateView)
    backgroundView.addArrangedSubview(rightStateView)
    leftStateView.addSubview(leftStateLabel)
    rightStateView.addSubview(rightStateLabel)
    addSubview(backgroundView)
  }

  private func setAutolayout() {
    backgroundView.snp.makeConstraints {
      $0.top.equalTo(snp.top)
      $0.bottom.equalTo(snp.bottom)
      $0.leading.equalTo(snp.leading)
      $0.trailing.equalTo(snp.trailing)
    }
    leftStateView.snp.makeConstraints {
      $0.width.equalTo(snp.width).multipliedBy(0.5)
      $0.height.equalTo(snp.height)
    }
    rightStateView.snp.makeConstraints {
      $0.width.equalTo(snp.width).multipliedBy(0.5)
      $0.height.equalTo(snp.height)
    }
    leftStateLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    rightStateLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }

  func update() {
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let self else { return }
      if self.toggleState == .all {
        self.leftStateView.backgroundColor = CommonAsset.recordyGrey08.color
        self.rightStateView.backgroundColor = .clear
      } else {
        self.leftStateView.backgroundColor = .clear
        self.rightStateView.backgroundColor = CommonAsset.recordyGrey08.color
      }
    }
  }

  public func toggle() {
    toggleState == .all ? setState(state: .following) : setState(state: .all)
  }

  func setState(state: ToggleState) {
    toggleState = state
  }
}
