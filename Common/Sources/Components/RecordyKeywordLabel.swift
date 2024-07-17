//
//  RecordyKeywordLabel.swift
//  Common
//
//  Created by 한지석 on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public class RecordyKeywordView: UIView {
  let keyword = UILabel()
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.keyword.do {
      $0.textAlignment = .center
      $0.font = RecordyFont.button2.font
      $0.textColor = CommonAsset.recordyMain.color
    }
    self.backgroundColor = CommonAsset.recordyMain.color.withAlphaComponent(0.2)
    self.layer.borderColor = CommonAsset.recordyMain.color.cgColor
    self.layer.borderWidth = 1
    self.cornerRadius(16)
  }

  func setUI() {
    self.addSubview(keyword)
  }

  func setAutoLayout() {
    self.keyword.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(8.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(6.adaptiveWidth)
    }
  }
}

public class RecordyKeywordLabel: UILabel {

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setStyle() {
    self.textAlignment = .center
    self.font = RecordyFont.button2.font
    self.textColor = CommonAsset.recordyMain.color
    self.backgroundColor = CommonAsset.recordyMain.color.withAlphaComponent(0.2)
    self.layer.borderColor = CommonAsset.recordyMain.color.cgColor
    self.layer.borderWidth = 1
    self.cornerRadius(20)
  }

}
