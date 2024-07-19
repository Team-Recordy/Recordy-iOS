//
//  RecordyFilteringViewController.swift
//  Common
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core

import SnapKit
import Then

public protocol FilteringDelegate: AnyObject {
  func selectKeywords(_ keywords: [Keyword])
}

public class RecordyFilteringViewController: UIViewController {

  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let additionalDescriptionLabel = UILabel()
  private let closeButton = UIButton()
  private var collectionView: UICollectionView?
  private let applyButton = UIButton()

  let keywords = Keyword.allCases
  var selectedKeywords: [Keyword] = [] {
    didSet {
      updateApplyButton()
    }
  }
  weak public var delegate: FilteringDelegate?

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setStyle()
    setUI()
    setAutolayout()
  }

  private func setStyle() {
    self.view.backgroundColor = CommonAsset.recordyGrey08.color
    self.collectionView?.backgroundColor = CommonAsset.recordyGrey08.color

    self.titleLabel.do {
      $0.text = "키워드 선택"
      $0.textColor = CommonAsset.recordyGrey01.color
      $0.font = RecordyFont.subtitle.font
    }
    self.descriptionLabel.do {
      $0.text = "해당 공간은\n어떤 느낌인가요?"
      $0.textColor = CommonAsset.recordyWhite.color
      $0.font = RecordyFont.title1.font
      $0.numberOfLines = 2
      $0.setLineSpacing(lineHeightMultiple: 1.22)
    }
    self.additionalDescriptionLabel.do {
      $0.text = "키워드 1~3개 선택 시, 프로필에서 취향을 분석해 드립니다."
      $0.textColor = CommonAsset.recordyGrey03.color
      $0.font = RecordyFont.caption1.font
    }
    self.applyButton.do {
      $0.setTitle("적용하기", for: .normal)
      $0.setTitleColor(
        CommonAsset.recordyGrey01.color,
        for: .normal
      )
      $0.titleLabel?.font = RecordyFont.button2.font
      $0.backgroundColor = CommonAsset.recordyGrey06.color
      $0.isEnabled = false
      $0.cornerRadius(8)
      $0.addTarget(
        self, 
        action: #selector(applyButtonTapped), 
        for: .touchUpInside
      )
    }
  }

  private func setUI() {
    self.view.addSubviews(
      collectionView!,
      titleLabel,
      descriptionLabel,
      additionalDescriptionLabel,
      applyButton
    )
  }

  private func setAutolayout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }
//    self.closeButton.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(20.adaptiveHeight)
//      $0.trailing.equalToSuperview().inset(16.adaptiveWidth)
//      $0.width.height.equalTo(28)
//    }
    self.descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(28.adaptiveHeight)
      $0.leading.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(64.adaptiveHeight)
    }
    self.additionalDescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.leading.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }
    self.collectionView!.snp.makeConstraints {
      $0.top.equalTo(self.additionalDescriptionLabel.snp.bottom).offset(28.adaptiveHeight)
      $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.adaptiveHeight)
      $0.height.equalTo(126.adaptiveHeight)
    }
    self.applyButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(68.adaptiveHeight)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(125.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
    }
  }

  private func setUpCollectionView() {
    let layout = LeftAlignedCollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10.adaptiveHeight
    layout.minimumInteritemSpacing = 6
    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.collectionView!.showsVerticalScrollIndicator = false
    self.collectionView!.register(
      RecordyFilteringCell.self,
      forCellWithReuseIdentifier: RecordyFilteringCell.cellIdentifier
    )
    self.collectionView!.delegate = self
    self.collectionView!.dataSource = self
  }

  @objc func chipButtonTapped(_ sender: UIButton) {
    let index = sender.tag
    let keyword = keywords[index]
    if selectedKeywords.contains(keyword) {
      let keywordIndex = selectedKeywords.firstIndex(of: keyword)!
      selectedKeywords.remove(at: keywordIndex)
    } else {
      if selectedKeywords.count < 3 {
        selectedKeywords.append(keyword)
      } else {
        selectedKeywords.removeFirst()
        selectedKeywords.append(keyword)
      }
    }
    self.collectionView!.reloadData()
  }

  @objc func applyButtonTapped() {
    delegate?.selectKeywords(selectedKeywords)
    self.dismiss(animated: true)
  }

  @objc func closeButtonTapped() {
    self.dismiss(animated: true)
  }

  private func updateApplyButton() {
    if self.selectedKeywords.count > 0 {
      self.applyButton.backgroundColor = CommonAsset.recordyMain.color
      self.applyButton.setTitleColor(
        CommonAsset.recordyGrey09.color,
        for: .normal
      )
      self.applyButton.isEnabled = true
    } else {
      self.applyButton.backgroundColor = CommonAsset.recordyGrey06.color
      self.applyButton.setTitleColor(
        CommonAsset.recordyGrey01.color,
        for: .normal
      )
      self.applyButton.isEnabled = false
    }
  }
}

extension RecordyFilteringViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return keywords.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
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
  }
}

extension RecordyFilteringViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = keywords[indexPath.row].width
    return CGSize(width: width, height: 34.adaptiveHeight)
  }
}
