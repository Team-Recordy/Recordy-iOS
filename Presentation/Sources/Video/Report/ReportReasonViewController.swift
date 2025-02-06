//
//  ReportReasonViewController.swift
//  Presentation
//
//  Created by 한지석 on 10/31/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

import SnapKit
import Then

class ReportReasonViewController: UIViewController {
  
  private let reasonTextViewLayer = UIView()
  private let reasonTextView = UITextView()
  private let warningLabel = UILabel()
  private let countLabel = UILabel()
  private let rightBarButton = UIButton()
  private let id: Int

  weak var delegate: ReportWithCopyLinkDelegate?

  init(id: Int) {
    self.id = id
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    reasonTextView.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    delegate?.didTapReport()
    view.endEditing(true)
  }
  
  private func setStyle() {
    title = "기타"
    
    view.backgroundColor = CommonAsset.viskitGray10.color
    reasonTextView.delegate = self
    
    reasonTextViewLayer.do {
      $0.cornerRadius(8)
      $0.layer.borderColor = CommonAsset.viskitGray05.color.cgColor
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
      $0.setTitle("완료", for: .normal)
      $0.titleLabel?.font = RecordyFont.subtitle.font
      $0.setTitleColor(CommonAsset.viskitGray01.color, for: .normal)
      $0.setTitleColor(CommonAsset.viskitGray05.color, for: .disabled)
      $0.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
    }
    
    let barButton = UIBarButtonItem(customView: rightBarButton)
    navigationItem.rightBarButtonItem = barButton
    navigationItem.rightBarButtonItem?.isEnabled = false
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
  
  private func updateUIState() {
    let textLength = reasonTextView.text.count
    var state: Bool = false
    
    if textLength == 0 {
      state = false
    } else {
      state = true
    }
    
    updateBorderColor(state)
    updateButtonState(state)
    updateCountLabel()
  }
  
  private func updateBorderColor(_ state: Bool) {
    let color = state ? CommonAsset.viskitYellow40.color.cgColor : CommonAsset.viskitGray05.color.cgColor
    UIView.animate(withDuration: 0.2) {
      self.reasonTextViewLayer.layer.borderColor = color
    }
  }
  
  private func updateButtonState(_ isEnabled: Bool) {
    navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    rightBarButton.isEnabled = isEnabled
  }
  
  @objc private func rightBarButtonTapped() {
    postReport()
    dismiss(animated: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    reasonTextView.becomeFirstResponder()
  }

  private func postReport() {
    guard let text = reasonTextView.text else { return }
    let request = DTO.PostReport(
      recordId: id,
      reason: ReportCase.etc.reason,
      content: text
    )

    let apiProvider = APIProvider<APITarget.Report>()

    apiProvider.justRequest(.postReport(request)) { result in
      switch result {
      case .success:
        NotificationCenter.default.post(
          name: .reportDidComplete,
          object: nil,
          userInfo: [
            "message": "정상적으로 신고되었습니다.",
            "state": "success"
          ]
        )
      case .failure:
        NotificationCenter.default.post(
          name: .reportDidComplete,
          object: nil,
          userInfo: [
            "message": "신고에 실패했어요.",
            "state": "failure"
          ]
        )
      }
    }
  }
}

extension ReportReasonViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updateUIState()
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
  
  func updateCountLabel() {
    let count = reasonTextView.text.count
    countLabel.text = "\(count) / 30"
  }
}
