import UIKit
import SnapKit
import Then

import Core
import Common

public class FollowerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let viewModel = FollowerViewModel()
  private let tableView = UITableView()
  private let emptyView = UIView()
  let emptyLabel = UIImageView()
  let emptyImage = UIImageView()
  let settingButton = UIButton()
  
  var follower: [MainRecord] = []
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setStyle()
    setAutoLayout()
    setTableView()
    bindViewModel()
    
    viewModel.fetchFollowers()
  }
  
  private func setStyle() {
    view.backgroundColor = .black
    emptyView.backgroundColor = .black
    
    emptyImage.image = CommonAsset.noFollowers.image
    emptyLabel.image = CommonAsset.text.image
  }
  
  private func setUI() {
    emptyView.addSubview(emptyImage)
    emptyView.addSubview(emptyLabel)
    view.addSubview(emptyView)
    view.addSubview(tableView)
  }
  
  private func setAutoLayout() {
    emptyView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(200.adaptiveWidth)
      $0.height.equalTo(200.adaptiveHeight)
    }
    
    emptyImage.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20.adaptiveHeight)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(100.adaptiveWidth)
      $0.height.equalTo(100.adaptiveHeight)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(18)
      $0.centerX.equalToSuperview()
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
  }
  
  public func bindViewModel() {
    viewModel.followers.bind { [weak self] _ in
      self?.tableView.reloadData()
    }
    
    viewModel.isEmpty.bind { [weak self] isEmpty in
      self?.emptyView.isHidden = !isEmpty
      self?.tableView.isHidden = isEmpty
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.followersMockData.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerCell", for: indexPath) as! FollowerCell
    var follower = viewModel.followersMockData.value[indexPath.row]
    cell.configure(with: follower)
    cell.followButtonEvent = { [weak self] in
      guard let self = self else { return }
      postFollowRequest(index: indexPath.row)
      cell.updateFollowButton(isFollowed: follower.isFollowing)
      print("Follow Button Touched: \(follower.isFollowing)")
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let otherProfileView = OtherUserProfileViewController()
    if let navigationController = self.navigationController {
      navigationController.pushViewController(otherProfileView, animated: true)
    } else {
      print("Error: No navigation controller found")
    }
  }
  
  func postFollowRequest(index: Int) {
    self.viewModel.followersMockData.value[index].isFollowing.toggle()
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.FollowRequest(followingId: viewModel.followersMockData.value[index].id)
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
    followButton.setTitle(isFollowed ? "팔로잉" : "팔로우", for: .normal)
  }
  
  func configure(with follower: Follower) {
    profileImageView.image = follower.profileImage
    usernameLabel.text = follower.username
    updateFollowButton(isFollowed: follower.isFollowing)
  }
}
