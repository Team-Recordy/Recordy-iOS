//
//  ReportViewController.swift
//  Presentation
//
//  Created by 한지석 on 10/21/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

import SnapKit
import Then

class ReportViewController: UIViewController {
  
  private let tableView = UITableView()
  private let reportCase = ReportCase.allCases
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
    setAutolayout()
    setTableView()
  }

  private func setStyle() {
    self.title = "영상 신고"
  }
  
  private func setUI() {
    view.addSubview(tableView)
  }
  
  private func setAutolayout() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setTableView() {
    tableView.do {
      $0.rowHeight = 48.adaptiveHeight
      $0.dataSource = self
      $0.delegate = self
      $0.register(
        ReportCell.self,
        forCellReuseIdentifier: ReportCell.identifier
      )
    }
  }

  private func postReport(reportCase: ReportCase) {
    let request = DTO.PostReport(
      recordId: id,
      reason: reportCase.reason,
      content: ""
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

extension ReportViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let reportCase = self.reportCase[indexPath.row]
    if reportCase == .etc {
      let nextViewController = ReportReasonViewController(id: id)
      nextViewController.delegate = delegate
      delegate?.reason()
      navigationController?.pushViewController(
        nextViewController,
        animated: true
      )
    } else {
      postReport(reportCase: reportCase)
      dismiss(animated: true)
    }
  }
}

extension ReportViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reportCase.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: ReportCell.identifier,
      for: indexPath
    ) as! ReportCell
    cell.configure(reportCase[indexPath.row].title)
    return cell
  }
}
