//
//  BookMarkView.swift
//  Presentation
//
//  Created by 송여경 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Common

class BookMarkView: UIView {
  private let bookmarkEmptyView = UIView()
  private let bookmarkDataView = UIView()
  
  let bookmarkEmptyImageView = UIImageView()
  let bookmarkEmptyTextVIew = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
    checkDataEmpty()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func setStyle() {
    self.backgroundColor = .black
    bookmarkEmptyImageView.do {
      $0.image = CommonAsset.mypagebookmark.image
      $0.contentMode = .scaleAspectFit
    }
    bookmarkEmptyTextVIew.do {
      $0.image = CommonAsset.bookmarkText.image
    }
  }
  
  private func setUI() {
    self.addSubview(bookmarkEmptyView)
    self.addSubview(bookmarkDataView)
    
    bookmarkEmptyView.addSubview(bookmarkEmptyImageView)
    bookmarkEmptyView.addSubview(bookmarkEmptyTextVIew)
  }
  
  private func setAutoLayout() {
    bookmarkEmptyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(115)
      $0.leading.equalTo(138)
      $0.width.equalTo(100.adaptiveWidth)
      $0.height.equalTo(100.adaptiveHeight)
    }
    bookmarkEmptyTextVIew.snp.makeConstraints {
      $0.top.equalTo(bookmarkEmptyImageView.snp.bottom).offset(18)
      $0.leading.equalTo(65)
    }
  }
  private func checkDataEmpty() {
    
  }
}
