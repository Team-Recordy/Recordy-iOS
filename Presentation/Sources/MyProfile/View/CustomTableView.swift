import UIKit

import Then
import SnapKit

import Common

public class CustomTableView: UIView, UITableViewDelegate, UITableViewDataSource {
  
  var settingTableView = UITableView()
  var list: [String]
  var headerTitle: String
  var footerView: UIView?
  var cellArrowImages: [UIImage] = []
  
  init(
    list: [String],
    headerTitle: String,
    footerView: UIView? = nil,
    cellArrowImages: [UIImage] = []
  ) {
    self.list = list
    self.headerTitle = headerTitle
    self.footerView = footerView
    self.cellArrowImages = cellArrowImages
    super.init(
      frame: .zero
    )
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    settingTableView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      $0.backgroundColor = .black
      $0.isScrollEnabled = false
      $0.sectionHeaderTopPadding = 0
    }
  }
  
  private func setUI() {
    addSubview(settingTableView)
  }
  
  private func setAutoLayout() {
    settingTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 64
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    let headerLabel = UILabel()
    
    headerLabel.do {
      $0.textColor = CommonAsset.recordyGrey01.color
      $0.font = RecordyFont.title3.font
      $0.text = headerTitle
    }
    headerView.addSubview(headerLabel)
    headerLabel.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.top).inset(28)
      $0.leading.equalToSuperview().inset(18)
    }
    return headerView
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  public func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = settingTableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath
    )
    cell.textLabel?.text = list[indexPath.row]
    cell.textLabel?.font = RecordyFont.body1.font
    cell.textLabel?.textColor = CommonAsset.recordyGrey01.color
    cell.backgroundColor = .black
    cell.selectionStyle = .none
    
    if cellArrowImages.indices.contains(
      indexPath.row
    ) {
      let arrowImageView = UIImageView(
        image: cellArrowImages[indexPath.row]
      )
      cell.accessoryView = arrowImageView
    }
    
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if let footerView = footerView, 
        let heightConstraint = footerView.constraints.first(where: { $0.firstAttribute == .height })
    {
      return heightConstraint.constant
    }
    return footerView == nil ? 0 : 8
  }
  
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    return footerView
  }
}
