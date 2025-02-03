//
//  ReportReasonViewController.swift
//  Presentation
//
//  Created by 한지석 on 10/31/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

import SnapKit
import Then

class ReportReasonViewController: UIViewController {

  private let reasonTextViewLayer = UIView()
  private let reasonTextView = UITextView()
  private let warningLabel = UILabel()
  private let countLabel = UILabel()
  private let rightBarButton = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    reasonTextView.becomeFirstResponder()
  }

  override func viewDidDisappear(_ animated: Bool) {
    hideKeyboard()
  }

  private func setStyle() {
    title = "기타"

    view.backgroundColor = CommonAsset.viskitGray10.color

    reasonTextViewLayer.do {
      $0.cornerRadius(8)
      $0.layer.borderColor = CommonAsset.viskitYellow40.color.cgColor
      $0.layer.borderWidth = 1
      $0.backgroundColor = .clear
    }

    reasonTextView.do {
      $0.font = ViskitFont.body2Long.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.backgroundColor = .clear
      $0.cornerRadius(8)


      $0.textContainer.maximumNumberOfLines = 0
      let padding = $0.textContainer.lineFragmentPadding
      $0.contentInset = UIEdgeInsets(
        top: -padding,
        left: -padding,
        bottom: 0,
        right: 0
      )

      $0.delegate = self
    }

    warningLabel.do {
      $0.font = ViskitFont.caption2Regular.font
      $0.textColor = CommonAsset.viskitGray03.color
      $0.text = "허위 신고일 경우, 신고가 취소될 수 있습니다."
    }

    countLabel.do {
      $0.font = ViskitFont.caption2Medium.font
      $0.textColor = CommonAsset.viskitGray02.color
      $0.text = "0 / 30"
    }

    rightBarButton.do {
      var config = UIButton.Configuration.plain()
      var container = AttributeContainer()
      container.font = RecordyFont.subtitle.font
      container.foregroundColor = CommonAsset.viskitGray01.color
      config.attributedTitle = AttributedString(
        "완료",
        attributes: container
      )
      $0.configuration = config
    }

    let barButton = UIBarButtonItem(customView: rightBarButton)
    navigationItem.rightBarButtonItem = barButton
  }

  private func setUI() {
    [
      reasonTextViewLayer,
      warningLabel,
      countLabel
    ].forEach { view.addSubview($0) }

    reasonTextViewLayer.addSubview(reasonTextView)
  }

  private func setAutoLayout() {
    reasonTextViewLayer.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(78.adaptiveHeight)
    }

    reasonTextView.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(14.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
    }

    warningLabel.snp.makeConstraints {
      $0.top.equalTo(reasonTextViewLayer.snp.bottom).offset(8.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
    }

    countLabel.snp.makeConstraints {
      $0.top.equalTo(reasonTextViewLayer.snp.bottom).offset(8.adaptiveHeight)
      $0.trailing.equalToSuperview().offset(-20.adaptiveWidth)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    reasonTextView.becomeFirstResponder()
  }
}

extension ReportReasonViewController: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    reasonTextView.becomeFirstResponder()
  }

  func textViewDidChange(_ textView: UITextView) {
    updateCountLabel()
  }

  func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    let currentText = textView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    return updatedText.count <= 30
  }

  func updateButtonState(_ isEnabled: Bool) {
    rightBarButton.isEnabled = isEnabled
    rightBarButton.setTitleColor(
      isEnabled ? CommonAsset.viskitGray01.color : CommonAsset.viskitGray03.color,
      for: .normal
    )
  }

  func updateCountLabel() {
    let count = reasonTextView.text.count
    countLabel.text = "\(count) / 30"

    updateButtonState(!reasonTextView.text.isEmpty)
  }
}
