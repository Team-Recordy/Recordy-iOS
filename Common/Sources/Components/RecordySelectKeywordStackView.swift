//
//  RecordySelectKeywordStackView.swift
//  Common
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core

//public final class RecordySelectKeywordStackView: UIStackView {
//  var keywords: [Keyword] = []
//  let first = RecordyKeywordView()
//  let second = RecordyKeywordView()
//  let third = RecordyKeywordView()
//  public let keywordButton = UIButton()
//
//  public override init(frame: CGRect) {
//    super.init(frame: frame)
//    setStyle()
//    setUI()
//    setAutoLayout()
//  }
//
//  required init(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  func setStyle() {
//    self.axis = .horizontal
//    self.spacing = 8
//    self.alignment = .center
//    self.distribution = .equalSpacing
//    first.do {
//      $0.isHidden = true
//    }
//    second.do {
//      $0.isHidden = true
//    }
//    third.do {
//      $0.isHidden = true
//    }
//    keywordButton.setImage(CommonAsset.keywordButton.image, for: .normal)
//  }
//
//  func setUI() {
//    self.addArrangedSubview(first)
//    self.addArrangedSubview(second)
//    self.addArrangedSubview(third)
//    self.addArrangedSubview(keywordButton)
//  }
//
//  func setAutoLayout() {
//    first.snp.makeConstraints {
//      $0.height.equalTo(36.adaptiveHeight)
//    }
//    second.snp.makeConstraints {
//      $0.height.equalTo(36.adaptiveHeight)
//    }
//    third.snp.makeConstraints {
//      $0.height.equalTo(36.adaptiveHeight)
//    }
//    keywordButton.snp.makeConstraints {
//      $0.width.equalTo(75.adaptiveWidth)
//      $0.height.equalTo(36.adaptiveHeight)
//    }
//  }
//
//  public func updateKeywords(keywords: [Keyword]) {
//    self.keywords = keywords
//    switch keywords.count {
//    case 0:
//      first.isHidden = true
//      second.isHidden = true
//      third.isHidden = true
//    case 1:
//      first.isHidden = false
//      first.keyword.text = keywords[0].title
//      first.snp.remakeConstraints {
//        $0.width.equalTo(keywords[0].width)
//        $0.height.equalTo(36.adaptiveHeight)
//      }
//      second.isHidden = true
//      third.isHidden = true
//    case 2:
//      first.isHidden = false
//      first.keyword.text = keywords[0].title
//      first.snp.remakeConstraints {
//        $0.width.equalTo(keywords[0].width)
//        $0.height.equalTo(36.adaptiveHeight)
//      }
//      second.isHidden = false
//      second.keyword.text = keywords[1].title
//      second.snp.remakeConstraints {
//        $0.width.equalTo(keywords[1].width)
//        $0.height.equalTo(36.adaptiveHeight)
//      }
//      third.isHidden = true
//    case 3:
//      first.isHidden = false
//      first.keyword.text = keywords[0].title
//      first.snp.remakeConstraints {
//        $0.width.equalTo(keywords[0].width)
//        $0.height.equalTo(36.adaptiveHeight)
//      }
//      second.isHidden = false
//      second.keyword.text = keywords[1].title
//      second.snp.remakeConstraints {
//        $0.width.equalTo(keywords[1].width)
//        $0.height.equalTo(36.adaptiveHeight)
//      }
//      third.isHidden = false
//      third.keyword.text = keywords[2].title
//      third.snp.remakeConstraints {
//        $0.width.equalTo(keywords[2].width)
//        $0.height.equalTo(36.adaptiveHeight)
//      }
//    default:
//      first.isHidden = true
//      second.isHidden = true
//      third.isHidden = true
//    }
//  }
//}
