//
//  BookMarkEmptyView.swift
//  Presentation
//
//  Created by 송여경 on 10/19/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit
import SnapKit
import Then

import Common

class BookMarkEmptyView: UIView {
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let goAroundButton = ViskitYellowButton()
  
  private var actionButtonHandler: (() -> Void)?
  
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
    
    imageView.do {
      $0.image = CommonAsset.ledyEmpty.image
      $0.contentMode = .scaleAspectFit
    }
    
    titleLabel.do {
      let text = "북마크한 영상이 없어요.\n영상을 둘러보고 저장해 보세요!"
      $0.numberOfLines = 0
      $0.textColor = CommonAsset.viskitGray02.color
      $0.font = ViskitFont.title2.font
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 30 - $0.font.lineHeight
      paragraphStyle.alignment = .center
      
      let attributedString = NSAttributedString(
        string: text,
        attributes: [
          .paragraphStyle: paragraphStyle,
          .font: ViskitFont.title2.font,
          .foregroundColor: CommonAsset.viskitGray02.color
        ]
      )
      $0.attributedText = attributedString
      $0.textAlignment = .center
    }
    
    goAroundButton.do {
      $0.setTitle("영상 둘러보기", for: .normal)
    }
  }
  
  private func setUI() {
    [
      imageView,
      titleLabel,
      goAroundButton
    ].forEach { addSubview($0) }
  }
  
  private func setAutoLayout() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(111)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(110.adaptiveWidth)
      $0.height.equalTo(97.adaptiveHeight)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(14)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(65)
    }
    
    goAroundButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(113.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
    }
  }
  
  func setActionButtonHandler(_ handler: @escaping () -> Void) {
    goAroundButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    self.actionButtonHandler = handler
  }
  
  @objc private func actionButtonTapped() {
    actionButtonHandler?()
  }
}
