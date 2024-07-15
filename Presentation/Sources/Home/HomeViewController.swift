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

public final class HomeViewController: UIViewController {
  
  var selectedKeywords: [Keyword] = []
  let keywords = Keyword.allCases
  
  let scrollView = UIScrollView()
  let contentView = UIView()
  let homeTitle = UILabel()
  let homeImage = UIImageView()
  let popularLabel = UILabel()
  let recentLabel = UILabel()
  
  let floatingButton = UIButton()
  let floatingButtonContainer = UIView()
  let floatingButtonImage = UIImageView()
  let floatingButtonText = UILabel()
  
  var keywordCollectionView: UICollectionView!
  var popularCollectionView: UICollectionView!
  var recentCollectionView: UICollectionView!
  
  weak var popularDelegate: HomeCollectionViewDelegate?
  weak var recentDelegate: HomeCollectionViewDelegate?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setKeywordCollectionView()
    setPopularCollectionView()
    setRecentCollectionView()
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  func setStyle() {
    self.view.backgroundColor = CommonAsset.recordyBG.color
    self.keywordCollectionView.backgroundColor = CommonAsset.recordyBG.color
    self.popularCollectionView.backgroundColor = CommonAsset.recordyBG.color
    self.recentCollectionView.backgroundColor = CommonAsset.recordyBG.color
    
    homeTitle.do {
      $0.text = "오늘은 어떤 키워드로\n공간을 둘러볼까요?"
      $0.font = RecordyFont.title1.font
      $0.textColor = .white
      $0.numberOfLines = 0
    }
    homeImage.do {
      $0.image = CommonAsset.homeRottie.image
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
    }
    floatingButtonText.do {
      $0.text = "기록하기"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey08.color
    }
    floatingButtonImage.do {
      $0.image = CommonAsset.uploadButton.image
    }
  }
  
  func setUI() {
    view.addSubviews(
      scrollView,
      floatingButton
    )
    scrollView.addSubview(contentView)
    contentView.addSubviews(
      homeTitle,
      homeImage,
      keywordCollectionView,
      popularCollectionView,
      recentCollectionView,
      popularLabel,
      recentLabel
    )
    floatingButton.addSubview(floatingButtonContainer)
    floatingButtonContainer.addSubviews(
      floatingButtonText,
      floatingButtonImage
    )
  }
  
  func setAutoLayout() {
    
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualToSuperview().priority(.low)
    }
    
    homeTitle.snp.makeConstraints {
      $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(128)
      $0.leading.equalToSuperview().offset(20)
    }
    
    homeImage.snp.makeConstraints {
      $0.width.equalTo(140.adaptiveWidth)
      $0.height.equalTo(140.adaptiveHeight)
      $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(60)
      $0.trailing.equalToSuperview().inset(9)
    }
    
    keywordCollectionView.snp.makeConstraints {
      $0.top.equalTo(homeTitle.snp.bottom).offset(20)
      $0.height.equalTo(34.adaptiveHeight)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview()
    }
    
    popularLabel.snp.makeConstraints {
      $0.top.equalTo(keywordCollectionView.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(10)
    }
    
    recentLabel.snp.makeConstraints {
      $0.top.equalTo(popularCollectionView.snp.bottom).offset(18)
      $0.leading.equalToSuperview().offset(10)
    }
    
    popularCollectionView.snp.makeConstraints {
      $0.top.equalTo(popularLabel.snp.bottom).offset(12)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(240.adaptiveHeight)
    }
    
    recentCollectionView.snp.makeConstraints {
      $0.top.equalTo(recentLabel.snp.bottom).offset(12)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(240.adaptiveHeight)
      $0.bottom.equalTo(contentView)
    }
    
    floatingButton.snp.makeConstraints {
      $0.width.equalTo(106.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    
    floatingButtonContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    floatingButtonImage.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(14)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(25.adaptiveWidth)
      $0.height.equalTo(20.adaptiveHeight)
    }
    
    floatingButtonText.snp.makeConstraints {
      $0.leading.equalTo(floatingButtonImage.snp.trailing).offset(5)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func setKeywordCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSize(width: 135, height: 240)
    
    self.keywordCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.keywordCollectionView.showsVerticalScrollIndicator = false
    self.keywordCollectionView.register(
      RecordyFilteringCell.self,
      forCellWithReuseIdentifier: RecordyFilteringCell.cellIdentifier
    )
    self.keywordCollectionView.delegate = self
    self.keywordCollectionView.dataSource = self
  }
  
  private func setPopularCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.itemSize = CGSize(width: 135, height: 240)
    
    self.popularCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.popularCollectionView.showsHorizontalScrollIndicator = false
    self.popularCollectionView.register(
      PopularCollectionViewCell.self,
      forCellWithReuseIdentifier: PopularCollectionViewCell.cellIdentifier
    )
    self.popularCollectionView.delegate = self
    self.popularCollectionView.dataSource = self
  }
  
  private func setRecentCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.itemSize = CGSize(width: 135, height: 240)
    
    self.recentCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    
    self.recentCollectionView.showsHorizontalScrollIndicator = false
    self.recentCollectionView.register(
      RecentCollectionViewCell.self,
      forCellWithReuseIdentifier: RecentCollectionViewCell.cellIdentifier
    )
    self.recentCollectionView.delegate = self
    self.recentCollectionView.dataSource = self
  }
  
  @objc
  func chipButtonTapped(_ sender: UIButton) {
    let index = sender.tag
  }
}

extension HomeViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case popularCollectionView:
      return 10
    case recentCollectionView:
      return 10
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
        withReuseIdentifier: PopularCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as! PopularCollectionViewCell
      return cell
      
    case recentCollectionView:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RecentCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as! RecentCollectionViewCell
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
        action: #selector(chipButtonTapped),
        for: .touchUpInside
      )
      return cell
    default:
      fatalError("Unexpected collection view")
    }
  }
}
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
