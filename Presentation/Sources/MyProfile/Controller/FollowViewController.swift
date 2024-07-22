import UIKit
import SnapKit
import Then

import Core
import Common

enum FollowType {
  case follower
  case following
}

public class FollowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  let followType: FollowType
  private let viewModel: FollowViewModel
  private let tableView = UITableView()
  private let emptyView = FollowerEmptyView()
  let settingButton = UIButton()

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
    setTableView()
    bindViewModel()
    viewModel.fetchUsers()
  }
  
  private func setStyle() {
    view.backgroundColor = .black
  }
  
  private func setUI() {
    view.addSubview(emptyView)
    view.addSubview(tableView)
  }
  
  private func setAutoLayout() {
    emptyView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func setTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .black
    tableView.register(FollowerCell.self, forCellReuseIdentifier: "FollowerCell")
    tableView.separatorStyle = .none
  }
  
  public func bindViewModel() {
    viewModel.followers.bind { [weak self] _ in
      guard let self = self else { return }
      self.tableView.reloadData()
      self.tableView.isHidden = viewModel.followers.value.isEmpty
    }
  }
  
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
    cell.followButtonEvent = { [weak self] in
      guard let self = self else { return }
      postFollowRequest(index: indexPath.row)
      cell.updateFollowButton(isFollowed: follower.isFollowing)
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let userVC = OtherUserProfileViewController(id: viewModel.followers.value[indexPath.row].id)
    self.navigationController?.pushViewController(userVC, animated: true)
  }
  
  func postFollowRequest(index: Int) {
    self.viewModel.followers.value[index].isFollowing.toggle()
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.FollowRequest(followingId: viewModel.followers.value[index].id)
    apiProvider.justRequest(.follow(request)) { result in
      switch result {
      case .success(let success):
        print(success)
      case .failure(let failure):
        print(failure)
      }
    }
  }
}

public class FollowerCell: UITableViewCell {
  let profileImageView = UIImageView()
  let usernameLabel = UILabel()
  let followButton = MediumButton()
  
  var followButtonEvent: (() -> Void)?
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(profileImageView)
    contentView.addSubview(usernameLabel)
    contentView.addSubview(followButton)
    
    setStyle()
    setAutoLayout()
    followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    profileImageView.cornerRadius(10)
    usernameLabel.font = RecordyFont.body2Bold.font
    usernameLabel.textColor = CommonAsset.recordyGrey01.color
    contentView.backgroundColor = .black
  }
  
  private func setAutoLayout() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(10)
      $0.leading.equalTo(contentView.snp.leading).offset(20)
      $0.centerY.equalTo(contentView.snp.centerY)
      $0.width.equalTo(54)
      $0.height.equalTo(54)
    }
    
    usernameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
      $0.centerY.equalTo(contentView.snp.centerY)
    }
    
    followButton.snp.makeConstraints {
      $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
      $0.centerY.equalTo(contentView.snp.centerY)
      $0.width.equalTo(76.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }
  }
  
  @objc private func followButtonTapped() {
    self.followButtonEvent?()
  }
  
  public func updateFollowButton(isFollowed: Bool) {
    followButton.mediumState = isFollowed ? .active : .inactive
    followButton.setTitle(isFollowed ? "팔로우" : "팔로잉", for: .normal)
  }
  
  func configure(with follower: Follower) {
    let url = URL(string: follower.profileImage)
    profileImageView.kf.setImage(with: url)
    usernameLabel.text = follower.username
    if follower.username == "유영" {
      followButton.isHidden = true
    } else {
      updateFollowButton(isFollowed: follower.isFollowing)
    }
  }
}
