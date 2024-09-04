import UIKit
import SnapKit
import Then

import Core
import Common

enum FollowType {
  case follower
  case following
  
  var title: String{
    switch self {
    case .follower:
      return "팔로워"
    case .following:
      return "팔로우"
    }
  }
}

public class FollowViewController: UIViewController {
  
  private let followType: FollowType
  private let viewModel: FollowViewModel
  private let tableView = UITableView()
  private let emptyView = FollowerEmptyView()
  
  init(followType: FollowType) {
    self.followType = followType
    self.viewModel = FollowViewModel(followType: followType)
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
    bind()
    
    self.navigationController?.navigationBar.topItem?.title = ""
  }
  
  private func setStyle() {
    view.backgroundColor = .black
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .black
    tableView.register(FollowerCell.self, forCellReuseIdentifier: "FollowerCell")
    tableView.separatorStyle = .none
    
    self.title = followType.title
  }
  
  private func setUI() {
    view.addSubview(tableView)
    view.addSubview(emptyView)
  }
  
  private func setAutoLayout() {
    emptyView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  
  private func bind() {
    viewModel.followers.bind { [weak self] _ in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
    
    viewModel.isEmpty.bind { [weak self] isEmpty in
      guard let self = self else { return }
      self.tableView.isHidden = isEmpty
      self.emptyView.isHidden = !isEmpty
    }
  }
}

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.followers.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "FollowerCell",
      for: indexPath
    ) as! FollowerCell
    
    let follower = viewModel.followers.value[indexPath.row]
    cell.configure(with: follower)
    
    if indexPath.row == 0 && followType == .following {
      cell.followButton.isHidden = true
    } else {
      cell.followButton.isHidden = false
      cell.updateFollowButton(isFollowed: follower.isFollowing)
    }
    
    cell.followButtonEvent = { [weak self] in
      guard let self = self else { return }
      self.viewModel.postFollowRequest(at: indexPath.row)
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let userVC = OtherUserProfileViewController(id: viewModel.followers.value[indexPath.row].id)
    self.navigationController?.pushViewController(userVC, animated: true)
  }
}
