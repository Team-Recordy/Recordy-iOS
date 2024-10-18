//
//  MyRecordEmptyView.swift
//  Presentation
//
//  Created by 송여경 on 10/19/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import UIKit
import SnapKit
import Then

import Common

class MyRecordEmptyView: UIView {
  private let imageView = UIImageView()
  private let textLabel = UILabel()
  private let goRecordButton = ViskitYellowButton()
  
  var onRecordButtonTapped: (() -> Void)?
  
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
    
    textLabel.do {
      let text = "직접 방문한 공간 영상을\n공유해 보세요!"
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
    
    goRecordButton.do {
      $0.setTitle("영상 업로드하기", for: .normal)
      $0.addTarget(self, action: #selector(goRecordButtonTapped), for: .touchUpInside)
    }
  }
  
  private func setUI() {
    [
      imageView,
      textLabel,
      goRecordButton
    ].forEach { addSubview($0) }
  }
  
  private func setAutoLayout() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(111)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(110.adaptiveWidth)
      $0.height.equalTo(97.adaptiveHeight)
    }
    
    textLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(14)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(94)
    }
    
    goRecordButton.snp.makeConstraints {
      $0.top.equalTo(textLabel.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(125.adaptiveWidth)
      $0.height.equalTo(44.adaptiveHeight)
    }
  }
  
  @objc private func goRecordButtonTapped() {
    onRecordButtonTapped?()
  }
}
