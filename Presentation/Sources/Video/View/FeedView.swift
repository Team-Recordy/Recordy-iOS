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
  let locationLabel = UILabel().then {
    $0.text = "서울특별시 강남구 테헤란로 123"
    $0.textColor = .white
  }
  private let locationImage = UIImageView()
  let nicknameLabel = UILabel().then {
    $0.text = "닉네임"
    $0.textColor = .white
  }
  let descriptionLabel = UILabel().then {
    $0.text = "계절이 지나가는 하늘에는 가을로 가득 차 있습니다. 나는 아무 걱정도 없이...더보기"
    $0.textColor = .white
  }
  let bookmarkButton = UIButton().then {
    $0.setImage(CommonAsset.bookmarkSelected.image, for: .normal)
  }
  let bookmarkLabel = UILabel().then {
    $0.text = "100"
    $0.textColor = .white
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setAutolayout()
    setStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    let blurEffect = UIBlurEffect(style: .systemMaterialDark)
    let visualEffectView = UIVisualEffectView(effect: blurEffect)

    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3)

    self.locationStackView.insertSubview(backgroundView, at: 0)
    self.locationStackView.insertSubview(visualEffectView, at: 0)

    backgroundView.snp.makeConstraints {
        $0.edges.equalToSuperview()
    }
    visualEffectView.snp.makeConstraints {
        $0.edges.equalToSuperview()
    }
  }

  private func setUI() {
    bookmarkStackView.addArrangedSubview(bookmarkButton)
    bookmarkStackView.addArrangedSubview(bookmarkLabel)
    locationStackView.addArrangedSubview(locationImage)
    locationStackView.addArrangedSubview(locationLabel)
    descriptionStackView.addArrangedSubview(nicknameLabel)
    descriptionStackView.addArrangedSubview(descriptionLabel)
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
    }
    bookmarkStackView.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveHeight)
      $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.width.equalTo(40.adaptiveWidth)
    }
  }
}
