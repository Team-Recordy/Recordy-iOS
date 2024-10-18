import UIKit
import SnapKit
import Then

import Core
import Common

protocol UserRecordDelegate: AnyObject {
  func userRecordFeedTapped(feed: Feed)
  func uploadFeedTapped()
}

@available(iOS 16.0, *)
public class MyRecordView: UIView {
  private let emptyView = MyRecordEmptyView()
  private let countLabel = UILabel()
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 170, height: 288)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    cv.dataSource = self
    cv.delegate = self
    cv.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier)
    return cv
  }()
  
  private var feeds: [Feed] = [] {
    didSet { updateViewState() }
  }
  
  weak var delegate: UserRecordDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setStyle() {
    backgroundColor = .black
    
    countLabel.do {
      $0.textColor = .white
      $0.font = ViskitFont.caption1Regular.font
      $0.numberOfLines = 1
      $0.textAlignment = .right
    }
    
    emptyView.onRecordButtonTapped = { [weak self] in
      self?.delegate?.uploadFeedTapped()
    }
  }
  
  private func setUI() {
    [
      emptyView,
      countLabel,
      collectionView
    ].forEach { addSubview($0) }
  }
  
  private func setAutoLayout() {
    emptyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    countLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-18)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(18.adaptiveHeight)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(countLabel.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func updateViewState() {
    let isEmpty = feeds.isEmpty
    emptyView.isHidden = !isEmpty
    collectionView.isHidden = isEmpty
    
    setCountLabelText()
    
    if !isEmpty {
      setCountLabelText()
      collectionView.reloadData()
    }
  }
  
  private func setCountLabelText() {
    let whiteText = "• \(feeds.count)"
    let greyText = " 개의 기록"
    let attributedText = NSMutableAttributedString(string: whiteText, attributes: [.foregroundColor: UIColor.white])
    attributedText.append(NSAttributedString(string: greyText, attributes: [.foregroundColor: CommonAsset.viskitGray03.color]))
    countLabel.attributedText = attributedText
  }
  
  func getMyRecordList(feeds: [Feed]) {
    self.feeds = feeds
  }
}

@available(iOS 16.0, *)
extension MyRecordView: UICollectionViewDataSource, UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feeds.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? ThumbnailCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.configure(feed: feeds[indexPath.row])
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.userRecordFeedTapped(feed: feeds[indexPath.row])
  }
}
