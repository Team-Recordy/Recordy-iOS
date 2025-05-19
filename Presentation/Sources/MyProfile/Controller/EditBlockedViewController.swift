//
//  EditBlockedViewController.swift
//  Presentation
//
//  Created by Rama on 5/18/25.
//  Copyright © 2025 com. All rights reserved.
//

import UIKit

import Core
import Common

public class EditBlockedViewController: UIViewController {
  private var blockedUsers: [UserInfoForBlock] = []
  private let tableView = UITableView().then {
    $0.backgroundColor = CommonAsset.viskitBG.color
    $0.separatorStyle = .none
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
    
    self.blockedUsers = BlockedUserManager.getBlockedUsers()
  }
  
  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitBG.color
    self.title = "차단된 계정"
    
    tableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.register(
        BlockedUserCell.self,
        forCellReuseIdentifier: "BlockedUserCell"
      )
    }
  }
  
  private func setUI() {
    view.addSubviews(tableView)
  }
  
  private func setAutoLayout() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

@available(iOS 16.0, *)
extension EditBlockedViewController: UITableViewDataSource, UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return blockedUsers.count
  }
  
  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "BlockedUserCell",
      for: indexPath
    ) as! BlockedUserCell
    
    let user = blockedUsers[indexPath.row]
    cell.configure(with: user)
    cell.unblockButtonEvent = { [weak self] id, nickname in
      self?.showPopUp(
        type: .unblock(user: nickname),
        rightButtonAction: { [weak self] in
          self?.unblockButtonRightAction(id: id)
        }
      )
    }
    return cell
  }
  
  private func unblockButtonRightAction(id: Int) {
    BlockedUserManager.removeBlockedUser(withId: id)
    self.blockedUsers = BlockedUserManager.getBlockedUsers()
    self.tableView.reloadData()
    self.dismiss(animated: true)
  }
}
