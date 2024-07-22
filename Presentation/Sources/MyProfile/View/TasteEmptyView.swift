//
//  TasteEmptyView.swift
//  Presentation
//
//  Created by 한지석 on 7/20/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core
import Common

import SnapKit
import Then

protocol TasteViewDelegate: AnyObject {
  func tasteViewUploadFeedTapped()
}

class TasteEmptyView: UIView {

  let emptyImageView = UIImageView()
  let emptyLabel = UIImageView()
  let recordButton = UIButton()
  let bottomMessage = UILabel()
  weak var delegate: TasteViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    emptyImageView.do {
      $0.image = CommonAsset.mypagebubble.image
      $0.contentMode = .scaleAspectFit
    }

    emptyLabel.do {
      $0.image = CommonAsset.mypageEmptyViewText.image
    }

    recordButton.do {
      $0.setImage(CommonAsset.gorecord.image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
    }

    bottomMessage.do {
      $0.text = "서로 다른 키워드 3개를 입력하면 그래프가 보여요"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey03.color
    }
  }

  private func setUI() {
    self.addSubviews(
      emptyImageView,
      emptyLabel,
      recordButton,
      bottomMessage
    )
  }
  
  private func setAutoLayout() {
    emptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(138)
      $0.width.height.equalTo(100)
    }

    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(18)
      $0.leading.equalTo(79)
    }

    recordButton.snp.makeConstraints {
      $0.top.equalTo(emptyLabel.snp.bottom).offset(31)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(116.adaptiveWidth)
      $0.height.equalTo(42.adaptiveHeight)
    }

    bottomMessage.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(24.adaptiveHeight)
      $0.height.equalTo(20.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }
  }

  @objc func uploadButtonTapped() {
    delegate?.tasteViewUploadFeedTapped()
  }
}
