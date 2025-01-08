//
//  ReportViewController.swift
//  Presentation
//
//  Created by 한지석 on 10/21/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

import SnapKit
import Then

class ReportViewController: UIViewController {
  
  private let tableView = UITableView()
  private let reportCase = ReportCase.allCases
  
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
}

extension ReportViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let reportCase = self.reportCase[indexPath.row]
    if reportCase == .etc {
      let nextViewController = ReportReasonViewController()
      navigationController?.pushViewController(
        nextViewController,
        animated: true
      )
    } else {
      /// API Call
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
