//
//  RecordySubtitleLabel.swift
//  Common
//
//  Created by 한지석 on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public class RecordySubtitleLabel: UILabel {

  let subtitle: String

  public init(
    subtitle: String,
    frame: CGRect = .zero
  ) {
    self.subtitle = subtitle
    super.init(frame: frame)
    setStyle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.text = subtitle
    self.font = RecordyFont.subtitle.font
    self.textColor = CommonAsset.recordyWhite.color
  }
}
