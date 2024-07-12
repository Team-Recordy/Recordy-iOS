//
//  RecordyKeywordLabel.swift
//  Common
//
//  Created by 한지석 on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

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
