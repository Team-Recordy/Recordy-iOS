//
//  ReportWithCopyLinkViewController.swift
//  Presentation
//
//  Created by 한지석 on 10/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

import SnapKit
import Then

class ReportWithCopyLinkViewController: UIViewController {

//  private lazy var copyLinkButton = UIButton()
  private lazy var reportButton = UIButton()
  private lazy var deleteButton = UIButton()
  weak var delegate: ReportWithCopyLinkDelegate?
  private let id: Int
  private let isMine: Bool

  init(
    id: Int,
    isMine: Bool
  ) {
    self.id = id
    self.isMine = isMine
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutolayout()
    updatePreferredContentSize()
  }

  override func viewWillAppear(_ animated: Bool) {
    delegate?.cancel()
  }

  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitGray10.color

//    copyLinkButton.do {
//      var config = UIButton.Configuration.plain()
//      config.image = CommonAsset.link.image
//      config.contentInsets = NSDirectionalEdgeInsets(
//        top: 12,
//        leading: 20,
//        bottom: 12,
//        trailing: 16
//      )
//      config.imagePlacement = .leading
//      config.imagePadding = 16
//      var container = AttributeContainer()
//      container.font = ViskitFont.body1.font
//      container.foregroundColor = CommonAsset.viskitWhite.color
//      config.attributedTitle = AttributedString(
//        "링크 복사하기",
//        attributes: container
//      )
//      $0.configuration = config
//      $0.contentHorizontalAlignment = .left
//      $0.addTarget(
//          self,
//          action: #selector(copyLinkButtonTapped),
//          for: .touchUpInside
//        )
//    }

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
      $0.isUserInteractionEnabled = true
      $0.configuration?.baseForegroundColor = CommonAsset.viskitAlert02.color
      $0.addTarget(
          self,
          action: #selector(reportButtonTapped),
          for: .touchUpInside
        )
    }

    deleteButton.do {
      var config = UIButton.Configuration.plain()
      config.image = CommonAsset.deleteButton.image
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
        "삭제하기",
        attributes: container
      )
      $0.configuration = config
      $0.contentHorizontalAlignment = .left
      $0.isUserInteractionEnabled = true
      $0.configuration?.baseForegroundColor = CommonAsset.viskitAlert02.color
      $0.addTarget(
          self,
          action: #selector(deleteButtonTapped),
          for: .touchUpInside
        )
    }

//    copyLinkButton.isHidden = isMine
    reportButton.isHidden = isMine
    deleteButton.isHidden = !isMine
  }

  private func setUI() {
    [
//      copyLinkButton,
      reportButton,
      deleteButton
    ].forEach { view.addSubview($0) }
  }

  private func setAutolayout() {
//    copyLinkButton.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(36.adaptiveHeight)
//      $0.horizontalEdges.equalToSuperview()
//      $0.height.equalTo(52.adaptiveHeight)
//    }
      
    reportButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(52.adaptiveHeight)
    }
      
    deleteButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(52.adaptiveHeight)
    }
  }

  private func updatePreferredContentSize() {
    let visibleButtons = [reportButton, deleteButton].filter { !$0.isHidden }
    let totalHeight = CGFloat(visibleButtons.count) * 52.adaptiveHeight + 36.adaptiveHeight
    preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: totalHeight)
  }

  @objc
  private func copyLinkButtonTapped() {
    delegate?.copy()
  }

  @objc
  private func reportButtonTapped() {
    delegate?.didTapReport()
    let nextViewController = ReportViewController(id: id)
    nextViewController.delegate = delegate
    navigationController?.pushViewController(
      nextViewController,
      animated: true
    )
  }

  private func deleteRecord() {
    let request = DTO.DeleteRecordRequest(recordId: id)
    let apiProvider = APIProvider<APITarget.Records>()
    apiProvider.justRequest(.deleteRecord(request)) { response in
      switch response {
      case .success(let success):
        print(success)
      case .failure(let failure):
        print(failure)
      }
    }
  }

  @objc
  private func deleteButtonTapped() {
    showPopUp(type: .delete) {
      self.deleteRecord()
      self.dismiss(animated: true) {
        self.dismiss(animated: true) {
          self.delegate?.delete(id: self.id)
        }
      }
    }
  }
}
