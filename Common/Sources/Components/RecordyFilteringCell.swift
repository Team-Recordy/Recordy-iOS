//
//  RecordyFilteringCell.swift
//  Common
//
//  Created by 한지석 on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core

import SnapKit
import Then

class RecordyFilteringCell: UICollectionViewCell {
  let chipButton = ChipKeyWordButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutoLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUI() {
    self.addSubview(chipButton)
  }

  private func setAutoLayout() {
    chipButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func bind(keyword: Keyword, isSelected: Bool) {
    self.chipButton.setTitle(keyword.title, for: .normal)
    self.chipButton.setState(state: isSelected ? .active : .inactive)
  }

}
