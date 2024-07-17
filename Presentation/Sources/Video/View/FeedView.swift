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

  private let backgroundView = UIView()
  private let backgroundLayer = CAGradientLayer()
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
    $0.alignment = .leading
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
  let nicknameButton = UIButton().then {
    $0.setTitle("닉네임", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = RecordyFont.subtitle.font
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
    setStyle()
    setUI()
    setAutolayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    checkIfTextViewNeedsTap()
    self.backgroundLayer.frame = self.backgroundView.bounds
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
  }

  private func setUI() {
    backgroundView.layer.addSublayer(backgroundLayer)
    bookmarkStackView.addArrangedSubview(bookmarkButton)
    bookmarkStackView.addArrangedSubview(bookmarkLabel)
    locationStackView.addArrangedSubview(locationImage)
    locationStackView.addArrangedSubview(locationLabel)
    descriptionStackView.addArrangedSubview(nicknameButton)
    descriptionStackView.addArrangedSubview(descriptionTextView)
    backgroundView.addSubview(descriptionStackView)
    backgroundView.addSubview(bookmarkStackView)
    [
      backgroundView,
      locationStackView
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
    backgroundView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(200.adaptiveHeight)
    }
    descriptionStackView.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveHeight)
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.width.equalTo(220.adaptiveWidth)
      $0.height.equalTo(90.adaptiveHeight)
    }
    nicknameButton.snp.makeConstraints {
      $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20.adaptiveWidth)
      $0.height.equalTo(28.adaptiveHeight)
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
      self.backgroundView.snp.updateConstraints {
        $0.height.equalTo(338.adaptiveHeight)
      }
    } else {
      self.descriptionTextView.isScrollEnabled = false
      self.descriptionTextView.textContainer.maximumNumberOfLines = 2
      self.descriptionStackView.snp.updateConstraints {
        $0.height.equalTo(90.adaptiveHeight)
      }
      self.backgroundView.snp.updateConstraints {
        $0.height.equalTo(200.adaptiveHeight)
      }
    }

    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }

  private func checkIfTextViewNeedsTap() {
    let textViewWidth = self.descriptionTextView.frame.width
    let size = CGSize(width: textViewWidth, height: .infinity)
    let estimatedSize = self.descriptionTextView.sizeThatFits(size)

    let lineHeight = self.descriptionTextView.font?.lineHeight ?? 0
    let numberOfLines = estimatedSize.height / lineHeight

    if numberOfLines > 2 {
      self.descriptionTextView.isUserInteractionEnabled = true
    } else {
      self.descriptionTextView.isUserInteractionEnabled = false
    }
  }

  func updateDescriptionTextView() {
    checkIfTextViewNeedsTap()
  }
}
