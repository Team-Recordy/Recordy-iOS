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

enum ToggleState {
  case all
  case following
}

public class RecordyToggle: UIButton {

  var toggleState: ToggleState = .all {
    didSet {
      self.update()
    }
  }
  private let backgroundView = UIStackView().then {
    $0.axis = .horizontal
    $0.layer.backgroundColor = (UIColor.black.cgColor).copy(alpha: 0.2)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.cornerRadius(15)
  }
  private let leftStateView = UIView()
  private let rightStateView = UIView()
  private let leftStateLabel = UILabel().then {
    $0.text = "전체"
    $0.textColor = .white
    $0.font = RecordyFont.body2Long.font
  }
  private let rightStateLabel = UILabel().then {
    $0.text = "팔로잉"
    $0.textColor = .white
    $0.font = RecordyFont.body2Long.font
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutolayout()
    setState(state: .all)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.toggle()
  }

  private func setStyle() {
    backgroundView.layer.backgroundColor = (UIColor.black.cgColor).copy(alpha: 0.2)
    self.backgroundView.cornerRadius(15)
    self.leftStateView.cornerRadius(15)
    self.rightStateView.cornerRadius(15)
    self.leftStateView.backgroundColor = CommonAsset.recordyGrey08.color
  }

  private func setUI() {
    self.backgroundView.addArrangedSubview(leftStateView)
    self.backgroundView.addArrangedSubview(rightStateView)
    self.leftStateView.addSubview(leftStateLabel)
    self.rightStateView.addSubview(rightStateLabel)
    self.addSubview(backgroundView)
  }

  private func setAutolayout() {
    self.backgroundView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.bottom.equalTo(self.snp.bottom)
      $0.leading.equalTo(self.snp.leading)
      $0.trailing.equalTo(self.snp.trailing)
    }
    self.leftStateView.snp.makeConstraints {
        $0.width.equalTo(self.snp.width).multipliedBy(0.5)
        $0.height.equalTo(self.snp.height)
    }
    self.rightStateView.snp.makeConstraints {
        $0.width.equalTo(self.snp.width).multipliedBy(0.5)
        $0.height.equalTo(self.snp.height)
    }
    self.leftStateLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    self.rightStateLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }

  func update() {
    UIView.animate(withDuration: 0.3) {
      if self.toggleState == .all {
        self.leftStateView.backgroundColor = .clear
        self.rightStateView.backgroundColor = CommonAsset.recordyGrey08.color
      } else {
        self.leftStateView.backgroundColor = CommonAsset.recordyGrey08.color
        self.rightStateView.backgroundColor = .clear
      }
    }
  }

  public func toggle() {
    self.toggleState == .all ? setState(state: .following) : setState(state: .all)
  }

  func setState(state: ToggleState) {
    self.toggleState = state
  }
}
