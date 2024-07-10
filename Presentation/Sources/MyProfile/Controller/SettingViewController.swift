//
//  SettingViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common

public class SettingViewController: UIViewController {
  
  var tableView: UITableView!
  
  let data = [
    [
      "커뮤니티 가이드라인",
      "서비스 이용약관",
      "개인정보 취급방침",
      "문의"
    ],
    [
      "로그인 연동",
      "로그아웃",
      "탈퇴하기"
    ]
  ]
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView = UITableView(frame: view.bounds, style: .grouped)
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    view.backgroundColor = .black
    tableView.backgroundColor = .black
    
    let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64))
    let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
    
    header.backgroundColor = .red
    footer.backgroundColor = CommonAsset.recordyGrey09.color
    
    let headerLabel = UILabel(frame: header.bounds)
    headerLabel.text = "도움말"
    headerLabel.textAlignment = .left
    headerLabel.font = RecordyFont.title3.font
    headerLabel.textColor = CommonAsset.recordyGrey01.color
    header.addSubview(headerLabel)
    
    tableView.tableHeaderView = header
    tableView.tableFooterView = footer
    
    view.addSubview(tableView)
  }
}

extension SettingViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension SettingViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 64.0
  }
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "도움말" : "기타"
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 8.0
  }
  
  public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return nil
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = data[indexPath.section][indexPath.row]
    cell.textLabel?.font = RecordyFont.body1.font
    cell.textLabel?.textColor = CommonAsset.recordyGrey01.color
    cell.backgroundColor = .black
    return cell
  }
}
