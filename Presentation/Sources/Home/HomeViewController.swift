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

@available(iOS 16.0, *)
public final class HomeViewController: UIViewController {
  
  var selectedKeywords: [Keyword] = []
  let keywords = Keyword.allCases
  
  let scrollView = UIScrollView()
  let contentView = UIView()
  let gradientView = RecordyGradientView()
  let homeTitle = UILabel()
  let homeImage = UIImageView()
  let popularLabel = UILabel()
  let recentLabel = UILabel()
  
  let floatingButton = UIButton()
  let floatingButtonStackView = UIStackView()
  let floatingButtonImage = UIImageView()
  let floatingButtonText = UILabel()
  
  var keywordCollectionView: UICollectionView!
  var popularCollectionView: UICollectionView!
  var recentCollectionView: UICollectionView!
  
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
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  func setStyle() {
    self.view.backgroundColor = CommonAsset.recordyBG.color
    self.keywordCollectionView.backgroundColor = .clear
    self.popularCollectionView.backgroundColor = .clear
    self.recentCollectionView.backgroundColor = .clear
    
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
    
    floatingButtonStackView.do {
      $0.axis = .horizontal
      $0.distribution = .fillProportionally
      $0.alignment = .center
      $0.spacing = 3
    }
    
    floatingButton.do {
      $0.backgroundColor = CommonAsset.recordyMain.color
      $0.cornerRadius(22.adaptiveHeight)
      $0.addTarget(
        self,
        action: #selector(floatingButtonTapped),
        for: .touchUpInside
      )
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
      gradientView,
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
    floatingButton.addSubview(floatingButtonStackView)
    floatingButtonStackView.addArrangedSubview(floatingButtonImage)
    floatingButtonStackView.addArrangedSubview(floatingButtonText)
  }
  
  func setAutoLayout() {
    
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
      $0.height.equalTo(980)
    }
    
    homeTitle.snp.makeConstraints {
      $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(117)
      $0.leading.equalToSuperview().offset(20)
    }
    
    homeImage.snp.makeConstraints {
      $0.width.equalTo(140.adaptiveWidth)
      $0.height.equalTo(155.adaptiveHeight)
      $0.top.equalToSuperview().offset(25)
      $0.trailing.equalToSuperview().inset(16)
    }
    
    keywordCollectionView.snp.makeConstraints {
      $0.height.equalTo(34.adaptiveHeight)
      $0.leading.trailing.equalToSuperview().offset(20)
      keywordCollectionViewTopAnchor = $0.top.equalTo(homeTitle.snp.bottom).offset(20).constraint
    }
    
    popularLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(260)
      $0.leading.equalToSuperview().offset(20)
    }
    
    recentLabel.snp.makeConstraints {
      $0.top.equalTo(popularCollectionView.snp.bottom).offset(18)
      $0.leading.equalToSuperview().offset(10)
    }
    
    popularCollectionView.snp.makeConstraints {
      $0.top.equalTo(popularLabel.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview()
      $0.height.equalTo(240.adaptiveHeight)
    }
    
    recentCollectionView.snp.makeConstraints {
      $0.top.equalTo(recentLabel.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview()
      $0.height.equalTo(240.adaptiveHeight)
    }
    
    floatingButton.snp.makeConstraints {
      $0.width.equalTo(106.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    
    floatingButtonStackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    floatingButtonImage.snp.makeConstraints {
      $0.width.equalTo(25.adaptiveWidth)
      $0.height.equalTo(20.adaptiveHeight)
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
    self.keywordCollectionView.showsHorizontalScrollIndicator = false
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
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
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
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier
    )
    self.recentCollectionView.delegate = self
    self.recentCollectionView.dataSource = self
  }
  
  @objc
  func floatingButtonTapped(_ sender: UIButton) {
    let uploadViewController = UploadVideoViewController()
    self.present(uploadViewController, animated: true)
  }
  
  @objc
  func chipButtonTapped(_ sender: UIButton) {
    let index = sender.tag
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
    case popularCollectionView, recentCollectionView:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as! ThumbnailCollectionViewCell
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
    let yOffset = scrollView.contentOffset.y
    
    if yOffset >= 155 {
      if !keywordIsSticky {
        keywordCollectionView.removeFromSuperview()
        view.addSubview(keywordCollectionView)
        keywordCollectionView.snp.remakeConstraints { make in
          make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
          make.leading.trailing.equalToSuperview().inset(20)
          make.height.equalTo(34.adaptiveHeight)
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
          make.leading.trailing.equalToSuperview().inset(20)
          make.height.equalTo(34.adaptiveHeight)
        }
        keywordIsSticky = false
      }
      homeTitle.isHidden = false
      homeImage.isHidden = false
    }
    view.layoutIfNeeded()
  }
}
