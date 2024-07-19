import UIKit

import Then
import SnapKit
import Lottie

import Core
import Common

protocol HomeCollectionViewDelegate: AnyObject {
  func popularCollectionView(indexPath: IndexPath)
  func recentCollectionView(indexPath: IndexPath)
  func keywordCollectionView(indexPath: IndexPath)
}

enum RecordType {
  case famous
  case recent
}

@available(iOS 16.0, *)
public final class HomeViewController: UIViewController {

  var selectedKeywords: [Keyword] = [.all]
  var famousRecords: [MainRecord] = []
  var recentRecords: [MainRecord] = []
  struct EmptyResponse: Codable { }

  let keywords = Keyword.allCases

  private let navigationImage = UIImageView()
  private var lottieView = LottieAnimationView()
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let gradientView = RecordyGradientView()
  private let homeTitle = UILabel()
  private let homeImage = UIImageView()
  private let popularLabel = UILabel()
  private let recentLabel = UILabel()

  private let floatingButton = UIButton()
  private let floatingButtonImage = UIImageView()
  private let floatingButtonText = UILabel()

  private var keywordCollectionView: UICollectionView!
  private var popularCollectionView: UICollectionView!
  private var recentCollectionView: UICollectionView!

  weak var popularDelegate: HomeCollectionViewDelegate?
  weak var recentDelegate: HomeCollectionViewDelegate?

  var keywordCollectionViewTopAnchor: Constraint!
  var popularLabelTopAnchor: Constraint!

  var keywordIsSticky = false

  public override func viewDidLoad() {
    super.viewDidLoad()
    setKeywordCollectionView()
    setPopularCollectionView()
    setRecentCollectionView()
    scrollView.delegate = self
    setLottie()
    setStyle()
    setUI()
    setAutoLayout()
    getFamousRecordList(selectedKeyword: .all)
    getRecentRecordList(selectedKeyword: .all)
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.navigationController?.navigationBar.isHidden = true
    setObserver()
  }

  public override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: .updateDidComplete, object: nil)
  }

  func setObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleUploadCompletion),
      name: .updateDidComplete,
      object: nil
    )
  }

  @objc private func handleUploadCompletion(_ notification: Notification) {
    guard let state = notification.userInfo?["state"] as? String,
          let message = notification.userInfo?["message"] as? String else {
      return
    }
    if state == "success" {
      showToast(status: .complete, message: message, height: 44)
      if let keyword = selectedKeywords.first {
        getFamousRecordList(selectedKeyword: keyword)
        getRecentRecordList(selectedKeyword: keyword)
      }
    } else {
      showToast(status: .warning, message: message, height: 44)
    }
  }

  func setLottie() {
    let coreBundle = Bundle(identifier: "com.recordy.Common")

    if let filepath = coreBundle?.path(forResource: "bubble", ofType: "json") {
      let animation = LottieAnimation.filepath(filepath)
      self.lottieView = LottieAnimationView(animation: animation)
    } else {
      print("Lottie animation file not found.")
    }
  }

  func setStyle() {
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = CommonAsset.recordyBG.color
    self.keywordCollectionView.backgroundColor = .clear
    self.popularCollectionView.backgroundColor = .clear
    self.recentCollectionView.backgroundColor = .clear

    navigationImage.do {
      $0.image = CommonAsset.navigationImage.image
    }

    lottieView.do {
      $0.contentMode = .scaleAspectFit
      $0.play()
      $0.loopMode = .loop
    }

    scrollView.do {
      $0.showsVerticalScrollIndicator = false
    }

    homeTitle.do {
      $0.text = "오늘은 어떤 키워드로\n공간을 둘러볼까요?"
      $0.font = RecordyFont.title1.font
      $0.textColor = .white
      $0.numberOfLines = 0
      $0.setLineSpacing(lineHeightMultiple: 1.22)
    }

    homeImage.do {
      $0.image = CommonAsset.homeImage.image
      $0.contentMode = .scaleAspectFit
    }

    popularLabel.do {
      $0.text = "이번 주 인기 기록"
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyWhite.color
    }

    recentLabel.do {
      $0.text = "방금 막 올라왔어요"
      $0.font = RecordyFont.subtitle.font
      $0.textColor = CommonAsset.recordyWhite.color
    }

    floatingButton.do {
      $0.backgroundColor = CommonAsset.recordyMain.color
      $0.cornerRadius(22.adaptiveHeight)
      $0.addTarget(
        self,
        action: #selector(floatingButtonTapped),
        for: .touchUpInside
      )
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 1.0
      $0.layer.shadowOffset = CGSize(width: 0, height: 2)
      $0.layer.shadowRadius = 8
      $0.clipsToBounds = false
    }

    floatingButtonText.do {
      $0.text = "기록하기"
      $0.font = RecordyFont.button2.font
      $0.textColor = CommonAsset.recordyGrey08.color
    }

    floatingButtonImage.do {
      $0.image = CommonAsset.uploadButton.image
    }
  }

  func setUI() {
    view.addSubviews(
      lottieView,
      gradientView,
      scrollView,
      floatingButton
    )
    scrollView.addSubview(contentView)
    contentView.addSubviews(
      navigationImage,
      homeTitle,
      homeImage,
      keywordCollectionView,
      popularCollectionView,
      recentCollectionView,
      popularLabel,
      recentLabel
    )
    floatingButton.addSubview(floatingButtonImage)
    floatingButton.addSubview(floatingButtonText)
  }

  func setAutoLayout() {

    lottieView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
    }

    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalTo(885.adaptiveHeight)
    }

    navigationImage.snp.makeConstraints {
      $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(24.adaptiveHeight)
      $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16.adaptiveWidth)
      $0.width.equalTo(48.adaptiveWidth)
      $0.height.equalTo(38.adaptiveHeight)
    }

    homeTitle.snp.makeConstraints {
      $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(117.adaptiveHeight)
      $0.leading.equalToSuperview().offset(16.adaptiveWidth)
    }

    homeImage.snp.makeConstraints {
      $0.width.equalTo(140.adaptiveWidth)
      $0.height.equalTo(155.adaptiveHeight)
      $0.top.equalToSuperview().offset(25.adaptiveHeight)
      $0.trailing.equalToSuperview().inset(16.adaptiveWidth)
    }

    keywordCollectionView.snp.makeConstraints {
      $0.height.equalTo(36.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
      keywordCollectionViewTopAnchor = $0.top.equalTo(homeTitle.snp.bottom).offset(20).constraint
    }

    popularLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(260.adaptiveHeight)
      $0.leading.equalToSuperview().offset(16.adaptiveWidth)
    }

    recentLabel.snp.makeConstraints {
      /// 수정
      $0.top.equalTo(popularCollectionView.snp.bottom).offset(18.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
    }

    popularCollectionView.snp.makeConstraints {
      $0.top.equalTo(popularLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(240.adaptiveHeight)
    }

    recentCollectionView.snp.makeConstraints {
      $0.top.equalTo(recentLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(240.adaptiveHeight)
    }

    floatingButton.snp.makeConstraints {
      $0.width.equalTo(106.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
      $0.trailing.equalToSuperview().inset(16.adaptiveWidth)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.adaptiveHeight)
    }

    floatingButtonImage.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16.adaptiveWidth)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(25.adaptiveWidth)
      $0.height.equalTo(20.adaptiveHeight)
    }

    floatingButtonText.snp.makeConstraints {
      $0.leading.equalTo(floatingButtonImage.snp.trailing).offset(5.adaptiveWidth)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(18.adaptiveHeight)
    }
  }

  private func setKeywordCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 12.adaptiveWidth, bottom: 0, right: 0)
    self.keywordCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.keywordCollectionView.showsVerticalScrollIndicator = false
    self.keywordCollectionView.showsHorizontalScrollIndicator = false
    self.keywordCollectionView.register(
      RecordyFilteringCell.self,
      forCellWithReuseIdentifier: RecordyFilteringCell.cellIdentifier
    )
    self.keywordCollectionView.delegate = self
    self.keywordCollectionView.dataSource = self

  }

  public func setPopularCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.itemSize = CGSize(width: 135, height: 240)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16.adaptiveWidth, bottom: 0, right: 0)

    self.popularCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.popularCollectionView.showsHorizontalScrollIndicator = false
    self.popularCollectionView.register(
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
    )
    self.popularCollectionView.delegate = self
    self.popularCollectionView.dataSource = self
  }

  public func setRecentCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.itemSize = CGSize(width: 135, height: 240)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16.adaptiveWidth, bottom: 0, right: 0)

    self.recentCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )

    self.recentCollectionView.showsHorizontalScrollIndicator = false
    self.recentCollectionView.register(
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
    )
    self.recentCollectionView.delegate = self
    self.recentCollectionView.dataSource = self
  }

  @objc
  func floatingButtonTapped(_ sender: UIButton) {
    let uploadViewController = UploadVideoViewController()
    let navigationController = BaseNavigationController(rootViewController: uploadViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }

  @objc
  func styleButtonTapped(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      self.scrollView.setContentOffset(CGPoint(x: 0, y: 155), animated: false)
    }
    let index = sender.tag
    let keyword = keywords[index]

    if selectedKeywords.first != keyword {
      selectedKeywords.removeAll()
      selectedKeywords.append(keyword)
      getFamousRecordList(selectedKeyword: keyword)
      getRecentRecordList(selectedKeyword: keyword)
    }
    self.keywordCollectionView!.reloadData()
  }

  func getFamousRecordList(selectedKeyword: Keyword) {
    let apiProvider = APIProvider<APITarget.Records>()
    var keyword: String
    if selectedKeyword != .all {
      keyword = selectedKeyword.title.keywordEncode() ?? ""
    } else {
      keyword = ""
    }
    let request = DTO.GetFamousRecordListRequest(
      keywords: keyword,
      pageNumber: 0,
      pageSize: 10
    )
    apiProvider.requestResponsable(.getFamousRecordList(request), DTO.GetFamousRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.famousRecords = response.content.map {
          MainRecord(
            id: $0.recordInfo.id,
            thumbnailUrl: $0.recordInfo.fileUrl.thumbnailUrl,
            location: $0.recordInfo.location,
            isBookmarked: $0.isBookmark
          )
        }
        DispatchQueue.main.async {
          self.popularCollectionView.reloadData()
        }
      case .failure(let error):
        print("Error: - \(error)")
      }
    }
  }

  func getRecentRecordList(selectedKeyword: Keyword) {
    let apiProvider = APIProvider<APITarget.Records>()
    var keyword: String?
    if selectedKeyword != .all {
      keyword = selectedKeyword.title.keywordEncode() ?? ""
    } else {
      keyword = nil
    }
    let request = DTO.GetRecentRecordListRequest(keywords: keyword, cursorId: 0, size: 10)
    apiProvider.requestResponsable(.getRecentRecordList(request), DTO.GetRecentRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.recentRecords = response.content.map {
          MainRecord(
            id: $0.recordInfo.id,
            thumbnailUrl: $0.recordInfo.fileUrl.thumbnailUrl,
            location: $0.recordInfo.location,
            isBookmarked: $0.isBookmark
          )
        }
        DispatchQueue.main.async {
          self.recentCollectionView.reloadData()
        }
      case .failure(let error):
        print("Error: - \(error)")
      }
    }
  }

  func postBookmarkRequest(index: Int, type: RecordType) {
    if type == .famous {
      self.famousRecords[index].isBookmarked.toggle()
    } else {
      self.recentRecords[index].isBookmarked.toggle()
    }

    let apiProvider = APIProvider<APITarget.Bookmark>()
    let request = DTO.PostBookmarkRequest(recordId: type == .famous ? famousRecords[index].id : recentRecords[index].id)
    apiProvider.justRequest(.postBookmark(request)) { result in
      switch result {
      case .success(let success):
        print(success)
      case .failure(let failure):
        print(failure)
      }
    }
  }
}

@available(iOS 16.0, *)
extension HomeViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case popularCollectionView:
      return famousRecords.count
    case recentCollectionView:
      return recentRecords.count
    case keywordCollectionView:
      return keywords.count
    default:
      return 0
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch collectionView {
    case popularCollectionView:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as! ThumbnailCollectionViewCell
      let famousRecord = famousRecords[indexPath.row]
      cell.configure(with: famousRecord)
      cell.bookmarkButtonEvent = { [weak self] in
        guard let self = self else { return }
        self.postBookmarkRequest(
          index: indexPath.row,
          type: .famous
        )
        cell.updateBookmarkButton(isBookmarked: famousRecords[indexPath.row].isBookmarked)
      }
      return cell
    case recentCollectionView:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as! ThumbnailCollectionViewCell
      let recentRecord = recentRecords[indexPath.row]
      cell.configure(with: recentRecord)
      cell.bookmarkButtonEvent = { [weak self] in
        guard let self = self else { return }
        self.postBookmarkRequest(
          index: indexPath.row,
          type: .recent
        )
        cell.updateBookmarkButton(isBookmarked: recentRecords[indexPath.row].isBookmarked)
      }
      return cell
    case keywordCollectionView:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RecordyFilteringCell.cellIdentifier,
        for: indexPath
      ) as! RecordyFilteringCell
      let keyword = keywords[indexPath.item]
      let isSelected = selectedKeywords.contains(keyword)
      cell.bind(keyword: keyword, isSelected: isSelected)
      cell.chipButton.tag = indexPath.item
      cell.chipButton.addTarget(
        self,
        action: #selector(styleButtonTapped),
        for: .touchUpInside
      )
      return cell
    default:
      fatalError("Unexpected collection view")
    }
  }

  /// TODO
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    var nextType: VideoFeedType = .famous
    var currentId: Int?
    if collectionView == popularCollectionView {
      nextType = .famous
      currentId = famousRecords[indexPath.row].id
    } else if collectionView == recentCollectionView {
      nextType = .recent
      currentId = recentRecords[indexPath.row].id
    }
    let videoFeedViewController = VideoFeedViewController(
      type: nextType,
      keyword: selectedKeywords.first,
      currentId: currentId,
      cursorId: 0
    )
    self.navigationController?.pushViewController(
      videoFeedViewController,
      animated: true
    )
  }
}

@available(iOS 16.0, *)
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case popularCollectionView, recentCollectionView:
      return CGSize(width: 135.adaptiveWidth, height: 240.adaptiveHeight)
    case keywordCollectionView:
      let keyword = keywords[indexPath.item]
      let width = keyword.width
      let height = collectionView.frame.height
      return CGSize(width: width.adaptiveWidth, height: height.adaptiveHeight)
    default:
      return CGSize.zero
    }
  }
}

@available(iOS 16.0, *)
extension HomeViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.scrollView {
      let yOffset = scrollView.contentOffset.y
      if yOffset >= 155 {
        if !keywordIsSticky {
          keywordCollectionView.removeFromSuperview()
          view.addSubview(keywordCollectionView)
          keywordCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(36.adaptiveHeight)
          }
          keywordIsSticky = true
        }
        homeTitle.isHidden = true
        homeImage.isHidden = true
      } else {
        if keywordIsSticky {
          keywordCollectionView.removeFromSuperview()
          contentView.addSubview(keywordCollectionView)
          keywordCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(homeTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(36.adaptiveHeight)
          }
          keywordIsSticky = false
        }
        homeTitle.isHidden = false
        homeImage.isHidden = false
      }
      view.layoutIfNeeded()
    }
  }
}
