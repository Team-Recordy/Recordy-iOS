//
//  ReportWithCopyLinkViewController.swift
//  Presentation
//
//  Created by 한지석 on 10/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

import SnapKit
import Then

class ReportWithCopyLinkViewController: UIViewController {

  private lazy var copyLinkButton = UIButton()
  private lazy var reportButton = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutolayout()
  }

  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitGray10.color

    copyLinkButton.do {
      var config = UIButton.Configuration.plain()
      config.image = CommonAsset.link.image
      config.contentInsets = NSDirectionalEdgeInsets(
        top: 12,
        leading: 20,
        bottom: 12,
        trailing: 16
      )
      config.imagePlacement = .leading
      config.imagePadding = 16
      var container = AttributeContainer()
      container.font = ViskitFont.body1.font
      container.foregroundColor = CommonAsset.viskitWhite.color
      config.attributedTitle = AttributedString(
        "링크 복사하기",
        attributes: container
      )
      $0.configuration = config
      $0.contentHorizontalAlignment = .left
      $0.addTarget(
          self,
          action: #selector(copyLinkButtonTapped),
          for: .touchUpInside
        )
    }

    reportButton.do {
      var config = UIButton.Configuration.plain()
      config.image = CommonAsset.report.image
      config.contentInsets = NSDirectionalEdgeInsets(
        top: 12,
        leading: 20,
        bottom: 12,
        trailing: 16
      )
      config.imagePlacement = .leading
      config.imagePadding = 16
      var container = AttributeContainer()
      container.font = ViskitFont.body1.font
      container.foregroundColor = CommonAsset.viskitAlert02.color
      config.attributedTitle = AttributedString(
        "신고하기",
        attributes: container
      )
      $0.configuration = config
      $0.contentHorizontalAlignment = .left
      $0.addTarget(
          self,
          action: #selector(copyLinkButtonTapped),
          for: .touchUpInside
        )
    }
  }

  private func setUI() {
    [
      copyLinkButton,
      reportButton
    ].forEach { view.addSubview($0) }
  }

  private func setAutolayout() {
    copyLinkButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(36.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(52.adaptiveHeight)
    }
    reportButton.snp.makeConstraints {
      $0.top.equalTo(copyLinkButton.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(52.adaptiveHeight)
    }
  }

  @objc
  private func copyLinkButtonTapped() {

  }

  @objc
  private func reportButtonTapped() {

  }
}


