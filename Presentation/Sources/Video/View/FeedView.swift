//
//  FeedView.swift
//  Presentation
//
//  Created by 한지석 on 7/8/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

class FeedView: UIView {

  private let locationStackView = UIStackView().then {
    $0.spacing = 4.adaptiveWidth
    $0.axis = .horizontal
    $0.layer.backgroundColor = (UIColor.black.cgColor).copy(alpha: 0.5)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(
      top: 0,
      left: 8,
      bottom: 0,
      right: 8
    )
    $0.cornerRadius(8)
  }
  private let bookmarkStackView = UIStackView().then {
    $0.spacing = 7.adaptiveHeight
    $0.axis = .vertical
    $0.alignment = .center
  }
  private let descriptionStackView = UIStackView().then {
    $0.spacing = 8.adaptiveHeight
    $0.axis = .vertical
  }
  private let locationImage = UIImageView().then {
    $0.image = CommonAsset.location.image
    $0.contentMode = .scaleAspectFit
  }
  let locationLabel = UILabel().then {
    $0.text = "서울특별시 강남구 테헤란로 123"
    $0.textColor = .white
    $0.font = RecordyFont.caption1.font
  }
  let nicknameLabel = UILabel().then {
    $0.text = "닉네임"
    $0.textColor = .white
    $0.font = RecordyFont.subtitle.font
  }
  let descriptionTextView = UITextView().then {
    $0.text = "계절이 지나가는 하늘에는 가을로 가득 차 있습니다. 나는 아무 걱정도 없이...더보기"
    $0.textColor = .white
    $0.isEditable = false
    $0.isScrollEnabled = false
    $0.textContainer.maximumNumberOfLines = 2
    $0.textContainer.lineBreakMode = .byTruncatingTail
    $0.backgroundColor = .clear
    let padding = $0.textContainer.lineFragmentPadding
    $0.contentInset = UIEdgeInsets(
      top: -padding,
      left: -padding,
      bottom: 0,
      right: 0
    )
    $0.font = RecordyFont.body2Long.font
  }
  let bookmarkButton = UIButton().then {
    $0.setImage(CommonAsset.bookmarkSelected.image, for: .normal)
  }
  let bookmarkLabel = UILabel().then {
    $0.text = "100"
    $0.textColor = .white
    $0.font = RecordyFont.body2Long.font
  }

  private var isExpanded = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutolayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUI() {
    bookmarkStackView.addArrangedSubview(bookmarkButton)
    bookmarkStackView.addArrangedSubview(bookmarkLabel)
    locationStackView.addArrangedSubview(locationImage)
    locationStackView.addArrangedSubview(locationLabel)
    descriptionStackView.addArrangedSubview(nicknameLabel)
    descriptionStackView.addArrangedSubview(descriptionTextView)
    [
      descriptionStackView,
      locationStackView,
      bookmarkStackView
    ].forEach {
      self.addSubview($0)
    }
  }

  private func setAutolayout() {
    locationStackView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(64.adaptiveHeight)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.height.equalTo(32.adaptiveHeight)
    }
    descriptionStackView.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveHeight)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.width.equalTo(220.adaptiveWidth)
      $0.height.equalTo(80.adaptiveHeight)
    }
    bookmarkStackView.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveHeight)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.width.equalTo(40.adaptiveWidth)
    }
  }

  private func addAction() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
    self.descriptionTextView.addGestureRecognizer(tapGesture)
  }

  @objc private func textViewDidTapped() {
    isExpanded.toggle()
    if isExpanded {
      self.descriptionTextView.isScrollEnabled = true
      self.descriptionTextView.textContainer.maximumNumberOfLines = 0
      self.descriptionStackView.snp.updateConstraints {
        $0.height.equalTo(228.adaptiveHeight)
      }
    } else {
      self.descriptionTextView.isScrollEnabled = false
      self.descriptionTextView.textContainer.maximumNumberOfLines = 2
      self.descriptionStackView.snp.updateConstraints {
        $0.height.equalTo(80.adaptiveHeight)
      }
    }

    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }
}
