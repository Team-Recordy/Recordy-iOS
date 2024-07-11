//
//  RecordyTextView.swift
//  Common
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

class RecordyTextView: UIView {

  let textView = UITextView().then {
    $0.font = RecordyFont.body2.font
    $0.textColor = CommonAsset.recordyGrey01.color
    $0.backgroundColor = CommonAsset.recordyGrey08.color
    $0.isScrollEnabled = false
    let horizontalPadding = 14.adaptiveWidth
    let verticalPadding = 14.adaptiveHeight
    $0.textContainerInset = UIEdgeInsets(
      top: verticalPadding,
      left: horizontalPadding,
      bottom: verticalPadding,
      right: horizontalPadding
    )
  }
  let textCountLabel = UILabel().then {
    $0.font = RecordyFont.caption2.font
    $0.textColor = CommonAsset.recordyGrey04.color
  }

  private let minHeight = 148.adaptiveHeight
  private let maxHeight = 408.adaptiveHeight

  override init(frame: CGRect) {
    super.init(frame: frame)
    textView.delegate = self
    setStyle()
    setUI()
    setAutolayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    self.textView.cornerRadius(8)
  }

  private func setUI() {
    self.addSubviews(textView, textCountLabel)
  }

  private func setAutolayout() {
    self.textView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.greaterThanOrEqualTo(minHeight)
      $0.height.lessThanOrEqualTo(maxHeight)
    }
    self.textCountLabel.snp.makeConstraints {
      $0.top.equalTo(self.textView.snp.bottom).offset(8)
      $0.trailing.bottom.equalToSuperview()
    }
  }
}

extension RecordyTextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let currentSize = self.textView.sizeThatFits(
      CGSize(
        width: self.textView.frame.width,
        height: CGFloat.greatestFiniteMagnitude
      )
    )
    let newHeight = min(max(minHeight, currentSize.height), maxHeight)
    self.textView.isScrollEnabled = newHeight == maxHeight
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    self.textView.layer.borderColor = CommonAsset.recordyMain.color.cgColor
    self.textView.layer.borderWidth = 1
    self.textCountLabel.textColor = CommonAsset.recordyMain.color
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    self.textView.layer.borderColor = UIColor.clear.cgColor
    self.textView.layer.borderWidth = 0
    self.textCountLabel.textColor = CommonAsset.recordyGrey04.color
  }
}