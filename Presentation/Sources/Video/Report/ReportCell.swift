//
//  ReportCell.swift
//  Presentation
//
//  Created by 한지석 on 10/21/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

import SnapKit
import Then

class ReportCell: UITableViewCell {

  static let identifier = "ReportCell"
  private let titleLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setStyle()
    setUI()
    setAutolayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  private func setStyle() {
    titleLabel.do {
      $0.font = ViskitFont.body1.font
      $0.textColor = CommonAsset.viskitGray01.color
    }
  }

  private func setUI() {
    addSubview(titleLabel)
  }

  private func setAutolayout() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }

  func configure(_ title: String) {
    titleLabel.text = title
  }
}
