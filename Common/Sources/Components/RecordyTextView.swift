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

public class RecordyTextView: UIView {

  public let textView = UITextView().then {
    $0.font = RecordyFont.body2.font
    $0.textColor = CommonAsset.viskitGray01.color
    $0.backgroundColor = CommonAsset.viskitGray10.color
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
  public let textCountLabel = UILabel().then {
    $0.font = RecordyFont.caption2.font
    $0.textColor = CommonAsset.viskitGray05.color
  }

  private let textViewPlaceHolder = "공간에 대한 나의 생각을 자유롭게 적어주세요!"
  private let minHeight = 80.adaptiveHeight
  private let maxHeight = 272.adaptiveHeight

  public override init(frame: CGRect) {
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
    self.textView.text = textViewPlaceHolder
    self.textView.cornerRadius(8)
    self.textView.textColor = CommonAsset.recordyGrey05.color
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
  public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if textView.text == textViewPlaceHolder {
      return true
    }

    let currentText = textView.text ?? ""
    let newText = (currentText as NSString).replacingCharacters(in: range, with: text)

    return newText.count <= 300
  }

  public func textViewDidChange(_ textView: UITextView) {
    let currentSize = self.textView.sizeThatFits(
      CGSize(
        width: self.textView.frame.width,
        height: CGFloat.greatestFiniteMagnitude
      )
    )
    let newHeight = min(max(minHeight, currentSize.height), maxHeight)
    self.textView.isScrollEnabled = newHeight == maxHeight
  }

  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == textViewPlaceHolder {
      textView.text = nil
      textView.textColor = CommonAsset.viskitGray05.color
    }
    textView.textColor = CommonAsset.viskitGray01.color
    self.textCountLabel.textColor = CommonAsset.viskitGray01.color
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = textViewPlaceHolder
      textView.textColor = CommonAsset.viskitGray05.color
      self.textCountLabel.textColor = CommonAsset.viskitGray05.color
    } else {
      textView.textColor = CommonAsset.viskitGray01.color
      self.textCountLabel.textColor = CommonAsset.viskitGray01.color
    }
  }
}
