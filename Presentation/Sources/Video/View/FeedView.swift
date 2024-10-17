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

  enum Constraint {
    static let minimumDescriptionStackViewHeight: CGFloat = 58.adaptiveHeight
    static let maximumDescriptionStackViewHeight: CGFloat = 250.adaptiveHeight
    static let descriptionStackViewSpacing = 8.adaptiveHeight
    static let nicknameButtonHeight = 28.adaptiveHeight
  }

  private let backgroundView = UIView()
  private let backgroundLayer = CAGradientLayer()
  private let bookmarkStackView = UIStackView()
  private let descriptionStackView = UIStackView()
  private let locationStackView = UIStackView()
  private let locationImage = UIImageView()
  let placeButton = UIButton()
  let nicknameButton = UIButton()
  let descriptionTextView = UITextView()
  let deleteButton = UIButton()
  let bookmarkButton = UIButton()
  let bookmarkLabel = UILabel()
  let locationLabel = UILabel()
  let moreButton = UIButton()

  private var isExpanded = false
  var title: String = ""

  override init(frame: CGRect) {
    super.init(frame: frame)

    setStyle()
    setUI()
    setAutolayout()
    addAction()
    checkTextViewTapped()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    backgroundLayer.frame = backgroundView.bounds
  }

  private func setStyle() {
    let colors: [UIColor] = [
      .black.withAlphaComponent(0.01),
      .black
    ]

    backgroundLayer.do {
      $0.startPoint = CGPoint(x: 0.5, y: 0.0)
      $0.endPoint = CGPoint(x: 0.5, y: 1.0)
      $0.locations = [0.0, 0.5, 1.0]
      $0.colors = colors.map { $0.cgColor }
    }

    locationStackView.do {
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

    descriptionStackView.do {
      $0.spacing = 8.adaptiveHeight
      $0.axis = .vertical
      $0.alignment = .leading
    }

    bookmarkStackView.do {
      $0.spacing = 7.adaptiveHeight
      $0.axis = .vertical
      $0.alignment = .center
    }

    placeButton.do {
      var config = UIButton.Configuration.plain()
      config.image = CommonAsset.indicator.image
      config.imagePadding = 4
      config.contentInsets = NSDirectionalEdgeInsets(
        top: 5,
        leading: 10,
        bottom: 5,
        trailing: 10
      )
      config.imagePlacement = .trailing
      var container = AttributeContainer()
      container.font = RecordyFont.caption1.font
      container.foregroundColor = CommonAsset.viskitWhite.color
      config.attributedTitle = AttributedString(
        title,
        attributes: container
      )
      $0.configuration = config

      $0.layer.backgroundColor = (UIColor.black.cgColor).copy(alpha: 0.5)
      $0.layoutMargins = UIEdgeInsets(
        top: 0,
        left: 8,
        bottom: 0,
        right: 8
      )
      $0.cornerRadius(8)
    }

    locationImage.do {
      $0.image = CommonAsset.location.image
      $0.contentMode = .scaleAspectFit
    }

    nicknameButton.do {
      $0.setTitle("닉네임", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = RecordyFont.subtitle.font
    }

    descriptionTextView.do {
      $0.text = "계절이 지나가는 하늘에는 가을로 가득 차 있습니다. 나는 아무 걱정도 없이...더보기"
      $0.textColor = .white
      $0.isEditable = false
      $0.isScrollEnabled = false
      $0.showsVerticalScrollIndicator = false
      $0.textContainer.maximumNumberOfLines = 1
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

    deleteButton.do {
      $0.setImage(CommonAsset.deleteButton.image, for: .normal)
      $0.isHidden = true
    }

    bookmarkButton.do {
      $0.setImage(CommonAsset.bookmarkSelected.image, for: .normal)
    }

    bookmarkLabel.do {
      $0.text = "100"
      $0.textColor = .white
      $0.font = RecordyFont.body2Long.font
    }

    locationLabel.do {
      $0.text = "서울특별시 강남구 테헤란로 123"
      $0.textColor = .white
      $0.font = RecordyFont.caption1.font
    }

    moreButton.do {
      $0.setImage(CommonAsset.seeMore.image, for: .normal)
    }
  }

  private func setUI() {
    backgroundView.layer.addSublayer(backgroundLayer)

    [
      bookmarkButton,
      bookmarkLabel,
      deleteButton
    ].forEach { bookmarkStackView.addArrangedSubview($0) }

    [
      locationImage,
      locationLabel
    ].forEach { locationStackView.addArrangedSubview($0) }

    [
      nicknameButton,
      descriptionTextView
    ].forEach { descriptionStackView.addArrangedSubview($0) }

    [
      descriptionStackView,
      bookmarkStackView,
      locationStackView,
      moreButton
    ].forEach { backgroundView.addSubview($0) }

    [
      placeButton,
      backgroundView
    ].forEach {
      addSubview($0)
    }
  }

  private func setAutolayout() {
    placeButton.snp.makeConstraints {
      $0.leading.equalTo(safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.top.equalTo(safeAreaLayoutGuide).inset(64.adaptiveHeight)
      $0.height.equalTo(32.adaptiveHeight)
    }

    backgroundView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(159.adaptiveHeight)
    }

    descriptionStackView.snp.makeConstraints {
      $0.bottom.equalTo(locationStackView.snp.top).offset(-12.adaptiveHeight)
      $0.leading.equalTo(safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.width.equalTo(250.adaptiveWidth)
      $0.height.equalTo(Constraint.minimumDescriptionStackViewHeight)
    }

    nicknameButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.height.equalTo(28.adaptiveHeight)
    }

    descriptionTextView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.height.greaterThanOrEqualTo(24.adaptiveHeight)
      $0.bottom.equalToSuperview()
    }

    bookmarkStackView.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(40.adaptiveHeight)
      $0.trailing.equalTo(safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.width.equalTo(40.adaptiveWidth)
    }

    locationStackView.snp.makeConstraints {
      $0.leading.equalTo(safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.bottom.equalTo(moreButton.snp.top).offset(8.adaptiveHeight)
      $0.height.equalTo(28.adaptiveHeight)
    }

    locationImage.snp.makeConstraints {
      $0.size.equalTo(16.adaptiveWidth)
    }

    moreButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(10.adaptiveHeight)
      $0.trailing.equalTo(safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.size.equalTo(40.adaptiveHeight)
    }
  }

  private func addAction() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(
        textViewDidTapped
      )
    )
    descriptionTextView.addGestureRecognizer(tapGesture)
  }

  @objc private func textViewDidTapped() {
    isExpanded.toggle()
    updateTextViewHeight()

    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }

  private func updateTextViewHeight() {
    descriptionTextView.isScrollEnabled = isExpanded
    descriptionTextView.textContainer.maximumNumberOfLines = isExpanded ? 0 : 1

    let textViewWidth = descriptionTextView.frame.width
    let size = CGSize(width: textViewWidth, height: .infinity)
    let estimatedSize = descriptionTextView.sizeThatFits(size)

    let maxHeight = isExpanded ? Constraint.maximumDescriptionStackViewHeight : Constraint.minimumDescriptionStackViewHeight
    let newHeight = min(
      estimatedSize.height + Constraint.descriptionStackViewSpacing + Constraint.nicknameButtonHeight,
      maxHeight
    )

    descriptionStackView.snp.updateConstraints { $0.height.equalTo(newHeight) }

    let backgroundHeight = newHeight + nicknameButton.frame.height + 8.adaptiveHeight + 77.adaptiveHeight
    backgroundView.snp.updateConstraints { $0.height.equalTo(backgroundHeight) }
  }

  private func checkTextViewTapped() {
    let textViewWidth = descriptionTextView.frame.width
    let size = CGSize(width: textViewWidth, height: .infinity)
    let estimatedSize = descriptionTextView.sizeThatFits(size)

    let lineHeight = descriptionTextView.font?.lineHeight ?? 0
    let numberOfLines = estimatedSize.height / lineHeight

    if numberOfLines > 1 {
      descriptionTextView.isUserInteractionEnabled = true
    } else {
      descriptionTextView.isUserInteractionEnabled = false
    }
  }

  func updateTitle(_ title: String) {
    self.title = title
    updatePlaceButtonConfiguration()
  }

  private func updatePlaceButtonConfiguration() {
    var config = placeButton.configuration
    var container = AttributeContainer()
    container.font = RecordyFont.caption1.font
    container.foregroundColor = CommonAsset.viskitWhite.color
    config?.attributedTitle = AttributedString(
      title,
      attributes: container
    )
    placeButton.configuration = config
  }
}
