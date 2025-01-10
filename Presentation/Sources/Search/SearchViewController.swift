//
//  SearchViewController.swift
//  Presentation
//
//  Created by Chandrala on 11/14/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

import Combine
import Then
import SnapKit


private enum SearchState {
  case initial
  case loading
  case empty
  case complete
}

public class SearchViewController: UIViewController {
  private var currentState: SearchState = .initial {
    didSet {
      updateUI(for: currentState)
    }
  }
  
  private let searchContainerView = UIView()
  private let searchTextfield =  UITextField()
  private let searchTextfieldIcon = UIImageView()
  private let searchTipIcon = UIImageView()
  private let searchTipLabel = UILabel()
  private let searchColoredTipLabel = UILabel()
  private let emptyStateImage = UIImageView()
  private let emptyStateLabel = UILabel()
  private var searchCompleteCollectionView: UICollectionView!
  private var searchLoadingCollectionView: UICollectionView!
  private var textFieldCancellable: AnyCancellable?
  private var cancellables = Set<AnyCancellable>()
  private let searchSubject = PassthroughSubject<String, Never>()
  private var viewModel = SearchViewModel()
  
  public init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    searchTextfield.delegate = self
    
    setSearchLoadingCollectionView()
    setSearchCompleteCollectionView()
    setStyle()
    setUI()
    setAutolayout()
    bind()
    bindSearchSubject()
    observeTextChanges()
    
    currentState = .initial
  }
  
  private func setStyle() {
    navigationController?.isNavigationBarHidden = true
    
    searchContainerView.do {
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.layer.cornerRadius = 8
    }
    
    searchTextfieldIcon.do {
      $0.image = CommonAsset.searchGray.image
      $0.contentMode = .scaleAspectFit
    }
    
    searchTextfield.do {
      $0.setPlaceholder(
        placeholder: "어떤 공간을 원하시나요?",
        placeholderColor: CommonAsset.viskitGray05,
        font: .body1
      )
      $0.font = ViskitFont.body1.font
      $0.textColor = CommonAsset.viskitGray05.color
      $0.layer.cornerRadius = 8
      $0.backgroundColor = .clear
      $0.addPadding(left: 0, right: 16)
    }
    
    searchTipIcon.do {
      $0.image = CommonAsset.searchYellow.image
      $0.contentMode = .scaleAspectFit
    }
    
    searchTipLabel.do {
      $0.text = "공간뿐만 아니라 원하는 전시회를 찾고 싶다면?"
      $0.font  = ViskitFont.caption1Medium.font
      $0.textColor = CommonAsset.viskitGray05.color
      $0.textAlignment = .left
    }
    
    searchColoredTipLabel.do {
      $0.text = "'전시회명'을 검색해 보세요!"
      $0.font = ViskitFont.subtitle.font
      $0.textColor = CommonAsset.viskitWhite.color
      $0.textAlignment = .left
      $0.setColor(
        for: "'전시회명'",
        with: CommonAsset.viskitYellow300.color
      )
    }
    
    emptyStateImage.do {
      $0.image = CommonAsset.ledyEmpty2.image
      $0.contentMode = .scaleAspectFit
    }
    
    emptyStateLabel.do {
      $0.text = "검색 결과가 없어요\n검색어가 정확한지 확인해주세요!"
      $0.font = ViskitFont.title2.font
      $0.textColor = CommonAsset.viskitGray02.color
      $0.setLineSpacing(lineHeightMultiple: 1.3)
      $0.textAlignment = .center
      $0.numberOfLines = 2
    }
  }
  
  private func setUI() {
    view.addSubviews(
      searchContainerView,
      searchTipIcon,
      searchTipLabel,
      searchColoredTipLabel,
      searchLoadingCollectionView,
      emptyStateImage,
      emptyStateLabel,
      searchCompleteCollectionView
    )
    searchContainerView.addSubviews(
      searchTextfieldIcon,
      searchTextfield
    )
  }
  
  private func setAutolayout() {
    searchContainerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(52.adaptiveHeight)
    }
    
    searchTextfieldIcon.snp.makeConstraints {
      $0.top.equalToSuperview().offset(14)
      $0.leading.equalToSuperview().offset(16)
      $0.width.equalTo(24.adaptiveWidth)
      $0.height.equalTo(24.adaptiveHeight)
    }
    
    searchTextfield.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(searchTextfieldIcon.snp.trailing).offset(8)
      $0.trailing.equalToSuperview()
      $0.height.equalTo(searchContainerView.snp.height)
    }
    
    searchTipIcon.snp.makeConstraints {
      $0.top.equalTo(searchContainerView.snp.bottom).offset(31)
      $0.leading.equalToSuperview().offset(24)
      $0.width.equalTo(40.adaptiveWidth)
      $0.height.equalTo(40.adaptiveHeight)
    }
    
    searchTipLabel.snp.makeConstraints {
      $0.top.equalTo(searchContainerView.snp.bottom).offset(28)
      $0.leading.equalTo(searchTipIcon.snp.trailing).offset(12)
    }
    
    searchColoredTipLabel.snp.makeConstraints {
      $0.top.equalTo(searchTipLabel.snp.bottom).offset(8)
      $0.leading.equalTo(searchTipIcon.snp.trailing).offset(12)
    }
    
    searchLoadingCollectionView.snp.makeConstraints {
      $0.top.equalTo(searchContainerView.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    emptyStateImage.snp.makeConstraints {
      $0.top.equalTo(searchContainerView.snp.bottom).offset(184)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(122.adaptiveWidth)
      $0.height.equalTo(107.adaptiveHeight)
    }
    
    emptyStateLabel.snp.makeConstraints {
      $0.top.equalTo(emptyStateImage.snp.bottom).offset(14)
      $0.centerX.equalToSuperview()
    }
    
    searchCompleteCollectionView.snp.makeConstraints {
      $0.top.equalTo(searchContainerView.snp.bottom).offset(14)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  private func setSearchLoadingCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    self.searchLoadingCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.searchLoadingCollectionView.showsHorizontalScrollIndicator = false
    self.searchLoadingCollectionView.register(
      SearchLoadingCollectionViewCell.self,
      forCellWithReuseIdentifier: SearchLoadingCollectionViewCell.cellIdentifier
    )
    self.searchLoadingCollectionView.delegate = self
    self.searchLoadingCollectionView.dataSource = self
  }
  
  private func setSearchCompleteCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    self.searchCompleteCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.searchCompleteCollectionView.showsHorizontalScrollIndicator = false
    self.searchCompleteCollectionView.register(
      SearchCompleteCollectionViewCell.self,
      forCellWithReuseIdentifier: SearchCompleteCollectionViewCell.cellIdentifier
    )
    self.searchCompleteCollectionView.delegate = self
    self.searchCompleteCollectionView.dataSource = self
  }
  
  private func updateUI(for state: SearchState) {
    switch state {
    case .initial:
      searchTipIcon.isHidden = false
      searchTipLabel.isHidden = false
      searchColoredTipLabel.isHidden = false
      searchCompleteCollectionView.isHidden = true
      searchLoadingCollectionView.isHidden = true
      emptyStateImage.isHidden = true
      emptyStateLabel.isHidden = true
      
    case .loading:
      searchTipIcon.isHidden = true
      searchTipLabel.isHidden = true
      searchColoredTipLabel.isHidden = true
      searchCompleteCollectionView.isHidden = true
      searchLoadingCollectionView.isHidden = false
      emptyStateImage.isHidden = true
      emptyStateLabel.isHidden = true
      
    case .empty:
      searchTipIcon.isHidden = true
      searchTipLabel.isHidden = true
      searchColoredTipLabel.isHidden = true
      searchCompleteCollectionView.isHidden = true
      searchLoadingCollectionView.isHidden = true
      emptyStateImage.isHidden = false
      emptyStateLabel.isHidden = false
      
    case .complete:
      searchTipIcon.isHidden = true
      searchTipLabel.isHidden = true
      searchColoredTipLabel.isHidden = true
      searchCompleteCollectionView.isHidden = false
      searchLoadingCollectionView.isHidden = true
      emptyStateImage.isHidden = true
      emptyStateLabel.isHidden = true
    }
  }
  
  private func bind() {
    viewModel.onCompleteExhibitionsUpdated = { [weak self] in
      DispatchQueue.main.async {
        self?.searchLoadingCollectionView.reloadData()
        self?.searchCompleteCollectionView.reloadData()
      }
    }
  }
  
  private func bindSearchSubject() {
    searchSubject
      .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
    // 사용자 입력 시간 고려, 500Ms 이후 데이터 요청
      .removeDuplicates()
      .sink { [weak self] query in
        guard let self = self else { return }
        if query != self.searchTextfield.text {
          // debounce의 대기 시간 동안 사용자 입력과 상태 변화를 동기화해서 textField Empty 상태 감지
          return
        }
        self.updateSearchState(for: query)
        self.viewModel.getSearchResults(query: query)
      }
      .store(in: &cancellables)
  }
  
  private func observeTextChanges() {
    textFieldCancellable = searchTextfield.textPublisher
      .sink { [weak self] text in
        guard let self = self else { return }
        self.updateSearchState(for: text)
      }
  }
  
  private func updateSearchState(for text: String?) {
    DispatchQueue.main.async {
      guard let text = text, !text.isEmpty else {
        self.currentState = .initial
        return
      }
      self.currentState = .loading
      self.searchSubject.send(text.precomposedStringWithCanonicalMapping)
    }
  }
}

extension SearchViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case searchLoadingCollectionView:
      return viewModel.searchResults.count
    case searchCompleteCollectionView:
      return viewModel.filteredSearchResults.count
    default:
      return 0
    }
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch collectionView {
    case searchLoadingCollectionView:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchLoadingCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? SearchLoadingCollectionViewCell else {
        fatalError("Failed to dequeue SearchLoadingCollectionViewCell")
      }
      let result = viewModel.searchResults[indexPath.row]
      cell.bind(result: result)
      return cell
      
    case searchCompleteCollectionView:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchCompleteCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? SearchCompleteCollectionViewCell else {
        fatalError("Failed to dequeue SearchCompleteCollectionViewCell")
      }
      let place = viewModel.filteredSearchResults[indexPath.row]
      cell.bind(place: place)
      return cell
      
    default:
      fatalError("Unexpected collection view")
    }
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {}
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case searchLoadingCollectionView:
      return CGSize(
        width: collectionView.bounds.width,
        height: 68.adaptiveHeight
      )
      
    case searchCompleteCollectionView:
      let place = viewModel.filteredSearchResults[indexPath.row]
      let exhibitionCount = place.exhibitionList.count
      let exhibitionHeight = 42.adaptiveHeight
      let spacing: CGFloat = 8.0
      let baseHeight: CGFloat = 75.0
      let totalHeight = baseHeight + (CGFloat(exhibitionCount) * (exhibitionHeight + spacing))
      return CGSize(
        width: collectionView.bounds.width,
        height: totalHeight
      )
      
    default:
      return CGSize.zero
    }
  }
}

extension SearchViewController: UITextFieldDelegate {
  
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    updateSearchState(for: textField.text)
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    currentState = .complete
    return true
  }
}


//----------------------------------------------------
//1️⃣[GET] http://13.209.194.222/api/v1/search?query=%EB%8B%AC%ED%86%A0
//----------------------------------------------------
//2️⃣API: getSearch(Core.DTO.GetSearchRequest(query: "달토"))
//------------------- END GET -------------------
//------------------- Reponse가 도착했습니다. -------------------
//3️⃣[200] http://13.209.194.222/api/v1/search?query=%EB%8B%AC%ED%86%A0
//API: getSearch(Core.DTO.GetSearchRequest(query: "달토"))
//Status Code: [200]
//URL: http://13.209.194.222/api/v1/search?query=%EB%8B%AC%ED%86%A0
//response:
//4️⃣[{"id":434,"type":"EXHIBITION","address":"서울 용산구 용산동6가 168-6","name":"달항아리를 만든 곳, 금사리"},{"id":426,"type":"EXHIBITION","address":"서울 종로구 세종로 1-1","name":"달토끼와 산토끼"},{"id":432,"type":"EXHIBITION","address":"서울 서대문구 현저동 101","name":"2024년 이달의 독립운동가 \"세계 속의 한국독립운동\""},{"id":485,"type":"EXHIBITION","address":"서울 성북구 돈암동 538-59","name":"2024 성북 신문인사 프로젝트 &lt;이태준: 달밤은 그에게도 유감한 듯하였다&gt; 展"}]
//----------------------------------------------------





//------------------- Reponse가 도착했습니다. -------------------
//3️⃣[200] http://13.209.194.222/api/v1/places/430
//API: getPlaceList(id: 430)
//Status Code: [200]
//URL: http://13.209.194.222/api/v1/places/430
//response:
//4️⃣{"id":430,"name":"동대문디자인플라자","address":"서울 중구 을지로7가 2-1","platformId":"25022134","location":{"id":430,"longitude":127.009911013917,"latitude":37.5671843130818},"exhibitionSize":1,"recordSize":0}
//------------------- END HTTP -------------------

//------------------- Reponse가 도착했습니다. -------------------
//3️⃣[200] http://13.209.194.222/api/v1/exhibitions?placeId=430
//API: getExhibitionList(Core.DTO.GetExhibitionListRequest(placeId: 430))
//Status Code: [200]
//URL: http://13.209.194.222/api/v1/exhibitions?placeId=430
//response:
//4️⃣[]
//------------------- END HTTP -------------------
