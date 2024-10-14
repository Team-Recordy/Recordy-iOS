import UIKit
import SnapKit
import Then

import Core
import Common

enum FollowType {
  case follower
  case following
  
  var title: String {
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
  private let tableView = UITableView().then {
    $0.backgroundColor = .black
    $0.separatorStyle = .none
  }
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
    view.do {
      $0.backgroundColor = .black
    }
    
    tableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.register(FollowerCell.self, forCellReuseIdentifier: "FollowerCell")
    }
    
    self.title = followType.title
  }
  
  private func setUI() {
    view.do {
      $0.addSubview(tableView)
      $0.addSubview(emptyView)
    }
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
    viewModel.followersDidChange = { [weak self] (followers: [Follow]) in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
    
    viewModel.isEmptyDidChange = { [weak self] isEmpty in
      guard let self = self else { return }
      self.tableView.isHidden = isEmpty
      self.emptyView.isHidden = !isEmpty
    }
  }
}

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.followers.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "FollowerCell",
      for: indexPath
    ) as! FollowerCell
    
    let follower = viewModel.followers[indexPath.row]
    cell.configure(with: follower)
    
    cell.followButton.do {
      if indexPath.row == 0 && followType == .following {
        $0.isHidden = true
      } else {
        $0.isHidden = false
        cell.updateFollowButton(isFollowed: follower.isFollowing)
      }
    }
    
    cell.followButtonEvent = { [weak self] in
      guard let self = self else { return }
      self.viewModel.postFollowRequest(at: indexPath.row)
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let follow = viewModel.followers[indexPath.row]
    let userId = Int(follow.userId) ?? 0
    let userVC = OtherUserProfileViewController(id: userId)
    self.navigationController?.pushViewController(userVC, animated: true)
  }
}
