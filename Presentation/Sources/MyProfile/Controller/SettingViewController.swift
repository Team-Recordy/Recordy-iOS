//
//  SettingViewController.swift
//  Presentation
//
//  Created by 송여경 on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Common
import Then

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
    
    tableView = UITableView(frame: view.bounds, style: .grouped).then {
      $0.delegate = self
      $0.dataSource = self
      $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      $0.backgroundColor = .black
    }
    
    view.backgroundColor = .black
    view.addSubview(tableView)
    
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 18)).then {
      let versionLabel = UILabel(frame: CGRect(x: 20, y: 0, width: $0.frame.width - 20, height: $0.frame.height)).then {
        $0.text = "앱 버전 1.1.1"
        $0.font = RecordyFont.caption2.font
        $0.textColor = CommonAsset.recordyGrey04.color
        $0.textAlignment = .left
      }
      $0.addSubview(versionLabel)
    }
    tableView.do {
      $0.tableFooterView = footerView
    }

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
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 64)).then {
      $0.backgroundColor = .black
      let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: $0.frame.width - 32, height: 64)).then {
        $0.font = RecordyFont.title3.font
        $0.textColor = CommonAsset.recordyGrey01.color
        $0.textAlignment = .left
        $0.text = section == 0 ? "도움말" : "기타"
      }
      $0.addSubview(headerLabel)
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == 0 ? 8.0 : 0.0
  }
  
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard section == 0 else { return nil }
    return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8)).then {
      $0.backgroundColor = CommonAsset.recordyGrey09.color
    }
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath).then {
      $0.textLabel?.text = data[indexPath.section][indexPath.row]
      $0.textLabel?.font = RecordyFont.body1.font
      $0.textLabel?.textColor = CommonAsset.recordyGrey01.color
      $0.backgroundColor = .black
      $0.selectionStyle = .none 
      
      let arrowImageView = UIImageView(image: CommonAsset.indicator.image)
      $0.accessoryView = arrowImageView
    }
    return cell
  }
}
