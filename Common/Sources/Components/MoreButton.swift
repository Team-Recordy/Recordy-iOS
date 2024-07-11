//
//  moreButton.swift
//  Common
//
//  Created by Chandrala on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public final class MoreButton: UIButton {
  
  let moreText = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    
    self.backgroundColor = .red
    
    moreText.do {
      $0.text = "더보기"
      $0.font = RecordyFont.caption1.font
      $0.textColor = CommonAsset.recordyGrey04.color
      $0.underlineText(forText: "더보기")
    }
  }
  
  func setUI() {
    self.addSubviews(
      moreText
    )
  }
  
  func setLayout() {
    moreText.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

