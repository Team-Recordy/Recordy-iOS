//
//  RecentCollectionViewCell.swift
//  Common
//
//  Created by Chandrala on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit

import Core

import Kingfisher
import SnapKit
import Then


public class ThumbnailCollectionViewCell: UICollectionViewCell {

  public let gradientLayer = CAGradientLayer()
  public let gradientView = UIView()
  public let label = UILabel()
  public let backgroundImageView = UIImageView()
  public let locationStackView = UIStackView()
  public let locationText = UILabel()
  public let locationImageView = UIImageView()
  public let bookmarkButton = UIButton()
  public let bookmarkImage = UIImageView()
  public var bookmarkButtonEvent: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = self.bounds
  }

  private func setStyle() {
    self.cornerRadius(12)

    let colors: [UIColor] = [
      .black.withAlphaComponent(0),
      CommonAsset.recordyBG.color.withAlphaComponent(0.5)
    ]

    gradientLayer.do {
      $0.startPoint = CGPoint(x: 0.5, y: 0.0)
      $0.endPoint = CGPoint(x: 0.5, y: 1.0)
      $0.locations = [0.0, 0.3, 1.0]
      $0.colors = colors.map { $0.cgColor }
    }

    locationStackView.do {
      $0.axis = .horizontal
      $0.distribution = .fillProportionally
      $0.alignment = .center
      $0.spacing = 3
    }

    locationText.do {
      $0.text = "최대열글자들어갑니다"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }

    locationImageView.do {
      $0.image = CommonAsset.location.image
    }

    bookmarkButton.do {
      $0.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }

    bookmarkImage.do {
      $0.contentMode = .scaleAspectFit
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 1
      $0.layer.shadowOffset = CGSize(width: 0, height: 2)
      $0.layer.shadowRadius = 4
      $0.clipsToBounds = false
    }
  }
  private func setUI() {
    gradientView.layer.addSublayer(gradientLayer)
    self.addSubviews(
      backgroundImageView,
      gradientView,
      locationStackView,
      bookmarkButton
    )
//    self.bringSubviewToFront(gradientView)
    locationStackView.addArrangedSubview(locationImageView)
    locationStackView.addArrangedSubview(locationText)
    bookmarkButton.addSubview(bookmarkImage)
  }

  private func setAutoLayout() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    gradientView.snp.makeConstraints {
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.height.equalTo(60.adaptiveHeight)
    }

    locationStackView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(9)
      $0.bottom.equalToSuperview().inset(15)
    }
    locationImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.width.equalTo(12.adaptiveWidth)
      $0.height.equalTo(12.adaptiveHeight)
      $0.centerY.equalToSuperview()
    }
    bookmarkButton.snp.makeConstraints {
      $0.width.equalTo(40.adaptiveWidth)
      $0.height.equalTo(40.adaptiveHeight)
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    bookmarkImage.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.equalTo(14.adaptiveWidth)
      $0.height.equalTo(16.adaptiveHeight)
    }
  }

  public func configure(with record: MainRecord) {
    let image = String(record.thumbnailUrl)
    self.backgroundImageView.kf.setImage(
      with: URL(string: image),
      options: [.cacheOriginalImage]
    )
    self.locationText.text = record.location
    self.bookmarkImage.image = record.isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image
  }

  public func configure(feed: Feed) {
    let image = String(feed.thumbnailLink)
    self.backgroundImageView.kf.setImage(
      with: URL(string: image),
      options: [.cacheOriginalImage]
    )
    self.locationText.text = feed.location
    self.bookmarkImage.image = feed.isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image
  }

  @objc private func bookmarkButtonTapped() {
    self.bookmarkButtonEvent?()
  }

  public func updateBookmarkButton(isBookmarked: Bool) {
    self.bookmarkImage.image = isBookmarked ? CommonAsset.bookmarkSelected.image : CommonAsset.bookmarkUnselected.image
  }
}
